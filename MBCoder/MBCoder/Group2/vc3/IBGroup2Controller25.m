//
//  IBGroup2Controller25.m
//  MBCoder
//
//  Created by BowenCoder on 2020/3/9.
//  Copyright © 2020 inke. All rights reserved.
//

#import "IBGroup2Controller25.h"

@interface G2Person25 : NSObject

@property (nonatomic, strong) id delegate;

@end

@implementation G2Person25

- (void)dealloc
{
    NSLog(@"%s", __func__);
}

@end

@interface IBGroup2Controller25 ()

@property (nonatomic, strong) NSTimer *weakTimer;

@end

@implementation IBGroup2Controller25

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    G2Person25 *p = [G2Person25 new];
    p.delegate = p;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self case1];
}

/**
 检测结果：
 FBRetainCycleDetector 没有检测出结果
 pop 时 ViewController 没有 dealloc， MLeaksFinder 报 leak
 */
- (void)case1 {
    
    self.weakTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
        NSLog(@"case8 timer block%@", self);
    }];
}

/**
 MLeaksFinder
 优点
 轻量级框架，不侵入工程和业务代码
 在App跑业务逻辑时自动检测、弹窗提示，无需跑额外的检测流程
 能降低发现内存泄漏的时间成本
 能准确地告诉哪个对象没被释放
 缺点
 默认只能自动检测 UIViewController 和 UIView 对象的内存泄漏（可通过配置检测其他对象）
 
 
 FBRetainCycleDetector
 FBRetainCycleDetector 用以检测循环引用，可以检测NSObject的循环引用、关联对象（Associated Object）的循环引用、block的循环引用(亮点就是block的监测)。

 FBRetainCycleDetector 接受一个运行时的实例，然后从这个实例开始遍历它所有的属性，逐级递归。 如果发现遍历到重复的实例，就说明存在循环引用，并给出报告。

 然而，FBRetainCycleDetector 的使用存在两个问题：

 1. 需要找到候选的检测对象
 2. 检测循环引用比较耗时

 注意
 有的循环引用 FBRetainCycleDetector 不一定能找出
 能检测出多个循环引用的情况
 关注和处理最小环
 
 */

@end
