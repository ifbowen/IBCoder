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

- (void)walk {
    NSLog(@"%s",__func__);
}


@end

@interface IBController19 ()

@end

/**
 一、objc_msgSend执行流程 – 源码跟读
 objc-msg-arm64.s
 ENTRY _objc_msgSend
 b.le    LNilOrTagged
 CacheLookup NORMAL
 .macro CacheLookup
 .macro CheckMiss
 STATIC_ENTRY __objc_msgSend_uncached
 .macro MethodTableLookup
 _class_lookupMethodAndLoadCache3

 objc-runtime-new.mm
 _class_lookupMethodAndLoadCache3
 lookUpImpOrForward
 getMethodNoSuper_nolock、search_method_list_inline（已排序方法二分查找，否则遍历查找 ）、log_and_fill_cache
 log_and_fill_cache、cache_fill
 _class_resolveInstanceMethod
 _objc_msgForward_impcache

 objc-msg-arm64.s
 STATIC_ENTRY __objc_msgForward_impcache
 ENTRY __objc_msgForward

 Core Foundation
 __forwarding__（不开源）
 
 二、objc_msgSend执行流程
 1、消息发送
 1.1 runtime会根据对象的isa指针找到该对象实际所属的类
 1.2 然后在该类中的方法缓存列表中查找，找不到的话，会从class_rw_t方法列表中查找，找到方法，调用方法，加入方法cache中。
 1.3 找不到的话会通过superClass找到父类，并在父类中查找。
 1.4 如果在最顶层的父类（一般也就NSObject）中依然找不到相应的方法时，会走动态解析流程
 
 2、动态方法解析
 2.1 首先判断是否动态解析
 2.2 如果没有，调用+resolveInstanceMethod:或者+resolveClassMethod:方法动态解析方法。
 2.3 动态解析过后，标记已经动态解析，再次重新走“消息发送”的流程，也就是1.2这一步。
 2.4 注意如果动态解析没有实现相关方法，也会标记为动态解析，goto到1.2步骤，再进行动态解析判断，这次走消息转发流程。
 
 3、消息转发（无源码，参考国外牛人伪代码__forwarding__.c）
 3.1 消息转发重定向、备援接收者，调用-forwardingTargetForSelector:方法，返回值不为nil，调用objc_msgSend(返回值, SEL)
 3.2 完整的消息转发，调用-methodSignatureForSelector:方法，如果得到方法签名，调用-forwardInvocation:进行消息转发
     NSInvocation封装了方法调用，包括：方法调用者，方法名，方法参数
            
  
 
 4、抛出异常，调用doesNotRecognizeSelector:方法
 
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
    [self performSelector:@selector(walk) withObject:@"heihei"];

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

/**
+ (BOOL)resolveInstanceMethod:(SEL)sel{
    NSLog(@"resolveInstanceMethod = %@",NSStringFromSelector(sel));
    //判断没有实现方法, 那么我们就是动态添加一个方法
    if (sel == @selector(run:)) {
        Method method = class_getClassMethod(self, @selector(newRun:));
        class_addMethod(self,
                        sel,
                        method_getImplementation(method),
                        method_getTypeEncoding(method));
        return YES;
    }
    return [super resolveInstanceMethod:sel];
}
 - (void)newRun:(NSString *)str {
     NSLog(@"---%s---%@",__func__,str);
 }

*/


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
//        return [[[Doctor alloc] init] methodSignatureForSelector:@selector(sleep)];
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
