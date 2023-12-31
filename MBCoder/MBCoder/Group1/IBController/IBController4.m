//
//  IBController4.m
//  IBCoder1
//
//  Created by Bowen on 2018/4/26.
//  Copyright © 2018年 BowenCoder. All rights reserved.
//

#import "IBController4.h"
#import <objc/runtime.h>

#ifndef weakify
#if __has_feature(objc_arc)
#define weakify(object) __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) __block __typeof__(object) block##_##object = object;
#endif
#endif

#ifndef strongify
#if __has_feature(objc_arc)
#define strongify(object) __typeof__(object) object = weak##_##object; if (!object) return;
#else
#define strongify(object) __typeof__(object) object = block##_##object; if (!object) return;
#endif
#endif


@implementation Student

+ (instancetype)shareInstance {
    static Student *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[Student alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _arr = @[].mutableCopy;
    }
    return self;
}

- (void)addBlock:(void (^)(void))block {
    [self.arr addObject:block];
    block();
}

- (void)dealloc
{
    NSLog(@"%s",__func__);
}

- (NSString *)description
{
    return @"123456";
}


+ (void)performBlock:(dispatch_block_t)block
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        block();
    });
}

@end


typedef void (^Block)(void);

@interface IBController4 ()

@property (nonatomic, assign) Block block;
@property (nonatomic, strong) Student *student;
@property (nonatomic, copy) dispatch_block_t block1;
@property (nonatomic, copy) dispatch_block_t block2;
@property (nonatomic, copy) dispatch_block_t block3;

@end

@implementation IBController4

static int count = 0;

// https://www.jianshu.com/p/d96d27819679(源码解析)

//如果需要在block内部改变外部栈区变量的话，需要在用__block修饰外部变量。
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.student = [Student shareInstance];
    weakify(self)
    self.block1 = ^{
        strongify(self)
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSLog(@"执行中 strongify %@", self);
        });
    };
    self.block2 = ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSLog(@"执行中 weakify %@", weak_self);
        });
    };
    
    self.block3 = ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            strongify(self)
            NSLog(@"当前对象调用 没执行 strongify %@", self);
        });
    };
    [Student shareInstance].pblock = ^{
        strongify(self)
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSLog(@"其他对象调用 没执行 strongify %@", self);
        });
    };
    
    [Student performBlock:^{
        NSLog(@"bowen %d", count);
        count++;
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [self test1];
//    [self test2];
//    [self test3];
//    [self testBlock];
//    [self testWeak];
//    [self test4];
//    [self test5];
    [self test6];
}

- (void)test6
{
    __block char key = 0;  ///&(结构体->forwarding->key)在栈区
    
    objc_setAssociatedObject(self, &key, @1, OBJC_ASSOCIATION_ASSIGN);
    
    void (^block)(void) = ^{
        objc_setAssociatedObject(self, &key, @2, OBJC_ASSOCIATION_ASSIGN);
    };  /// 在堆区
    
    id m = objc_getAssociatedObject(self, &key);  ///&(结构体->forwarding->key)
    block();
    id n = objc_getAssociatedObject(self, &key);
    NSLog(@"m= %@ n=%@", m,n);
}



/// obj = nil，执行之前：都有值。
///        执行之后：strongobj=nil（block体内弱引用），&strongobj有值（strongobj作为指针，地址是存在的，只不过指向的内存空间不存在了）。
- (void)test5
{
    NSObject *obj = [[NSObject alloc] init];
    NSLog(@"%@--%p", obj, &obj);
    __weak typeof(obj)weakobj = obj;
    void(^block)(void) = ^{
        __strong typeof(weakobj) strongobj = weakobj;
        NSLog(@"%@--%p",strongobj, &strongobj);
    };
    block();
    obj = nil;
    block();
}


/// 都有值，block内部会持有这个对象
- (void)test4
{
    NSObject *obj = [[NSObject alloc] init];
    NSLog(@"%@--%p", obj, &obj);
    void(^block)(void) = ^{
        NSLog(@"%@--%p",obj, &obj);
    };
    block();
    obj = nil;
    block();
}

- (void)testWeak
{
    /*
     strong 只保证，在block 里面 走的时候，不会 走一半 突然空了，
     如果 block 没走之前 weakSelf 为空，block里面的strong(self)，也为空。
     存在的情况，block在未来某一时间调用，但是对象可能释放
     */
    self.block1(); // block走完
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.block3();
    });
    
    self.block2(); // block走一半空了
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [Student shareInstance].pblock();
    });
}

