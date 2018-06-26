//
//  IBCAScrollLayer.m
//  IBCoder1
//
//  Created by Bowen on 2018/6/8.
//  Copyright © 2018年 BowenCoder. All rights reserved.
//

#import "IBCAScrollLayer.h"

/**
 对于一个未转换的图层，它的bounds和它的frame是一样的，frame属性是由bounds属性自动计算而出的，所以更改任意一个值都会更新其他值。
 */
@implementation IBCAScrollLayer

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupLayer];
    }
    return self;
}

- (void)setupLayer {
    
}

@end
