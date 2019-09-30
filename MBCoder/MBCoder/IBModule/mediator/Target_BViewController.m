//
//  Target_BViewController.m
//  IBCMediatorDemo
//
//  Created by Bowen on 2018/4/12.
//  Copyright © 2018年 BowenCoder. All rights reserved.
//

#import "Target_BViewController.h"
#import "BViewController.h"

@implementation Target_BViewController

- (BViewController *)Action_present:(NSDictionary *)dict {
    BViewController *a = [[BViewController alloc] init];
    return a;
}


@end
