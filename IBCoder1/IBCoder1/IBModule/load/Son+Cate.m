//
//  Son+Cate.m
//  test
//
//  Created by Bowen on 2018/3/26.
//  Copyright © 2018年 BowenCoder. All rights reserved.
//

#import "Son+Cate.h"

@implementation Son (Cate)

+ (void)load {
    NSLog(@"%s", __FUNCTION__);
}

+ (void)initialize {
    NSLog(@"%s", __FUNCTION__);
}

- (void)run {
    NSLog(@"%s", __FUNCTION__);
}


@end
