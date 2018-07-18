//
//  IBController2.m
//  IBCoder1
//
//  Created by Bowen on 2018/4/24.
//  Copyright © 2018年 BowenCoder. All rights reserved.
//

#import "IBController2.h"

@implementation Person

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

@property (nonatomic, strong) Person *person;

@end

@implementation IBController2

- (Person *)person {
    if (!_person) {
        _person = [[Person alloc] init];
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
    @autoreleasepool {
        NSMutableArray *arr = @[].mutableCopy;
        for (int i = 0; i<10e6; i++) {
            NSString *str = [NSString stringWithFormat:@"%d", i];
            [arr addObject:str];
        }
        NSLog(@"123");
    }
    NSLog(@"123");
}




@end
