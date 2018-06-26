//
//  Target_AViewController.m
//  IBCMediatorDemo
//
//  Created by Bowen on 2018/4/12.
//  Copyright © 2018年 BowenCoder. All rights reserved.
//

#import "Target_AViewController.h"
#import "AViewController.h"

@implementation Target_AViewController

- (AViewController *)Action_present:(NSDictionary *)dict {
    AViewController *a = [[AViewController alloc] init];
    return a;
}

@end
