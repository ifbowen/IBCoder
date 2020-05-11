//
//  IBGroup2Controller24.m
//  MBCoder
//
//  Created by BowenCoder on 2020/2/19.
//  Copyright © 2020 inke. All rights reserved.
//

#import "IBGroup2Controller24.h"

@interface IBGroup2Controller24 ()

@end

@implementation IBGroup2Controller24

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

/*
 一、系统的优化
 1、__builtin_expect(EXP, N)的作用[意思是：EXP==N的概率很大]
 帮助程序处理分支预测，达到优化程序。
 a、处理器一般采用流水线模式，有些里面有多个逻辑运算单元，系统可以提前取多条指令进行并行处理，
    但遇到跳转时，则需要重新取指令，这相对于不用重新去指令就降低了速度。
 b、作用优化分支（比如if）处理。
 
 例子：
 if (__builtin_expect(x, 0)) {
    return 1;
 } else {
    return 2;
 }
 
 x的期望值为0，也就是x有很大概率为0， 所以走if分支的可能性较小，所以编译会这样编译
 
 if (!x) {
    return 2;
 } else {
    return 1;
 }
 
 每次cpu都能大概率的执行到预取的编译后的if分支，从而提高了分支的预测准确性，从而提高了cpu指令的执行速度
 
 2、总结：
 likely(x)也叫fastpath __builtin_expect(!!(x), 1) 该条件多数情况下会发生
 unlikely(x)也叫slowpath  __builtin_expect(!!(x), 0) 该条件下极少发生
 
 二、LLVM架构
 
 1、LLVM架构
 Language       Frontend               Optimizer               Backend             机器
  C/C++..    Clang Frontend                                  LLVM X86 Backend      X86
  Fortran   llvm-gcc Frontend        LLVM Optimizer        LLVM PowerPC Backend   PowerPC
  Haskell     GHC Frontend                                   LLVM ARM Backend      ARM
 
 不同的前端后端使用统一的中间代码LLVM Intermediate Representation (LLVM IR)
 a.如果需要支持一种新的编程语言，那么只需要实现一个新的前端
 b.如果需要支持一种新的硬件设备，那么只需要实现一个新的后端
 c.优化阶段是一个通用的阶段，它针对的是统一的LLVM IR，不论是支持新的编程语言，还是支持新的硬件设备，都不需要对优化阶段做修改
 d.相比之下，GCC的前端和后端没分得太开，前端后端耦合在了一起。所以GCC为了支持一门新的语言，或者为了支持一个新的目标平台，就 变得特别困难
 e.LLVM现在被作为实现各种静态和运行时编译语言的通用基础结构
 
 2、各端作用
 Frontend：前端，词法分析、语法分析、语义分析、生成中间代码(LLVM IR)
 在这个过程中，会进行类型检查，如果发现错误或者警告会标注出来在哪一行。
 
 Optimizer：优化器，中间代码优化
 
 
 Backend：后端，生成机器码
 LVVM优化器会进行BitCode的生成，链接期优化等等。
 LLVM机器码生成器会针对不同的架构，比如arm64等生成不同的机器码。
 
 3、Clang
 LLVM项目的一个子项目，LLVM架构的C/C++/Objective-C编译器前端，官网:http://clang.llvm.org/
 
 相比于GCC，Clang具有如下优点
 编译速度快:在某些平台上，Clang的编译速度显著的快过GCC(Debug模式下编译OC速度比GGC快3倍)
 占用内存小:Clang生成的AST所占用的内存是GCC的五分之一左右
 模块化设计:Clang采用基于库的模块化设计，易于 IDE 集成及其他用途的重用
 诊断信息可读性强:在编译过程中，Clang 创建并保留了大量详细的元数据 (metadata)，有利于调试和错误报告
 设计清晰简单，容易理解，易于扩展增强
 
 4、OC源文件的编译过程，测试文件（llvm.c）
 
 #define bowen 3

 #include <stdio.h>

 int test(int a, int b) {
     int c = a + b - bowen;
     return c;
 }
 
 4.1 命令行查看编译的过程:$ clang -ccc-print-phases llvm.c
 
 0: input, "llvm.c", c
 1: preprocessor, {0}, cpp-output
 2: compiler, {1}, ir
 3: backend, {2}, assembler
 4: assembler, {3}, object
 5: linker, {4}, image
 6: bind-arch, "x86_64", {5}, image
 
 1）预处理：
 这阶段的工作主要是头文件导入，宏展开/替换，预编译指令处理，以及注释的去除。

 2）编译：
 这阶段做的事情比较多，主要有：
 a. 词法分析（Lexical Analysis）：将代码转换成一系列 token
 b. 语法分析（Semantic Analysis）：将 token 流组成抽象语法树 AST；
 c. 静态分析（Static Analysis）：检查代码错误，例如参数类型是否错误，调用对象方法是否有实现；
 d. 中间代码生成（Code Generation）：将语法树自顶向下遍历逐步翻译成 LLVM IR。

 3）生成汇编代码：
 LLVM 将 LLVM IR 生成当前平台的汇编代码，期间 LLVM 根据编译设置的优化级别 Optimization Level 做对应的优化（Optimize）

 4）生成目标文件：
 汇编器（Assembler）将汇编代码转换为机器代码，它会创建一个目标对象文件，以 .o 结尾。
 
 5）链接：
 链接器（Linker）把若干个目标文件链接在一起，生成可执行文件。
 
 4.2 查看preprocessor(预处理)的结果:$ clang -E llvm.c
 
 4.3 词法分析，生成Token: $ clang -fmodules -E -Xclang -dump-tokens llvm.c
 ????
     ?'        Loc=<llvm.c:11:1>
 int 'int'     [StartOfLine]    Loc=<llvm.c:13:1>
 identifier 'test'     [LeadingSpace]    Loc=<llvm.c:13:5>
 l_paren '('        Loc=<llvm.c:13:9>
 int 'int'        Loc=<llvm.c:13:10>
 identifier 'a'     [LeadingSpace]    Loc=<llvm.c:13:14>
 comma ','        Loc=<llvm.c:13:15>
 int 'int'     [LeadingSpace]    Loc=<llvm.c:13:17>
 identifier 'b'     [LeadingSpace]    Loc=<llvm.c:13:21>
 r_paren ')'        Loc=<llvm.c:13:22>
 l_brace '{'     [LeadingSpace]    Loc=<llvm.c:13:24>
 int 'int'     [StartOfLine] [LeadingSpace]    Loc=<llvm.c:14:5>
 identifier 'c'     [LeadingSpace]    Loc=<llvm.c:14:9>
 equal '='     [LeadingSpace]    Loc=<llvm.c:14:11>
 identifier 'a'     [LeadingSpace]    Loc=<llvm.c:14:13>
 plus '+'     [LeadingSpace]    Loc=<llvm.c:14:15>
 identifier 'b'     [LeadingSpace]    Loc=<llvm.c:14:17>
 minus '-'     [LeadingSpace]    Loc=<llvm.c:14:19>
 numeric_constant '3'     [LeadingSpace]    Loc=<llvm.c:14:21 <Spelling=llvm.c:9:15>>
 semi ';'        Loc=<llvm.c:14:26>
 return 'return'     [StartOfLine] [LeadingSpace]    Loc=<llvm.c:15:5>
 identifier 'c'     [LeadingSpace]    Loc=<llvm.c:15:12>
 semi ';'        Loc=<llvm.c:15:13>
 r_brace '}'     [StartOfLine]    Loc=<llvm.c:16:1>
 eof ''        Loc=<llvm.c:16:2>

 4.4 语法分析，生成语法树(AST，Abstract Syntax Tree): $ clang -fmodules -fsyntax-only -Xclang -ast-dump llvm.c
 
 -ImportDecl 0x7fe00911e960 <llvm.c:11:1> col:1 implicit Darwin.C.stdio
 |-FunctionDecl 0x7fe00911eb30 <line:13:1, line:16:1> line:13:5 test 'int (int, int)'
 | |-ParmVarDecl 0x7fe00911e9b0 <col:10, col:14> col:14 used a 'int'
 | |-ParmVarDecl 0x7fe00911ea28 <col:17, col:21> col:21 used b 'int'
 | `-CompoundStmt 0x7fe00911edf0 <col:24, line:16:1>
 |   |-DeclStmt 0x7fe00911ed78 <line:14:5, col:26>
 |   | `-VarDecl 0x7fe00911ec48 <col:5, line:9:15> line:14:9 used c 'int' cinit
 |   |   `-BinaryOperator 0x7fe00911ed58 <col:13, line:9:15> 'int' '-'
 |   |     |-BinaryOperator 0x7fe00911ed18 <line:14:13, col:17> 'int' '+'
 |   |     | |-ImplicitCastExpr 0x7fe00911ece8 <col:13> 'int' <LValueToRValue>
 |   |     | | `-DeclRefExpr 0x7fe00911eca8 <col:13> 'int' lvalue ParmVar 0x7fe00911e9b0 'a' 'int'
 |   |     | `-ImplicitCastExpr 0x7fe00911ed00 <col:17> 'int' <LValueToRValue>
 |   |     |   `-DeclRefExpr 0x7fe00911ecc8 <col:17> 'int' lvalue ParmVar 0x7fe00911ea28 'b' 'int'
 |   |     `-IntegerLiteral 0x7fe00911ed38 <line:9:15> 'int' 3
 |   `-ReturnStmt 0x7fe00911ede0 <line:15:5, col:12>
 |     `-ImplicitCastExpr 0x7fe00911edc8 <col:12> 'int' <LValueToRValue>
 |       `-DeclRefExpr 0x7fe00911ed90 <col:12> 'int' lvalue Var 0x7fe00911ec48 'c' 'int'
 `-<undeserialized declarations>
 
 4.4 中间代码（LLVM IR）
 
 LLVM IR有3种表示形式
 text:便于阅读的文本格式，类似于汇编语言，拓展名.ll， $ clang -S -emit-llvm llvm.c
 memory:内存格式
 bitcode:二进制格式，拓展名.bc， $ clang -c -emit-llvm llvm.c
 
 未优化的代码IR：
 define i32 @test(i32, i32) #0 {
   %3 = alloca i32, align 4
   %4 = alloca i32, align 4
   %5 = alloca i32, align 4
   store i32 %0, i32* %3, align 4
   store i32 %1, i32* %4, align 4
   %6 = load i32, i32* %3, align 4
   %7 = load i32, i32* %4, align 4
   %8 = add nsw i32 %6, %7
   %9 = sub nsw i32 %8, 3
   store i32 %9, i32* %5, align 4
   %10 = load i32, i32* %5, align 4
   ret i32 %10
 }
 
 IR基本语法
 注释以分号 ; 开头
 全局标识符以@开头，局部标识符以%开头
 alloca，在当前函数栈帧中分配内存
 i32，32bit，4个字节的意思
 align，内存对齐
 store，写入数据
 load，读取数据
 
 官方语法参考：
 https://llvm.org/docs/LangRef.html
 
 优化IR：clang -O3 -S -emit-llvm llvm.c
 define i32 @test(i32, i32) local_unnamed_addr #0 {
   %3 = add i32 %0, -3
   %4 = add i32 %3, %1
   ret i32 %4
 }
 
 三、iOS项目编译过程
 
 3.1、子工程编译过程
 1）Write auxiliary files
    生成一些辅助文件，主要是 .hmap、LinkFileList 文件，用于辅助执行编译用的，可以提高二次编译速度。
 2）编译 .m 文件
   .m 是主要的源文件，经过预编译操作后，这里的 .m 是展开后的，可以独立编译生成最后的 .o 文件。这里 CompileC 命令和 clang 命令
 3）编译 xxx-dummy.m 文件
    xxx-dummy.m 文件是 CocoaPods 使用的用于区分不同 pod 的编译文件，每个第三方库有不同的 target，
    所以每次编译第三方库时，都会新增几个文件：包含编译选项的.xcconfig文件，
    同时拥有编译设置和 CocoaPods 配置的私有 .xcconfig 文件，编译所必须的prefix.pch文件以及编译必须的文件 dummy.m
 4）写入LinkFileList，列出了编译后的每一个.o目标文件的信息
 5）创建当前架构的静态库.a文件
 
 3.2、主工程编译过程
 1）创建.app包
 2）创建Entitlements.plist，为你的App授予特定的能力以及一些安全方面的权限
 3）Process Product Packaging
 4）Write Auxiliary File，主要是script.sh(Check Pods Manifest.lock)、header.hmap、LinkFileList、all-product-headers.yaml 文件
 5）Run custom shell script '[CP] Check Pods Manifest.lock'
 6）Precompile xxx.pch （9s）
 7）编译文件：针对每一个文件进行编译，生成可执行文件 Mach-O，这过程 LLVM 的完整流程，前端、优化器、后端（具体分析）
 8）链接文件：链接器做的事就是把这些目标文件和所用的一些库链接在一起形成一个完整的可执行文件（33s）
 9）Compile AssetCatalog（36s）
 10）拷贝资源文件：将项目中的资源文件拷贝到目标包（耗时很大）
 11）Process Info.plist
 12）Run custom shell script '[CP] Copy Pods Resources' （5s）
 13）Generate app.dSYM
 14）Run custom shell script '[CP] Embed Pods Frameworks'（32s）
 15）Run custom shell script 'Run Script' （4s）
 16）Sign xxx.app

 
 四、编译速度优化
 
 1、修改工程配置
 1.1 编译时长优化Architectures：多余
 a、Architectures 是指定工程支持的指令集的集合，如果设置多个architecture，则生成的二进制包会包含多个指令集代码，提及会随之变大。
 b、Valid Architectures 有效的指令集集合，Architectures与Valid Architectures的交集来确定最终的数据包含的指令集代码。
 c、Build Active Architecture Only 指定是否只对当前连接设备所支持的指令集编译，默认Debug的时候设置为YES，Release的时候设为NO。
    Debug设置为YES时只编译当前的architecture版本，生成的包只包含当前连接设备的指令集代码；
    设置为NO时，则生成的包包含所有的指令集代码（上述的V艾力达Architecture与Architecture的交集）
 
 1.2、编译时长优化 Precompile Prefix Header 预编译头文件
    将Precompile Prefix Header设为YES时，pch文件会被预编译，预编译后的pch会被缓存起来，从而提高编译速度。
    需要编译的pch文件在Prefix Header中注册即可。
 
 1.3、编译时长优化 Compile - Code Generation Optimization Level，无用
    注意：在设置编译优化之后，XCode断点和调试信息会不正常，所以一般静态库或者其他Target这样设置
 
 1.4、将Debug Information Format改为DWARF
    这一项设置的是是否将调试信息加入到可执行文件中，改为DWARF后，如果程序崩溃，将无法输出崩溃位置对应的函数堆栈，
    但由于Debug模式下可以在XCode中查看调试信息，所以改为DWARF影响并不大。这一项更改完之后，可以大幅提升编译速度。
 
 1.5、采用新构建系统（New Build System）
      参考：https://blog.csdn.net/tugele/article/details/84885211
 
 1.6、增加XCode执行的线程数
 
 
 2、项目优化（开发者密切相关）
 
 2.1、减少编译文件和资源：无用的类，库，图片去掉
 
 2.2、静态库
      基础组件和三方库打成二进制，就编译时间就会减少。但是这样一来 调试就不方便了，所以这是个取舍问题。
 
 2.3、去掉无效引用和头文件使用@class
     OC的优化，重点在于减少无效引用，对编译时长的优化提升非常明显。 通过 log 看哪些文件编译时间比较长的文件，进行优化。

 2.4、优化pch文件，删除用的不多的引用
 
 2.5、去掉nib文件
 
*/

@end
