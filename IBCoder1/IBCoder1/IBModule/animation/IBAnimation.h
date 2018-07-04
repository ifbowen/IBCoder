//
//  IBAnimation.h
//  IBCoder1
//
//  Created by Bowen on 2018/6/29.
//  Copyright © 2018年 BowenCoder. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IBAnimation : NSObject

@end

//点击视图扩大，其他视图散开效果(半成品)
@interface UIViewAnimationContainer : NSObject

- (instancetype)init;

- (instancetype)initWithViews:(NSArray *)views;

- (void)setViews:(NSArray *)views;

- (void)addView:(UIView *)view;

- (void)openThisView:(UIView *)view;

- (void)closeThisView:(UIView *)view;

@end

@interface UIView (Animation)

- (void)explosition:(CGPoint)origin distance:(float)distance duration:(float)duration delay:(float)delay;

@end
