//
//  IBController2.m
//  IBCoder1
//
//  Created by Bowen on 2018/4/24.
//  Copyright © 2018年 BowenCoder. All rights reserved.
//

#import "IBController2.h"

@implementation Personal

- (void)setName:(NSString *)name {
    _name = name;
    if ([self.delegate respondsToSelector:@selector(personNameChange)]) {
        [self.delegate personNameChange];
    }
}

- (void)dealloc {
    NSLog(@"person dealloc");
}

@end



@interface IBController2 ()<PersonDelegate>

@property (nonatomic, strong) Personal *person;
@property (nonatomic, copy) NSString *name;

@end

@implementation IBController2

- (Personal *)person {
    if (!_person) {
        _person = [[Personal alloc] init];
    }
    return _person;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [self test1];
    
//    [self test2];
//    NSLog(@"%@",self.person.delegate);
    [self test3];
    
}

/**
 Tagged Pointer
 1、从64bit开始，iOS引入了Tagged Pointer技术，用于优化NSNumber、NSDate、NSString等小对象的存储
 2、在没有使用Tagged Pointer之前， NSNumber等对象需要动态分配内存、维护引用计数等，NSNumber指针存储的是堆中NSNumber对象的地址值
 3、使用Tagged Pointer之后，NSNumber指针里面存储的数据变成了：Tag + Data，也就是将数据直接存储在了指针中
 4、当指针不够存储数据时，才会使用动态分配内存的方式来存储数据
 5、objc_msgSend能识别Tagged Pointer，比如NSNumber的intValue方法，直接从指针提取数据，节省了以前的调用开销

 6、如何判断一个指针是否为Tagged Pointer？
 1）iOS平台，最高有效位是1（第64bit），#define  _OBJC_TAG_MASK (1UL<<63)
 2）Mac平台，最低有效位是1，                 #define  _OBJC_TAG_MASK (1UL)
 方法：
 BOOL isTaggedPointer(id pointer)
 {
    return (long)(__bridge void *)pointer & _OBJC_TAG_MASK == _OBJC_TAG_MASK;
 }

- (void)setName:(NSString *)name
{
    if (_name != name) {
        [_name release];
        _name = [name retain];
    }
}
 */

- (void)test4
{
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    
    /**
     会崩溃
     1、是对象
     2、异步执行，但不是原子操作
     */
//    for (int i = 0; i < 1000; i++) {
//        dispatch_async(queue, ^{
//            // 加锁
//            self.name = [NSString stringWithFormat:@"abcdefghijk"];
//            // 解锁
//        });
//    }
    
    /**
     不会崩溃
     1、Tagged Pointer，不是对象，指针赋值
     */
    for (int i = 0; i < 1000; i++) {
        dispatch_async(queue, ^{
            self.name = [NSString stringWithFormat:@"abc"];
        });
    }
}

- (void)test3 {
    __weak id obj;
    __strong id objc;
    @autoreleasepool {
        obj = [[NSObject alloc] init];
        objc = [[NSObject alloc] init];
    }
    NSLog(@"%@--%@", obj, objc);
}

/**
 1.assign指针赋值，不对引用计数操作，使用之后如果没有置为nil，可能就会产生野指针
       （delegate指向对象销毁了，仍然存放之前对象地址）（ARC之前用assign）
 2.unsafe_unretained：不会对对象进行retain，当对象销毁时，会依然指向之前的内存空间（野指针）
 3.weak不会对对象进行retain，当对象销毁时，会自动指向nil
 
 */
- (void)test2 {
    IBController2 *ib = [[IBController2 alloc] init];
    self.person.delegate = ib;
    self.person.name = @"bowen";
    NSLog(@"%@",self.person.delegate);
}
- (void)personNameChange {
    NSLog(@"personNameChange");

}

/**
 1.@autoreleasepool是自动释放池，让我们更自由的管理内存
 2.当我们手动创建了一个@autoreleasepool，里面创建了很多临时变量，当@autoreleasepool结束时，里面的内存就会回收
 3.最重要的使用场景，应该是有大量中间临时变量产生时，避免内存使用峰值过高，及时释放内存的场景。
 4.临时生成大量对象,一定要将自动释放池放在for循环里面，要释放在外面，就会因为大量对象得不到及时释放，而造成内存紧张，最后程序意外退出
 5.ARC时代，系统自动管理自己的autoreleasepool，runloop就是iOS中的消息循环机制，当一个runloop结束时系统才会一次性清理掉被
   autorelease处理过的对象
 */
- (void)test1 {
    NSMutableArray *arr = @[].mutableCopy;
    for (int i = 0; i<10e6; i++) {
        @autoreleasepool {
            NSString *str = [NSString stringWithFormat:@"%d", i];
            [arr addObject:str];
        }
    }
    NSLog(@"123");
    NSLog(@"123");
}




@end