/*
 
 dispatch_async(myQueue, ^{
    // line A
 });
// line B
 
 
 there’s clearly a race condition between lines A and B, that is, between the `dispatch_async` returning and the block running on the queue.  This can pan out in multiple ways, including:
 
 * If `myQueue` (which we’re assuming is a serial queue) is busy, A has to wait so B will definitely run before A.
 
 * If `myQueue` is empty, there’s no idle CPU, and `myQueue` has a higher priority then the thread that called `dispatch_async`, you could imagine the kernel switching the CPU to `myQueue` so that it can run A.The thread that called `dispatch_async` could run out of its time quantum after scheduling B on `myQueue` but before returning from `dispatch_async`, which again results in A running before B.
 
 * If `myQueue` is empty and there’s an idle CPU, A and B could end up running simultaneously.
 */
- (void)test3 {
    
    //方法1
    dispatch_queue_t queue = dispatch_queue_create("abc123", DISPATCH_QUEUE_SERIAL);
    dispatch_queue_t global = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);
    dispatch_set_target_queue(queue, global);
    
    //方法2
    dispatch_queue_attr_t attr = dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_SERIAL, QOS_CLASS_UTILITY, DISPATCH_QUEUE_PRIORITY_HIGH);
    dispatch_queue_t queueAttr = dispatch_queue_create("com.starming.gcddemo.qosqueue", attr);
    
    dispatch_async(queue, ^{
        NSLog(@"A");
    });
    dispatch_async(queueAttr, ^{
        NSLog(@"B");
    });
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"C");
    });
    sleep(3);
    NSLog(@"D");
}

/**
 如果参数block被Person对象引用就会产生循环引用，否则不会
 解决办法：事前避免，事后弥补，传值(置空一端引用，断开循环)
 */
- (void)test2 {
    //循环引用
//    [self.student addBlock:^{
//        NSLog(@"%s--%@",__func__,self);
//    }];
    
    //事前避免
    __weak typeof(self) weakself = self;
    [[Student shareInstance] addBlock:^{
        //block截获weakself变量，strongself实质是block局部变量，接收weakself变量的值。
        //当block执行完毕就会释放自动变量strongSelf，不会对self进行一直进行强引用。
        __strong typeof(weakself) strongself = weakself;
        NSLog(@"%s--%@",__func__,strongself);
    }];
    
//    [self.student addBlock:^{
//        NSLog(@"%s--%@",__func__,self);
//        self.student.arr = nil;
//    }];
    
}



/**
 需要切换MRC(-fno-objc-arc)测试
 */
- (void)test1 {
    
    /*
     __NSGlobalBlock__ 全局区(静态区)的
     没访问外部变量
     ARC和MRC一样
     
     */
    void (^block1)(void) = ^{
        NSLog(@"block1");
    };
    NSLog(@"%@",block1);
    
    /*
     访问外界变量
    __NSStackBlock__ 栈区 (内部使用了外部变量)(MRC模式下)
    栈区的特点就是创建的对象随时可能被销毁,一旦被销毁后续再次调用空对象就可能会造成程序崩溃
    __NSMallocBlock__ 堆区(有强指针引用，系统也会默认对Block进行copy操作)(ARC模式下)
    __NSStackBlock__ 栈区（无强指针引用）(ARC模式下)
     */
    int i = 10;
    void (^block2)(void) = ^{
        NSLog(@"block2 -- %d", i);
    };
    NSLog(@"%@",block2);
    
    //__NSMallocBlock__ 堆区 ([block2 copy]后Block存放在堆区) MRC
    NSLog(@"%@", [block2 copy]);
    
    
    [self testBlock];
    sleep(1);
    
    /*
     MRC
     1.block用assign、retain修饰时，当再次访问时就会出现野指针访问.
     2.block用strong、copy修饰时，会拷贝到堆内存
     ARC
     1.assign修饰是栈区__NSStackBlock__ 会出现野指针访问
     2.retain，不修饰，strong，copy都是堆区（__NSMallocBlock__）
     */
    NSLog(@"%@",self.block);
    
}


/**
 Block不允许修改外部变量的值，这里所说的外部变量的值，指的是栈中指针的内存地址
 嵌套block使用self，__weak, __strong.自己测试没影响
 
 解析：strongSelf只存在于Block体内里，它的生命周期只在这个block执行的过程中，block执行前它不会存在，block执行完它立刻就被释放了。
 ①、如果block执行前self变为nil了，那么block不会执行，没有任何引用循环发生；
 ②、如果block执行过程中self变为nil了，那么block一开始声明的strongSelf会暂时持有着self，此时会有一个暂时的引用循环。当block执行完（即是Block执行完），strongSelf超出作用域被释放，引用循环从这里开始打破。接下来，由于没有任何强引用持有self了，于是self被释放，最后Block也因为没有任何强引用持有它也被释放了。所有对象就都被顺利释放了。
 */
