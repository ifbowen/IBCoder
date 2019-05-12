//
//  IBGroup2ViewController2.m
//  IBCoder1
//
//  Created by BowenCoder on 2019/5/10.
//  Copyright © 2019 BowenCoder. All rights reserved.
//

#import "IBGroup2ViewController2.h"

@interface IBGroup2ViewController2 ()

@end

@implementation IBGroup2ViewController2

/*
 一、地址空间存储区域
 1、代码段(.text)，也称文本段(Text Segment)，
 存放着程序的机器码和只读数据，可执行指令就是从这里取得的。
 如果可能，系统会安排好相同程序的多个运行实体共享这些实例代码。
 这个段在内存中一般被标记为只读，任何对该区的写操作都会导致段错误（Segmentation Fault）。
 在代码段中，也有可能包含一些只读的常数变量，例如字符串常量等。
 
 2、数据段，包括已初始化的数据段(.data)和未初始化的数据段（.bss），
 前者用来存放保存全局的和静态的已初始化变量，
 后者用来保存全局的和静态的未初始化变量。数据段在编译时分配。
 
 3、堆栈段分为堆和栈：
 堆（Heap）：用来存储程序运行时分配的变量。
 堆的大小并不固定，可动态扩张或缩减。其分配由malloc()、new()等这类实时内存分配函数来实现。
 当进程调用malloc等函数分配内存时，新分配的内存就被动态添加到堆上（堆被扩张）；
 当利用free()等函数释放内存时，被释放的内存从堆中被剔除（堆被缩减），
 堆的内存释放由应用程序去控制通常一个new()就要对应一个delete()，
 
 4、栈（Stack）是一种用来存储函数调用时的临时信息的结构，如函数调用所传递的参数、函数的返回地址、函数的局部变量等。
 在程序运行时由编译器在需要的时候分配，在不需要的时候自动清除。
 栈的特性: 最后一个放入栈中的物体总是被最先拿出来，这个特性通常称为先进后出(FILO)队列。
 栈的基本操作：
 PUSH操作：向栈中添加数据，称为压栈，数据将放置在栈顶；
 POP操作：POP操作相反，在栈顶部移去一个元素，并将栈的大小减一，称为弹栈
 
 
 二、堆和栈的区别：
 1.分配和管理方式不同 ：
 堆是动态分配的，其空间的分配和释放都由程序员控制。
 栈由编译器自动管理。栈有两种分配方式：静态分配和动态分配。
 静态分配由编译器完成，比如局部变量的分配。
 动态分配由alloca()函数进行分配，但是栈的动态分配和堆是不同的，它的动态分配是由编译器进行释放，无须手工控制。
 
 2.产生碎片不同
 对堆来说，频繁的new/delete或者malloc/free势必会造成内存空间的不连续，造成大量的碎片，使程序效率降低。
 对栈而言，则不存在碎片问题，因为栈是先进后出的队列，永远不可能有一个内存块从栈中间弹出。
 
 3.生长方向不同
 堆是向着内存地址增加的方向增长的，从内存的低地址向高地址方向增长。
 栈的生长方向与之相反，是向着内存地址减小的方向增长，由内存的高地址向低地址方向增长。
 
 三、结构体内存
 结构体内存对齐规则
 1、结构体变量的首地址能够被其最宽基本类型成员的大小所整除。
 原因：结构体在考虑最宽成员时会将包含于此的结构体成员"打散"，被“打散”后里面也全部是基本类型。

 2、结构体每个成员相对于结构体首地址的偏移量(offset)都是成员大小的整数倍
    如有需要编译器会在成员之间加上填充字节(internal adding)。
 
 3、结构体的总大小为结构体最宽基本类型成员大小的整数倍，
    如有需要编译器会在成员末尾加上填充字节
 
 四、内存字节对齐
    选择对齐模式会以牺牲空间的代价提升时间效率.
    64位8字节对齐：http://stackoverflow.com/questions/21219130/is-8-byte-alignment-for-double-type-necessary
    The interface to memory might be eight bytes wide and only able to access memory at multiples of eight bytes.
    Loading an unaligned eight-byte double then requires two reads on the bus. Stores are worse, because an
    aligned eight-byte store can simply write eight bytes to memory, but an unaligned eight-byte store must
    read two eight-byte pieces, merge the new data with the old data, and write two eight-byte pieces.
 
    32位4字节对齐：
    因为地址总线的关系，有2根总线不参与寻址，导致只能获取到4的整数倍的地址，所以默认是4字节对齐
 
 五、总线
    数据总线
    （1）是CPU与内存或其他器件之间的数据传送的通道。
    （2）数据总线的宽度决定了CPU和外界的数据传送速度。
    （3）每条传输线一次只能传输1位二进制数据。eg: 8根数据线一次可传送一个8位二进制数据(即一个字节)。
    （4）数据总线是数据线数量之和。
 
    地址总线
    （1）CPU是通过地址总线来指定存储单元的。
    （2）地址总线决定了cpu所能访问的最大内存空间的大小。eg: 10根地址线能访问的最大的内存为1024位二进制数据(1B)
    （3）地址总线是地址线数量之和。
 
    控制总线
    （1）CPU通过控制总线对外部器件进行控制。
    （2）控制总线的宽度决定了CPU对外部器件的控制能力。
    （3）控制总线是控制线数量之和。
 */

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    struct A {
        char c;
        int i;
    };
    /*
     假设变量a存放在内存中的起始地址为0x00，那么其成员变量c的起始地址为0x00，成员变量i的起始地址为0x01，变量a一共占用了5个字节。当CPU要对成员变量c进行访问时，只需要一个读周期即可。而如若要对成员变量i进行访问，那么情况就变得有点复杂了，首先CPU用了一个读周期，从0x00处读取了4个字节(注意由于是32位架构)，然后将0x01-0x03的3个字节暂存，接着又花费了一个读周期读取了从0x04-0x07的4字节数据，将0x04这个字节与刚刚暂存的3个字节进行拼接从而读取到成员变量i的值。为了读取这个成员变量i，CPU花费了整整2个读周期。试想一下，如果数据成员i的起始地址被放在了0x04处，那么读取其所花费的周期就变成了1，显然引入字节对齐可以避免读取效率的下降，但这同时也浪费了3个字节的空间(0x01-0x03)。
     
     */
}



@end
