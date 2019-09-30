//
//  IBCAShapeLayer.m
//  IBCoder1
//
//  Created by Bowen on 2018/6/7.
//  Copyright © 2018年 BowenCoder. All rights reserved.
//

#import "IBCAShapeLayer.h"
#import <UIKit/UIKit.h>

/**
 CAShapeLayer是一个通过矢量图形而不是bitmap来绘制的图层子类
 优点：
 1、渲染快速，硬件加速
 2、高效使用内存
 3、不会被图层边界裁减掉
 4、不会出现像素化
 */
@implementation IBCAShapeLayer

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupLayer];
    }
    return self;
}

- (void)setupLayer {
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path moveToPoint:CGPointMake(10, 100)];
    [path addLineToPoint:CGPointMake(250, 100)];
    
    self.strokeColor = [UIColor redColor].CGColor;
    self.fillColor = [UIColor clearColor].CGColor;
    self.lineWidth = 15;
    self.lineJoin = kCALineJoinRound;
    self.lineCap = kCALineJoinRound;
    self.path = path.CGPath;
}

@end