- (void)testBlock {
    int i = 5;
    int *a = &i;
    __block NSString *name = @"bowen";
    NSMutableString *nickname = @"ios".mutableCopy;
    static NSString *weakname = @"OC";
    __weak typeof(self) weakSelf = self;
    self.block = ^{
        __strong typeof(self) strongSelf = weakSelf;
        int b = 10;
        *a = b;
//        a = &b; //不允许
//        nickname = @"OC"; //不允许
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            name = @"b";
            weakname = @"Objective - C";
            [nickname appendString:@"swift"]; //允许
            NSLog(@"test -- %@%d", name,i);
            NSLog(@"弱引用%@---强引用%@", weakSelf, strongSelf);
        });
    };
    [self.student addBlock:self.block];
    NSLog(@"test -- %@ -- %li",self.block,CFGetRetainCount((__bridge CFTypeRef)(self.block)));
}

- (void)run {
    NSLog(@"%s", __func__);
}


- (void)dealloc {
    NSLog(@"%s",__func__);
}


/**
1、block是什么？
 堆上Bolck：__NSMallocBlock__ -> __NSMallocBlock -> NSBlock -> NSObject
 栈上Bolck：__NSStackBlock__ -> __NSStackBlock -> NSBlock -> NSObject
 全局Bolck：__NSGlobalBlock__ -> __NSGlobalBlock -> NSBlock -> NSObject
 验证：object_getSuperclass()
 结论是对象。
 Block就是一个里面存储了指向定义的block时的代码块的函数指针，以及block外部上下文变量信息的结构体。
 函数的作用是回调，结构体的作用是存储变量信息。
 
 2、内存分布
 无外部变量：block在全局区
 有外部变量：全局变量、全局静态变量、局部静态变量、block依然在全局区
           普通外部变量，copy、strong修饰的block在堆区，weak修饰的block在栈区
 
 思考：为什么对于不同类型的变量，block的处理方式不同呢？
 这是由变量的生命周期决定的。
 对于自动变量，当作用域结束时，会被系统自动回收，而block很可能是在超出自动变量作用域的时候去执行，如果之前没有捕获自动变量，那么后面执行的时候，自动变量已经被回收了，得不到正确的值。
 对于static局部变量，它的生命周期不会因为作用域结束而结束，所以block只需要捕获这个变量的地址，在执行的时候通过这个地址去获取变量的值，这样可以获得变量的最新的值。
 而对于全局变量，在任何位置都可以直接读取变量的值
 
 3、block结构见下文
 
 Block变量的声明格式为: 返回值类型(^Block名字)(参数列表);
 Block变量的赋值格式为: Block变量 = ^返回值类型(参数列表){函数体}
 
 全局变量，全局变量由于作用域的原因，于是可以直接在Block里面被改变。他们也都存储在全局区。
 静态变量传递给Block是内存地址值，所以能在Block里面直接改变值
 
 block进行拷贝的4种情况
 1.手动调用copy
 2.Block是函数的返回值
 3.Block被强引用，Block被赋值给__strong或者id类型
 4.调用系统API入参中含有usingBlcok的方法
 
 针对指向的对象来说，
 在MRC环境下，__block根本不会对指针所指向的对象执行copy操作，而只是把指针进行的复制。
 而在ARC环境下，对于声明为__block的外部对象，在block内部会进行retain，以至于在block环境内能安全的引用外部对象。
 
 针对__block来说
 ARC环境下，一旦Block赋值就会触发copy，__block就会copy到堆上，Block也是__NSMallocBlock。ARC环境下也是存在__NSStackBlock的时候，
 这种情况下，__block就在栈上。
 MRC环境下，只有copy，__block才会被复制到堆上，否则，__block一直都在栈上，block也只是__NSStackBlock，
 这个时候__forwarding指针就只指向自己了。
  
 __block结构体中的变量就是它修饰的变量，这两者没有指针指向关系。指针是__forwarding，作用是针对堆的block
 
 __block对象释放：
 1、从 BlockDescriptor 取出 dispose_helper 以及 size（block 持有的所有对象的大小）
 2、通过 (blockLiteral->descriptor->size + ptrSize - 1) / ptrSize 向上取整，获取 block 持有的指针的数量
 3、初始化两个包含 elements 个 FBBlockStrongRelationDetector 实例的数组，其中第一个数组用于传入 dispose_helper，第二个数组用于检测 _strong 是否被标记为 YES
 4、在自动释放池中执行 dispose_helper(obj)，释放 block 持有的对象
 5、因为 dispose_helper 只会调用 release 方法，但是这并不会导致我们的 FBBlockStrongRelationDetector 实例被释放掉，反而会标记 _string 属性，在这里我们只需要判断这个属性的真假，将对应索引加入数组，最后再调用 trueRelease 真正的释放对象。
 
 我的疑问：
 怎么获取栈上的__block,修改栈上的__block修饰的对象会改变值吗？
 
 */


