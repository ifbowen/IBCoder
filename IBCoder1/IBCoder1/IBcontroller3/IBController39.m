//
//  IBController39.m
//  IBCoder1
//
//  Created by Bowen on 2018/7/27.
//  Copyright © 2018年 BowenCoder. All rights reserved.
//

#import "IBController39.h"

@interface IBController39 ()

@end

@implementation IBController39

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self test1];
}

/*
 
 引言
 Core Foundation框架 (CoreFoundation.framework) 是一组C语言接口，它们为iOS应用程序提供基本数据管理和服务功能。
 下面列举该框架支持进行管理的数据以及可提供的服务：
 1.群体数据类型 (数组、集合等)
 2.程序包
 3.字符串管理
 4.日期和时间管理
 5.原始数据块管理
 6.偏好管理
 7.URL及数据流操作
 8.线程和RunLoop
 9.端口和soket通讯

 
 1.__bridge
 CF和OC对象转化时只涉及对象类型不涉及对象所有权的转化
 
 2.__bridge_transfer
 常用在CF对象转化成OC对象时，将CF对象的所有权交给OC对象，此时ARC就能自动管理该内存,作用同CFBridgingRelease()
 __bridge_retained 是编译器替我们做了 retain 操作，而 __bridge_transfer 是替我们做了 release
 
 3.__bridge_retained
 与__bridge_transfer 相反，常用在将OC对象转化成CF对象，且OC对象的所有权也交给CF对象来管理，即OC对象转化成CF对象时，
 涉及到对象类型和对象所有权的转化，作用同CFBridgingRetain()
 
 */
- (void)test1 {
    
    UIColor *color = [UIColor redColor];
    CGColorRef colorRef = (__bridge CGColorRef)(color);
    NSLog(@"%@", colorRef);

    
    NSString *string = [NSString stringWithFormat:@"abc"];
    CFStringRef cfStr = (__bridge_retained CFStringRef)string;
    CFRelease(cfStr);// 由于Core Foundation的对象不属于ARC的管理范畴，所以需要自己release
    
    
    CFStringRef cfString = CFURLCreateStringByAddingPercentEscapes( NULL, (__bridge CFStringRef)@"12345", NULL, CFSTR("!*’();:@&=+$,/?%#[]"), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    NSString *ocString = (__bridge_transfer NSString *)cfString;
    
    NSLog(@"%@--%@", cfStr, ocString);

}

@end
