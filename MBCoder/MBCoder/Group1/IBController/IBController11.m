//
//  IBController11.m
//  IBCoder1
//
//  Created by Bowen on 2018/5/8.
//  Copyright © 2018年 BowenCoder. All rights reserved.
//

#import "IBController11.h"
#import "UIView+Ext.h"

/*
 一、响应者链（Responder Chain）是 iOS 中用于处理事件响应和事件传递的一种机制。由一系列的响应者对象组成的链表结构，这些对象都是继承自 UIResponder 类，用于确定事件的传递路径和响应者的顺序
 子View -> UIView -> UIViewController -> UIWindow -> UIApplication -> AppDelegate
 
 二、事件分发（Event Delivery）
 第一响应者（First responder）指的是当前接受触摸的响应者对象（通常是一个UIView对象），即表示当前该对象正在与用户交互，它是响应者链的开端。整个响应者链和事件分发的使命都是找出第一响应者。
 
 iOS系统检测到手指触摸(Touch)操作时会将其打包成一个UIEvent对象，并放入当前活动Application的事件队列，单例的UIApplication会从事件队列中取出触摸事件并传递给单例的UIWindow来处理，UIWindow对象首先会使用hitTest:withEvent:方法寻找此次Touch操作初始点所在的视图(View)，即需要将触摸事件传递给其处理的视图，这个过程称之为hit-test view。
 
 hitTest:withEvent:方法的处理流程如下
 
 1.首先调用当前视图的pointInside:withEvent:方法判断触摸点是否在当前视图内；
 
 若返回NO,则hitTest:withEvent:返回nil;
 
 若返回YES,则向当前视图的所有子视图(subviews)发送hitTest:withEvent:消息，所有子视图的遍历顺序是从最顶层视图一直到到最底层视图，即从subviews数组的末尾向前遍历，直到有子视图返回非空对象或者全部子视图遍历完毕；
 
 若第一次有子视图返回非空对象，则hitTest:withEvent:方法返回此对象，处理结束；
 
 如所有子视图都返回非，则hitTest:withEvent:方法返回自身(self)。
 
 三、说明
 1、如果最终hit-test没有找到第一响应者，或者第一响应者没有处理该事件，则该事件会沿着响应者链向上回溯，如果UIWindow实例和UIApplication实例都不能处理该事件，则该事件会被丢弃；

 
 注意:为什么用队列管理事件,而不用栈？
 队列先进先出,能保证先产生的事件先处理。栈先进后出。
 
 四、应用
 1、扩大UIButton的响应热区
 重载UIButton的-(BOOL)pointInside: withEvent:方法，让Point即使落在Button的Frame外围也返回YES
 2、子view超出了父view的bounds响应事件
 
 3、ScrollView page滑动
 如果想让边侧留出的距离响应滑动事件的话应该怎么办呢？在scrollview的父view中把蓝色部分的事件都传递给scrollView就可以了
 */
@interface IBViewA : UIView

@end

@implementation IBViewA

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor redColor];
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"%s",__func__);
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    NSLog(@"%s",__func__);

    // 1.判断下自己能否接收事件
    if (self.userInteractionEnabled == NO || self.hidden == YES || self.alpha <= 0.01) return nil;
    
    // 2.判断下点在不在当前控件上
    if ([self pointInside:point withEvent:event] == NO) return  nil; // 点不在当前控件
    
    // 3.从后往前遍历自己的子控件
    // 1 0
    int count = (int)self.subviews.count;
    for (int i = count - 1; i >= 0; i--) {
        // 获取子控件
        UIView *childView = self.subviews[i];
        
        // 把当前坐标系上的点转换成子控件上的点
        CGPoint childP =  [self convertPoint:point toView:childView];
        
        UIView *fitView = [childView hitTest:childP withEvent:event];
        
        if (fitView) {
            return fitView;
        }
        
    }
    // 4.如果没有比自己合适的子控件,最合适的view就是自己
    return self;
}

