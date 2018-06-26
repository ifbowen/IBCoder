//
//  Son.m
//  test
//
//  Created by Bowen on 2018/3/26.
//  Copyright © 2018年 BowenCoder. All rights reserved.
//

#import "Son.h"

@implementation Son {
    void *_parents;
    NSString *_girlfriend;
}

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
