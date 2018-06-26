//
//  UIView+Ext.h
//  IOS_0301_Drawer(抽屉效果)
//
//  Created by ma c on 16/3/2.
//  Copyright © 2016年 博文科技. All rights reserved.
//

#import <UIKit/UIKit.h>

#define IPHONEX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

//获取屏幕宽高
#define ScreenWidth     [[UIScreen mainScreen] bounds].size.width
#define ScreenHeight    [[UIScreen mainScreen] bounds].size.height
#define ScreenBounds    [[UIScreen mainScreen] bounds]

// 状态栏高度(iPhoneX:44, 其他:20)
#define StatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height

// 导航栏高度
#define NavBarHeight    44

// 状态栏和导航栏总高度
#define TopBarHeight          (StatusBarHeight + NavBarHeight)

// 顶部安全区域远离高度
#define SafeAreaTopHeight     StatusBarHeight

// 底部安全区域远离高度
#define SafeAreaBottomHeight  (IPHONEX ? 17 : 0)

// TabBar高度
#define TabBarHeight          (SafeAreaBottomHeight + 49)

// 安全区域高度(包含导航栏和标签栏)
#define SafeAreaHeight        (ScreenHeight - SafeAreaTopHeight - SafeAreaBottomHeight)

//不包含导航栏
#define TabSafeAreaHeight     (SafeAreaHeight - NavBarHeight)

//不包含标签栏
#define NavSafeAreaHeight     (SafeAreaHeight - TabBarHeight)

//不包含状态栏和标签栏
#define ViewHeight             (SafeAreaHeight - NavBarHeight - TabBarHeight)

//横向宽度
#define kHPercentage(width)    (ScreenWidth  * (width/667.00))

//纵向高度
#define kWPercentage(height)   (ScreenHeight * (height/375.00))


///< UIView的扩展类
@interface UIView (Ext)

@property (nonatomic) CGFloat originX;
@property (nonatomic) CGFloat originY;
@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;
@property (nonatomic) CGFloat centerX;
@property (nonatomic) CGFloat centerY;
@property (nonatomic) CGPoint origin;
@property (nonatomic) CGSize size;


@property (nonatomic) CGFloat left;
@property (nonatomic) CGFloat top;
@property (nonatomic) CGFloat right;
@property (nonatomic) CGFloat bottom;


@property (nonatomic) CGFloat ttx;
@property (nonatomic) CGFloat tty;


- (UIView *)topSuperView;
- (void)removeAllSubviews;

@end