//此方法内使用bouds判断是否在本视图范围内
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    NSLog(@"%s",__func__);
    
    return CGRectContainsPoint(self.bounds, point);
}

@end

@interface IBViewB : UIView

@end

@implementation IBViewB

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor orangeColor];
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"%s",__func__);
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    NSLog(@"%s",__func__);

    // 1.判断下自己能否接收事件
    if (self.userInteractionEnabled == NO || self.hidden == YES || self.alpha <= 0.01) return nil;
    
    // 2.判断下点在不在当前控件上
    if ([self pointInside:point withEvent:event] == NO) return  nil; // 点不在当前控件
    
    // 3.从后往前遍历自己的子控件
    // 1 0
    int count = (int)self.subviews.count;
    for (int i = count - 1; i >= 0; i--) {
        // 获取子控件
        UIView *childView = self.subviews[i];
        
        // 把当前坐标系上的点转换成子控件上的点
        CGPoint childP =  [self convertPoint:point toView:childView];
        
        UIView *fitView = [childView hitTest:childP withEvent:event];
        
        if (fitView) {
            return fitView;
        }
        
    }
    // 4.如果没有比自己合适的子控件,最合适的view就是自己
    return self;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    NSLog(@"%s",__func__);
    
    return CGRectContainsPoint(self.bounds, point);
}



@end

@interface IBViewC : UIView

@end

@implementation IBViewC

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor lightGrayColor];
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"%s",__func__);
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    NSLog(@"%s",__func__);
    
    // 1.判断下自己能否接收事件
    if (self.userInteractionEnabled == NO || self.hidden == YES || self.alpha <= 0.01) return nil;
    
    // 2.判断下点在不在当前控件上
    if ([self pointInside:point withEvent:event] == NO) return  nil; // 点不在当前控件
    
    // 3.从后往前遍历自己的子控件
    // 1 0
    int count = (int)self.subviews.count;
    for (int i = count - 1; i >= 0; i--) {
        // 获取子控件
        UIView *childView = self.subviews[i];
        
        // 把当前坐标系上的点转换成子控件上的点
        CGPoint childP =  [self convertPoint:point toView:childView];
        
        UIView *fitView = [childView hitTest:childP withEvent:event];
        
        if (fitView) {
            return fitView;
        }
        
    }
    // 4.如果没有比自己合适的子控件,最合适的view就是自己
    return self;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    NSLog(@"%s",__func__);
    
    return CGRectContainsPoint(self.bounds, point);
}


@end


@interface IBViewD : UIView

@end

@implementation IBViewD

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor purpleColor];
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    for (UIResponder *next = self; next; next = [next nextResponder]) {
        NSLog(@"响应者——>%@", next.class);
    }
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    NSLog(@"%s",__func__);
    return [super hitTest:point withEvent:event];
}
//扩大响应范围
- (BOOL)pointInside:(CGPoint)point withEvent:(nullable UIEvent *)event {
    CGRect rect = CGRectMake(self.bounds.origin.x - 100, self.bounds.origin.y, self.width + 200, self.height);
    return CGRectContainsPoint(rect, point);
}

@end


@interface IBController11 ()

@end

@implementation IBController11

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    IBViewA *viewA = [[IBViewA alloc] initWithFrame:CGRectMake(20, 100, self.view.width - 40, 300)];
    [self.view addSubview:viewA];
    IBViewB *viewB = [[IBViewB alloc] initWithFrame:CGRectMake(20, 50, viewA.width - 40, 200)];
    [viewA addSubview:viewB];
    IBViewC *viewC = [[IBViewC alloc] initWithFrame:CGRectMake(20, 50, viewB.width - 40, 100)];
    [viewB addSubview:viewC];
//    viewB.userInteractionEnabled = NO;
    
    IBViewD *viewD = [[IBViewD alloc] initWithFrame:CGRectMake(100, 500, self.view.width - 200, 80)];
    [self.view addSubview:viewD];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"%s",__func__);
}

@end