/*
1、block数据结构体
struct Block_descriptor {
    unsigned long int reserved;
    unsigned long int size;
    void (*copy)(void *dst, void *src);
    void (*dispose)(void *);
};
struct Block_layout {
    void *isa;
    int flags;
    int reserved;
    void (*invoke)(void *, ...);
    struct Block_descriptor *descriptor;
    // Imported variables.
};
从上得知，一个block实例实际上由6部分构成：
1）isa 指针，所有对象都有该指针，用于实现对象相关的功能。
2）flags，用于按bit位表示一些block的附加信息，本文后面介绍block copy的实现代码可以看到对该变量的使用。
3）reserved，保留变量。
4）invoke，函数指针，指向具体的block实现的函数调用地址。
5）descriptor， 表示该block的附加描述信息，主要是size大小，以及copy和dispose函数的指针。
6）copy函数把Block从栈上拷贝到堆上，dispose函数是把堆上的函数在废弃的时候销毁掉。
7）variables，capture过来的变量，block能够访问它外部的局部变量，就是因为将这些变量（或变量的地址）复制到了结构体中。

__block结构体（存在堆上）
struct __Block_byref_i_0 {
    void *__isa;
    __Block_byref_i_0 *__forwarding;
    int __flags;
    int __size;
    int i;
};
第一个是isa指针
第二个是指向自身类型的__forwarding指针
第三个是一个标记flag
第四个是它的大小
第五个是变量值，名字和变量名同名。

2、NSConcreteGlobalBlock类型的block的实现
int main()
{
    ^{ printf("Hello, World!\n"); } ();
    return 0;
}

int main()
{
    (void (*)())&__main_block_impl_0((void *)__main_block_func_0, &__main_block_desc_0_DATA) ();
    return 0;
}

struct __block_impl {
    void *isa;
    int Flags;
    int Reserved;
    void *FuncPtr;
};
struct __main_block_impl_0 {
    struct __block_impl impl;
    struct __main_block_desc_0* Desc;
    __main_block_impl_0(void *fp, struct __main_block_desc_0 *desc, int flags=0) {
        impl.isa = &_NSConcreteStackBlock;
        impl.Flags = flags;
        impl.FuncPtr = fp;
        Desc = desc;
    }
};
static void __main_block_func_0(struct __main_block_impl_0 *__cself) {
    printf("Hello, World!\n");
}
static struct __main_block_desc_0 {
    size_t reserved;
    size_t Block_size;
} __main_block_desc_0_DATA = { 0, sizeof(struct __main_block_impl_0) };
解析：
1）__main_block_impl_0 就是该block的实现
2）一个block实际是一个对象，它主要由一个isa和一个impl和一个descriptor组成。
3）MRC中，isa指向的是_NSConcreteStackBlock；ARC中isa指向的是_NSConcreteGlobalBlock
4）impl是实际的函数指针，本例中，它指向__main_block_func_0。这里的impl相当于之前提到的invoke变量，只是clang编译器对变量的命名不一样而已
5）descriptor 是用于描述当前这个block的附加信息的，包括结构体的大小，需要capture和dispose的变量列表等。结构体大小需要保存是因为，
   每个block因为会capture一些变量，这些变量会加到__main_block_impl_0这个结构体中，使其体积变大。


3、NSConcreteStackBlock类型的block的实现
int main() {
    int a = 100;
    void (^block2)(void) = ^{
        printf("%d\n", a);
    };
    block2();
    return 0;
}
int main()
{
    int a = 100;
    void (*block2)(void) = (void (*)())&__main_block_impl_0((void *)__main_block_func_0, &__main_block_desc_0_DATA, a);
    ((void (*)(__block_impl *))((__block_impl *)block2)->FuncPtr)((__block_impl *)block2);
    return 0;
}

struct __main_block_impl_0 {
    struct __block_impl impl;
    struct __main_block_desc_0* Desc;
    int a;
    __main_block_impl_0(void *fp, struct __main_block_desc_0 *desc, int _a, int flags=0) : a(_a) {
        impl.isa = &_NSConcreteStackBlock;
        impl.Flags = flags;
        impl.FuncPtr = fp;
        Desc = desc;
    }
};
static void __main_block_func_0(struct __main_block_impl_0 *__cself) {
    int a = __cself->a; // bound by copy
    printf("%d\n", a);
}
static struct __main_block_desc_0 {
    size_t reserved;
    size_t Block_size;
} __main_block_desc_0_DATA = { 0, sizeof(struct __main_block_impl_0)};

解析：
1）isa指向_NSConcreteStackBlock，说明这是一个分配在栈上的实例。
2）main_block_impl_0中增加了一个变量a，在block中引用的变量a，实际是在申明block时，被复制到main_block_impl_0结构体中的那个变量a。
   因为这样，我们就能理解，在block内部修改变量a的内容，不会影响外部的实际变量a。因为自动变量a是用__cself->a来访问的，block仅仅是捕获了值，
   没有捕获内存地址，像基本类型的函数参数
3）main_block_impl_0中由于增加了一个变量a，所以结构体的大小变大了，该结构体大小被写在了main_block_desc_0中。


4、Block中__block实现原理
int main()
{
    __block int i = 1024;
    void (^block1)(void) = ^{
        printf("%d\n", i);
        i = 1023;
    };
    block1();
    return 0;
}
int main()
{
    __attribute__((__blocks__(byref))) __Block_byref_i_0 i = {(void*)0,(__Block_byref_i_0 *)&i, 0, sizeof(__Block_byref_i_0), 1024};
    void (*block1)(void) = (void (*)())&__main_block_impl_0((void *)__main_block_func_0, &__main_block_desc_0_DATA, (__Block_byref_i_0 *)&i, 570425344);
    ((void (*)(__block_impl *))((__block_impl *)block1)->FuncPtr)((__block_impl *)block1);
    return 0;
}

struct __Block_byref_i_0 {
    void *__isa;
    __Block_byref_i_0 *__forwarding;
    int __flags;
    int __size;
    int i;
};
struct __main_block_impl_0 {
    struct __block_impl impl;
    struct __main_block_desc_0* Desc;
    __Block_byref_i_0 *i; // by ref
    __main_block_impl_0(void *fp, struct __main_block_desc_0 *desc, __Block_byref_i_0 *_i, int flags=0) : i(_i->__forwarding) {
        impl.isa = &_NSConcreteStackBlock;
        impl.Flags = flags;
        impl.FuncPtr = fp;
        Desc = desc;
    }
};
static void __main_block_func_0(struct __main_block_impl_0 *__cself) {
    __Block_byref_i_0 *i = __cself->i; // bound by ref
    printf("%d\n", (i->__forwarding->i));
    (i->__forwarding->i) = 1023;
}
static void __main_block_copy_0(struct __main_block_impl_0*dst, struct __main_block_impl_0*src) {_Block_object_assign((void*)&dst->i, (void*)src->i,);}
static void __main_block_dispose_0(struct __main_block_impl_0*src) {_Block_object_dispose((void*)src->i,);}
static struct __main_block_desc_0 {
    size_t reserved;
    size_t Block_size;
    void (*copy)(struct __main_block_impl_0*, struct __main_block_impl_0*);
    void (*dispose)(struct __main_block_impl_0*);
} __main_block_desc_0_DATA = { 0, sizeof(struct _main_block_impl_0), __main_block_copy_0, __main_block_dispose_0};
解析：
1）源码中增加一个名为__Block_byref_i_0的结构体，用来保存我们要capture并且修改的变量i。
2）main_block_impl_0中引用的是Block_byref_i_0的结构体指针，这样就可以达到修改外部变量的作用。
3）__Block_byref_i_0结构体中带有isa，说明它也是一个对象。
4）我们需要负责Block_byref_i_0结构体相关的内存管理，所以main_block_desc_0中增加了copy和dispose函数指针，对于在调用前后修改相应
   变量的引用计数。
5）__forwarding指针这里的作用就是针对堆的Block，把原来__forwarding指针指向自己，换成指向_NSConcreteMallocBlock上复制之后的__block自己。然后堆上的变量的__forwarding再指向自己。这样不管__block怎么复制到堆上，还是在栈上，都可以通过(i->__forwarding->i)来访问到变量值。
 （简而言之，栈上指向堆上，堆上指向自己）,这样不管__block怎么复制到堆上，还是在栈上，都可以通过(i->__forwarding->i)来访问到变量值。
*/

@end
