//
//  IBController19.m
//  IBCoder1
//
//  Created by Bowen on 2018/5/13.
//  Copyright © 2018年 BowenCoder. All rights reserved.
//

#import "IBController19.h"
#import <objc/runtime.h>
#import <objc/message.h>

@interface Doctor: NSObject

@end

@implementation Doctor

- (void)eat {
    NSLog(@"%s",__func__);
}

- (void)sleep {
    NSLog(@"%s",__func__);
}



@end

@interface IBController19 ()

@end

/*
 
 */

@implementation IBController19


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self performSelector:@selector(run:) withObject:@"haha"];
    [self performSelector:@selector(eat) withObject:@"hehe"];
    [self performSelector:@selector(sleep) withObject:@"heihei"];

}

#pragma mark - 动态方法解析

+ (BOOL)resolveInstanceMethod:(SEL)sel{
    NSLog(@"resolveInstanceMethod = %@",NSStringFromSelector(sel));
    //判断没有实现方法, 那么我们就是动态添加一个方法
    if (sel == @selector(run:)) {
        class_addMethod(self, sel, (IMP)newRun, "v@:*");
        return YES;
    }
    return [super resolveInstanceMethod:sel];
}
//函数
void newRun(id self,SEL sel,NSString *str) {
    NSLog(@"---%s---%@",__func__,str);
}


#pragma mark - 消息转发重定向、备援接收者
- (id)forwardingTargetForSelector:(SEL)aSelector{
    NSLog(@"forwardingTargetForSelector = %@",NSStringFromSelector(aSelector));
    if (aSelector == @selector(eat)) {
        return [[Doctor alloc] init];
    }
    return [super forwardingTargetForSelector:aSelector];
}

#pragma mark - 完整的消息转发

//方法签名
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector OBJC_SWIFT_UNAVAILABLE(""){
    //转化字符
    NSString *sel = NSStringFromSelector(aSelector);
    //判断, 手动生成签名
    if([sel isEqualToString:@"sleep"]){
        return [NSMethodSignature signatureWithObjCTypes:"v@:"];
    }else{
        return [super methodSignatureForSelector:aSelector];
    }
}
//拿到方法签名配发消息
- (void)forwardInvocation:(NSInvocation *)anInvocation OBJC_SWIFT_UNAVAILABLE(""){
    NSLog(@"forwardInvocation---%@---",anInvocation);
    //取到消息
    SEL seletor = [anInvocation selector];
    //转发
    Doctor *doctor = [[Doctor alloc] init];
    if([doctor respondsToSelector:seletor]){
        //调用对象,进行转发
        [anInvocation invokeWithTarget:doctor];
    }else{
        return [super forwardInvocation:anInvocation];
    }
}
//抛出异常
- (void)doesNotRecognizeSelector:(SEL)aSelector{
    NSString *selStr = NSStringFromSelector(aSelector);
    NSLog(@"%@不存在",selStr);
}

@end
