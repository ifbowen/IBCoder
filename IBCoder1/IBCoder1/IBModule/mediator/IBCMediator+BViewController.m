//
//  IBCMediator+BViewController.m
//  IBCMediatorDemo
//
//  Created by Bowen on 2018/4/12.
//  Copyright © 2018年 BowenCoder. All rights reserved.
//

#import "IBCMediator+BViewController.h"

@implementation IBCMediator (BViewController)

+ (UIViewController *)ibc_bController {
    return [IBCMediator performTarget:@"BViewController" action:@"present" params:nil shouldCacheTarget:NO];
}

@end
