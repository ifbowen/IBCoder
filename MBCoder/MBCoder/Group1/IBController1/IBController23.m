//
//  IBController23.m
//  IBCoder1
//
//  Created by Bowen on 2018/5/17.
//  Copyright © 2018年 BowenCoder. All rights reserved.
//

#import "IBController23.h"

@interface IBController23 ()

@end

@implementation IBController23

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

@end

/*
 
 Edit scheme -> Run -> Arguments 中
 简略的时间：环境变量 DYLD_PRINT_STATISTICS 设为 1
 详细的时间，环境变量 DYLD_PRINT_STATISTICS_DETAILS 设为 1
 
 启动：冷启动、热启动
 
 简而言之：APP启动主要流程: 点击icon -> 加载动态链接库等 -> 映像文件加载imageLoader ->  runtime -> load  -> main -> delegate.
 
 什么是ImageLoader
 image 表示一个二进制文件(可执行文件或 so 文件)，里面是被编译过的符号、代码等，
 所以 ImageLoader 作用是将这些文件加载进内存，且每一个文件对应一个ImageLoader实例来负责加载。
 两步走: 在程序运行时它先将动态链接的 image 递归加载 (也就是上面测试栈中一串的递归调用的时刻)。
        再从可执行文件 image 递归加载所有符号。

 动态链接库的加载步骤
 1）load dylibs image 读取库镜像文件
 2）Rebase image 重定位镜像
 3）Bind image 组装镜像
 4）Objc setup 设置对象
 5）initializers 初始化

 一、理论
 1、Mach-O
 文件类型:
 Executable：应用的主要二进制
 Dylib Library：动态链接库（又称DSO或DLL）
 Static Library：静态链接库
 Bundle：不能被链接的Dylib，只能在运行时使用dlopen( )加载，可当做macOS的插件
 Relocatable Object File ：可重定向文件类型

 2、通用二进制格式（Universal Binary）、胖二进制格式（Fat Binary）
 释义：
 苹果公司提出的一种程序代码。能同时适用多种架构的二进制文件
 同一个程序包中同时为多种架构提供最理想的性能。
 因为需要储存多种代码，通用二进制应用程序通常比单一平台二进制的程序要大。
 但是由于两种架构有共通的非执行资源，所以并不会达到单一版本的两倍之多。
 而且由于执行中只调用一部分代码，运行起来也不需要额外的内存
 
 3、Mach-O的组成结构
 Mach-O 头（Mach Header）：这里描述了 Mach-O 的 CPU 架构、文件类型以及加载命令等信息；
 加载命令（Load Command）：描述了文件中数据的具体组织结构，不同的数据类型使用不同的加载命令表示；
 数据区（Data）：Data 中每一个段（Segment）的数据都保存在此，段的概念和 ELF 文件中段的概念类似，都拥有一个或多个 Section ，用来存放数据和代码。

 3.1 Mach-O 头（Mach Header）
 struct mach_header_64 {
     uint32_t       magic;         // mach magic 标识符
     cpu_type_t     cputype;       // CPU 类型标识符，同通用二进制格式中的定义
     cpu_subtype_t  cpusubtype;    // CPU 子类型标识符，同通用二级制格式中的定义
     uint32_t       filetype;      // 文件类型
     uint32_t       ncmds;         // 加载器中加载命令的条数
     uint32_t       sizeofcmds;    // 加载器中加载命令的总大小
     uint32_t       flags;         // dyld 的标志
     uint32_t       reserved;      // 64 位的保留字段
 }
 
 filetype 文件类型
 #define    MH_OBJECT      0x1        // Target 文件：编译器对源码编译后得到的中间结果
 #define    MH_EXECUTE     0x2        // 可执行二进制文件
 #define    MH_FVMLIB      0x3        // VM 共享库文件
 #define    MH_CORE        0x4        // Core 文件，一般在 App Crash 产生
 #define    MH_PRELOAD     0x5        // preloaded executable file
 #define    MH_DYLIB       0x6        // 动态库
 #define    MH_DYLINKER    0x7        // 动态连接器 /usr/lib/dyld
 #define    MH_BUNDLE      0x8        // 非独立的二进制文件，往往通过 gcc-bundle 生成
 #define    MH_DYLIB_STUB  0x9        // 静态链接文件
 #define    MH_DSYM        0xa        // 符号文件以及调试信息，在解析堆栈符号中常用
 #define    MH_KEXT_BUNDLE 0xb        // x86_64 内核扩展
 
 flags 定义
 #define    MH_NOUNDEFS              0x1        // Target 文件中没有带未定义的符号，常为静态二进制文件
 #define    MH_SPLIT_SEGS            0x20       // Target 文件中的只读 Segment 和可读写 Segment 分开
 #define    MH_TWOLEVEL              0x80       // 该 Image 使用二级命名空间(two name space binding)绑定方案
 #define    MH_FORCE_FLAT            0x100      // 使用扁平命名空间(flat name space binding)绑定（与 MH_TWOLEVEL 互斥）
 #define    MH_WEAK_DEFINES          0x8000     // 二进制文件使用了弱符号
 #define    MH_BINDS_TO_WEAK         0x10000    // 二进制文件链接了弱符号
 #define    MH_ALLOW_STACK_EXECUTION 0x20000    // 允许 Stack 可执行
 #define    MH_PIE                   0x200000   // 对可执行的文件类型启用地址空间 layout 随机化
 #define    MH_NO_HEAP_EXECUTION     0x1000000  // 将 Heap 标记为不可执行，可防止 heap spray 攻击
 
 3.2 加载命令（Load Command）
 Load Commands 是跟在 Header 后面的加载命令区，所有 commands 的大小总和即为 Header->sizeofcmds 字段，共有 Header->ncmds 条加载命令
 struct load_command {
     uint32_t cmd;        // 命令类型
     uint32_t cmdsize;    // 命令长度
 };
 这些加载命令告诉系统应该如何处理后面的二进制数据，对系统内核加载器和动态链接器起指导作用。
 如果当前 LC_SEGMENT 包含 section，那么 section 的结构体紧跟在 LC_SEGMENT 的结构体之后，
 所占字节数由 SEGMENT 的 cmdsize 字段给出
 
 常用命令
 LC_SEGMENT/LC_SEGMENT_64          将对应的段中的数据加载并映射到进程的内存空间去
 LC_SYMTAB                         符号表信息
 LC_DYSYMTAB                       动态符号表信息
 LC_LOAD_DYLINKER                  启动动态加载连接器/usr/lib/dyld程序
 LC_UUID                           唯一的 UUID，标示该二进制文件，128bit
 LC_VERSION_MIN_IPHONEOS/MACOSX    要求的最低系统版本（Xcode中的Deployment Target）
 LC_MAIN                           设置程序主线程的入口地址和栈大小
 LC_ENCRYPTION_INFO                加密信息
 LC_LOAD_DYLIB                     加载的动态库，包括动态库地址、名称、版本号等
 LC_FUNCTION_STARTS                函数地址起始表
 LC_CODE_SIGNATURE                 代码签名信息
 
 3.3 数据区（Data）：由 Segment 段和 Section 节组成
 
 #define    SEG_PAGEZERO   "__PAGEZERO"  // 当时 MH_EXECUTE 文件时，捕获到空指针
 #define    SEG_TEXT       "__TEXT"      // 代码/只读数据段
 #define    SEG_DATA       "__DATA"      // 数据段
 #define    SEG_OBJC       "__OBJC"      // Objective-C runtime 段
 #define    SEG_LINKEDIT   "__LINKEDIT"  // 包含需要被动态链接器使用的符号和其他表，包括符号表、字符串表等
 
 Segment 的数据结构
 struct segment_command_64 {
     uint32_t    cmd;           // LC_SEGMENT_64
     uint32_t    cmdsize;       // section_64 结构体所需要的空间
     char        segname[16];   // segment 名字，上述宏中的定义
     uint64_t    vmaddr;        // 所描述段的虚拟内存地址
     uint64_t    vmsize;        // 为当前段分配的虚拟内存大小
     uint64_t    fileoff;       // 当前段在文件中的偏移量
     uint64_t    filesize;      // 当前段在文件中占用的字节
     vm_prot_t    maxprot;      // 段所在页所需要的最高内存保护，用八进制表示
     vm_prot_t    initprot;     // 段所在页原始内存保护
     uint32_t    nsects;        // 段中 Section 数量
     uint32_t    flags;         // 标识符
 };
 
 部分的 Segment （主要指的 __TEXT 和 __DATA）可以进一步分解为 Section。
 之所以按照 Segment -> Section 的结构组织方式，
 是因为在同一个 Segment 下的 Section，可以控制相同的权限，也可以不完全按照 Page 的大小进行内存对其，节省内存的空间。
 而 Segment 对外整体暴露，在程序载入阶段映射成一个完整的虚拟内存，更好的做到内存对齐
 
 struct section_64 {
     char        sectname[16];   // Section 名字
     char        segname[16];    // Section 所在的 Segment 名称
     uint64_t    addr;           // Section 所在的内存地址
     uint64_t    size;           // Section 的大小
     uint32_t    offset;         // Section 所在的文件偏移
     uint32_t    align;          // Section 的内存对齐边界 (2 的次幂)
     uint32_t    reloff;         // 重定位信息的文件偏移
     uint32_t    nreloc;         // 重定位条目的数目
     uint32_t    flags;          // 标志属性
     uint32_t    reserved1;      // 保留字段1
     uint32_t    reserved2;      // 保留字段2
     uint32_t    reserved3;      // 保留字段3
 };
 
 常见的session
 __TEXT.__text              主程序代码
 __TEXT.__cstring           C 语言字符串
 __TEXT.__const             const 关键字修饰的常量
 __TEXT.__stubs             用于 Stub 的占位代码，很多地方称之为桩代码。
 __TEXT.__stubs_helper      当 Stub 无法找到真正的符号地址后的最终指向
 __DATA.__data              初始化过的可变数据
 __DATA.__la_symbol_ptr     lazy binding 的指针表，表中的指针一开始都指向 __stub_helper
 __DATA.nl_symbol_ptr       非 lazy binding 的指针表，每个表项中的指针都指向一个在装载过程中，被动态链机器搜索完成的符号
 __DATA.__const             没有初始化过的常量
 __DATA.__cfstring          程序中使用的 Core Foundation 字符串（CFStringRefs）
 __DATA.__bss               BSS，存放为初始化的全局变量，即常说的静态内存分配
 __DATA.__common            没有初始化过的符号声明
 __TEXT.__objc_methname     Objective-C 方法名称
 __TEXT.__objc_methtype     Objective-C 方法类型
 __TEXT.__objc_classname    Objective-C 类名称
 __DATA.__objc_classlist    Objective-C 类列表
 __DATA.__objc_protolist    Objective-C 原型
 __DATA.__objc_imginfo      Objective-C 镜像信息
 __DATA.__objc_selfrefs     Objective-C self 引用
 __DATA.__objc_protorefs    Objective-C 原型引用
 __DATA.__objc_superrefs    Objective-C 超类引用
 
 Stub 机制。设置函数占位符并采用 lazy 思想做成延迟 binding 的流程。
 在 macOS 中也是如此，外部函数引用在 __DATA 段的 __la_symbol_ptr 区域先生产一个占位符，
 当第一个调用启动时，就会进入符号的动态链接过程，一旦找到地址后，
 就将 __DATA Segment 中的 __la_symbol_ptr Section 中的占位符修改为方法的真实地址，
 这样就完成了只需要一个符号绑定的执行过程。fishhook使用此原理
 
 
 二、pre-main阶段的优化
 要对pre-main阶段的耗时做优化，需要再学习下dyld加载的过程，根据Apple在WWDC上的介绍，dyld的加载主要分为4步：
 
 1. Load dylibs
 1）分析应用依赖的dylib，
 2）找到动态库mach-o文件，
 3）打开和读取这些文件并验证其有效性，
 4）接着会找到代码签名注册到内核，
 5）最后对dylib的每个段(segment)调用mmap函数(内存映射文件的方法)。
 
 所以，依赖的dylib越少越好。在这一步，我们可以做的优化有：
 1)尽量不使用内嵌（embedded）的dylib，加载内嵌dylib性能开销较大
 2)合并已有的dylib和使用静态库（static archives），减少dylib的使用个数
 3)懒加载dylib，但是要注意dlopen()可能造成一些问题，且实际上懒加载做的工作会更多
 
 2. Rebase/Bind
 在dylib的加载过程中，系统为了安全考虑，引入了ASLR（Address Space Layout Randomization）技术和代码签名。
 由于ASLR的存在，镜像（Image，包括可执行文件、dylib和bundle）会在随机的地址上加载，
 和之前指针指向的地址（preferred_address）会有一个偏差（slide），dyld需要修正这个偏差，来指向正确的地址。
 Rebase在前，Bind在后，Rebase做的是将镜像读入内存，修正镜像内部的指针，性能消耗主要在IO。
 Bind做的是查询符号表，设置指向镜像外部的指针，性能消耗主要在CPU计算。
 所以，指针数量越少越好。在这一步，我们可以做的优化有：
 1)减少ObjC类（class）、方法（selector）、分类（category）的数量
 2)减少C++虚函数的的数量（创建虚函数表有开销）
 3)使用Swift structs（内部做了优化，符号数量更少）
 
 3. Objc setup
 主要是在objc_init完成的，主要工作：
 1）注册Objc类
 2）把category的定义插入方法列表
 3）保证每一个selector唯一
 在这一步倒没什么优化可做的，Rebase/Bind阶段优化好了，这一步的耗时也会减少。
 
 void _objc_init(void)
 {
     environ_init();
     tls_init();
     static_init();
     runtime_init();
     exception_init();
     cache_init();
     _imp_implementationWithBlock_init();

     _dyld_objc_notify_register(&map_images, load_images, unmap_image);
  }
 
 4. Initializers
 到了这一阶段，dyld开始运行程序的初始化函数，调每个Objc类和分类+load方法，
 调C/C++中的构造器函数（用attribute((constructor))修饰的函数），和创建非基本类型的C++静态全局变量。
 Initializers阶段执行完后，dyld开始调用main()函数。
 在这一步，我们可以做的优化有：
 1)少在类的+load方法里做事情，尽量把这些事情推迟到+initiailize
 2)减少C++构造器函数个数，在构造器函数里少做些事情
 3)减少C++静态全局变量的个数
 
 三、post-main阶段的优化
 这一阶段的优化主要是减少didFinishLaunchingWithOptions方法里的工作，在didFinishLaunchingWithOptions方法里，
 我们会创建应用的window，指定其rootViewController，调用window的makeKeyAndVisible方法让其可见。
 由于业务需要，我们会初始化各个二方/三方库，设置系统UI风格，检查是否需要显示引导页、是否需要登录、是否有新版本等，
 由于历史原因，这里的代码容易变得比较庞大，启动耗时难以控制。
 
 所以，满足业务需要的前提下，didFinishLaunchingWithOptions在主线程里做的事情越少越好。在这一步，我们可以做的优化有：
 1）梳理各个二方/三方库，找到可以延迟加载的库，做延迟加载处理，比如放到首页控制器的viewDidAppear方法里。
 2）梳理业务逻辑，把可以延迟执行的逻辑，做延迟执行处理。比如检查新版本、注册推送通知等逻辑。
 3）避免复杂/多余的计算。
 4）避免在首页控制器的viewDidLoad和viewWillAppear做太多事情，部分可以延迟创建的视图应做延迟创建和懒加载处理。
 5）采用性能更好的API。
 6）首页控制器用纯代码方式来构建，不要使用xib文件
 
 */
