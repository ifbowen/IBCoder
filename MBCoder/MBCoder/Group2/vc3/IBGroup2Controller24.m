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
 
 4.2 查看preprocessor(预处理)的结果:$ clang -E llvm.c
 a、将 import 引入的文件代码放入对应文件
 b、自定义宏替换
 
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
 
 1、编译信息写入辅助文件，创建编译后的文件架构
 2、运行预设脚本：这些脚本都在 Build Phases 中可以看到
 3、编译文件：针对每一个文件进行编译，生成可执行文件 Mach-O，这过程 LLVM 的完整流程，前端、优化器、后端；
 4、链接文件：将项目中的多个可执行文件合并成一个文件；
 5、拷贝资源文件：将项目中的资源文件拷贝到目标包；
 6、编译、链接nib文件：将编译后的nib文件链接成一个文件；
 7、编译 Asset 文件：将Assets.xcassets的图片编译成机器码，除了 icon 和 launchImage；
 8、运行 Cocoapods 脚本：将在编译项目之前已经编译好的依赖库和相关资源拷贝到包中。
 9、生成 .app 包
 10、将 Swift 标准库拷贝到包中
 11、对包进行签名
 12、完成打包
 
 总结，2 - 8 步骤的数量和顺序并不固定，这个过程可以在 Build Phases 中指定。Phases：阶段、步骤。
 参考：https://objccn.io/issue-6-1/
 
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
