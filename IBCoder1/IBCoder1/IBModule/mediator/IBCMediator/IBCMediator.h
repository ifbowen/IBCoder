//
//  IBCMediator.h
//  IBCMediatorLib
//
//  Created by Bowen on 2018/4/12.
//  Copyright © 2018年 BowenCoder. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IBCViewController.h"

@interface IBCMediator : NSObject

+ (instancetype)sharedInstance;

+ (IBCViewController *)enter_IBCViewController:(NSString *)vc params:(NSDictionary *)params;

/**
 远程App调用入口
 
 url规则: scheme://[target]/[action]?[params]
 URL例子: app://targetA/actionB?id=1234
 */
+ (nonnull id)performActionWithUrl:(NSString *)url completion:(void(^ _Nullable)(_Nullable id result))completion;

// 本地组件调用入口
+ (nullable id)performTarget:(NSString *)targetName action:(NSString *)actionName params:(nullable NSDictionary *)params shouldCacheTarget:(BOOL)shouldCacheTarget;

+ (void)releaseTargetCacheWithTargetName:(NSString *)targetName;

- (id)performActionWithUrl:(NSString *)url completion:(void(^)(NSDictionary *info))completion;

- (id)performTarget:(NSString *)targetName action:(NSString *)actionName params:(NSDictionary *)params shouldCacheTarget:(BOOL)shouldCacheTarget;

- (void)releaseCachedTargetWithTargetName:(NSString *)targetName;

@end








