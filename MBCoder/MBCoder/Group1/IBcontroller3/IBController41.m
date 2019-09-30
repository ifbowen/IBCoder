//
//  IBController41.m
//  IBCoder1
//
//  Created by Bowen on 2018/9/14.
//  Copyright © 2018年 BowenCoder. All rights reserved.
//

#import "IBController41.h"


@implementation controller41

+ (void)test:(NSString *)name{
    NSLog(@"%s", __func__);
}

+ (void)run:(NSString *)time {
    NSLog(@"%s", __func__);
}

+ (void)sleep {
    NSLog(@"%s", __func__);
}

+ (void)eat {
    NSLog(@"%s", __func__);
}

+ (void)house {
    NSLog(@"%s", __func__);
}


@end



@interface IBController41 ()

@end

@implementation IBController41

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [controller41 test:nil];
    [controller41 run:nil];
    [controller41 eat];
    [controller41 house];
//    [controller41 sleep];
    
    CGRect rect = {1,2,3,4};
}


@end
