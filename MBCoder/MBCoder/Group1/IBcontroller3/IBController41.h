//
//  IBController41.h
//  IBCoder1
//
//  Created by Bowen on 2018/9/14.
//  Copyright © 2018年 BowenCoder. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN // 只对 显式赋值nil 这种情况编译器会给出警告

#define IBUNAVAILABLE(name) __attribute__ ((unavailable(name)))
#define IBAVAILABLE(_ios) __attribute__((availability(ios,introduced=_ios)))
#define IBDEPRECATED __attribute__ ((deprecated))


// __attribute__ 是在编译阶段起作用的，给函数、变量提供了更多的错误检查、版本控制等能力

@interface controller41 : NSObject

+ (void)study NS_UNAVAILABLE;

+ (void)test:(NSString *)name NS_AVAILABLE_IOS(8_0);
+ (void)run:(NSString *)time NS_DEPRECATED_IOS(5_0,8_0);

+ (void)sleep IBUNAVAILABLE("已经废弃");
+ (void)eat IBDEPRECATED;
+ (void)house IBAVAILABLE(13_0);

@end


@interface IBController41 : UIViewController

@end

NS_ASSUME_NONNULL_END
