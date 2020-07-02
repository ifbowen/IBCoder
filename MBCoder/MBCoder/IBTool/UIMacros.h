//
//  UIMacros.h
//  IBApplication
//
//  Created by Bowen on 2018/6/21.
//  Copyright © 2018年 BowenCoder. All rights reserved.
//

#ifndef UIMacros_h
#define UIMacros_h

#define random(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)/255.0]

#define randomColor random(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))

#define k16RGB(rgbValue) k16RGBA(rgbValue, 1.0)
#define k16RGBA(rgbValue, alphaValue) \
    [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0 \
                    green:((float)((rgbValue & 0xFF00) >> 8)) / 255.0 \
                     blue:((float)(rgbValue & 0xFF)) / 255.0 alpha:alphaValue]

#define IPHONEX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

// 获取屏幕尺寸
#define kScreenWidth     [[UIScreen mainScreen] bounds].size.width
#define kScreenHeight    [[UIScreen mainScreen] bounds].size.height
#define kScreenBounds    [[UIScreen mainScreen] bounds]

// 状态栏高度(iPhoneX:44, 其他:20)
#define kStatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height

// 导航栏高度
#define kNavBarHeight    44

// 状态栏和导航栏总高度
#define kTopBarHeight          (kStatusBarHeight + kNavBarHeight)

// 顶部安全区域远离高度
#define kSafeAreaTopHeight     kStatusBarHeight

// 底部安全区域远离高度
#define kSafeAreaBottomHeight  (IPHONEX ? 17 : 0)

// TabBar高度
#define kTabBarHeight          (kSafeAreaBottomHeight + 49)

// 安全区域高度(包含导航栏和标签栏)
#define kSafeAreaHeight        (kScreenHeight - kSafeAreaTopHeight - kSafeAreaBottomHeight)

// 不包含导航
#define kTabSafeAreaHeight     (kSafeAreaHeight - kNavBarHeight)

// 不包含标签栏
#define kNavSafeAreaHeight     (kSafeAreaHeight - kTabBarHeight)

// 不包含状态栏和标签栏
#define kViewHeight            (kSafeAreaHeight - kNavBarHeight - kTabBarHeight)

// 横向宽度
#define kFitWidth(width)      (kScreenWidth  * (width/667.00))

// 纵向高度
#define kFitHeight(height)    (kScreenHeight * (height/375.00))

#endif /* UIMacros_h */
