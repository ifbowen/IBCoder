//
//  IBCAGradientLayer.m
//  IBCoder1
//
//  Created by Bowen on 2018/6/8.
//  Copyright © 2018年 BowenCoder. All rights reserved.
//

#import "IBCAGradientLayer.h"
#import <UIKit/UIKit.h>


/**
 CAGradientLayer是用来生成两种或更多颜色平滑渐变的(硬件加速)
 */
@implementation IBCAGradientLayer

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupLayer];
    }
    return self;
}

- (void)setupLayer {
    self.colors = @[(__bridge id)[UIColor redColor].CGColor, (__bridge id) [UIColor yellowColor].CGColor, (__bridge id)[UIColor greenColor].CGColor];
    
    self.locations = @[@0.0, @0.25, @0.5];
    
    self.startPoint = CGPointMake(0, 0);
    self.endPoint = CGPointMake(1, 1);
}

@end
