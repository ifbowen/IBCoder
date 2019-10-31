//
//  IBGroup2Controller13.m
//  MBCoder
//
//  Created by Bowen on 2019/10/30.
//  Copyright © 2019 inke. All rights reserved.
//

#import "IBGroup2Controller13.h"
#import <PromiseKit.h>
#import <UIView+AnyPromise.h>

@interface IBGroup2Controller13 ()

@end

@implementation IBGroup2Controller13

/**
 PromiseKit主要解决的是 “回调地狱” 的问题
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self test3];
}

/**
 PMKRace
 只要处理结束一个任务，立即执行then或者catch方法，其他任务继续执行。（只关心第一个处理结束的任务，不关心其他任务）
 
 PMKHang
 阻塞线程，直到任务 处理结束。这个做法不安全，只在调试时用！！！

 */
- (void)test4
{
    
}

/**
 PMKWhen
 等待所有任务处理成功，执行下一步。（一旦有任务 处理失败，立即跳转到then方法，且停止执行其他任务）
 */
- (void)test3
{
    AnyPromise *ricePromise = [AnyPromise promiseWithAdapterBlock:^(PMKAdapter  _Nonnull adapter) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSLog(@"吃完米饭");
            adapter(@"吃完米饭", nil);
        });
    }];
    
    AnyPromise *soupPromise = [AnyPromise promiseWithAdapterBlock:^(PMKAdapter  _Nonnull adapter) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSLog(@"喝完汤");
            adapter(@"喝完汤", [NSError errorWithDomain:@"错误" code:-1 userInfo:nil]);
        });
    }];
    
    PMKWhen(@[ricePromise, soupPromise]).then(^(NSArray* messages){// 此时参数是数组类型
        NSLog(@"接着");
    }).catch(^(NSError* error){
        NSLog(@"%@", error);
    });

}
    
/**
 PMKJoin
 等待所有任务处理结束，执行下一步。（所有任务处理结束才会处理处理失败，如果有就跳转到then方法）
 PMKAfter
 延迟一定时间执行任务
 */
- (void)test2
{
    AnyPromise *ricePromise = [AnyPromise promiseWithAdapterBlock:^(PMKAdapter  _Nonnull adapter) {
        NSLog(@"吃完米饭");
        adapter(@"吃完米饭", nil);
    }];
    
    AnyPromise *soupPromise = [AnyPromise promiseWithAdapterBlock:^(PMKAdapter  _Nonnull adapter) {
        NSLog(@"喝完汤");
        adapter(@"喝完汤", nil);
    }];
        
    PMKJoin(@[ricePromise, soupPromise]).then(^(NSArray* messages){// 此时参数是数组类型
        NSLog(@"接着");
        return PMKAfter(3.0).then(^{
            return [AnyPromise promiseWithAdapterBlock:^(PMKAdapter  _Nonnull adapter) {
                NSLog(@"吃水果");
                adapter(@"吃水果", [NSError errorWithDomain:@"错误" code:-1 userInfo:nil]);
            }];;
        });
    }).then(^{
        NSLog(@"玩");
    }).catch(^(NSError* error){
        NSLog(@"%@", error);
    });
}

/// 基本用法
- (void)test1
{
    [AnyPromise promiseWithAdapterBlock:^(PMKAdapter  _Nonnull adapter) {
        adapter(@"注册成功", nil); // 处理成功
    }].then(^(NSString *msg){
        NSLog(@"%@",msg);
        return [AnyPromise promiseWithResolverBlock:^(PMKResolver _Nonnull resolver) {
            resolver(@"登录成功");
        }];
    }).then(^(NSString *msg){
        NSLog(@"%@",msg);
    }).ensureOn(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"%@",[NSThread currentThread]);
    }).catch(^(NSError *error){
        NSLog(@"%@", error);
    });
}


@end
