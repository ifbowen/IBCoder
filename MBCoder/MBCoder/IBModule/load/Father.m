//
//  Father.m
//  test
//
//  Created by Bowen on 2018/3/26.
//  Copyright © 2018年 BowenCoder. All rights reserved.
//

#import "Father.h"

@implementation Father

+ (void)load {
    NSLog(@"%s", __FUNCTION__);
}

+ (void)initialize {
    NSLog(@"%s", __FUNCTION__);
}

- (void)sleep {
    NSLog(@"Father:%@",self);
}

- (void)run {
    NSLog(@"%s", __FUNCTION__);
}

@end
