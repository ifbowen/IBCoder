//
//  IBController34.m
//  IBCoder1
//
//  Created by Bowen on 2018/6/8.
//  Copyright © 2018年 BowenCoder. All rights reserved.
//

#import "IBController34.h"
#import "GCDObjC.h"

@interface IBController34 ()

@property (nonatomic, strong) GCDTimer *timer;

@end

@implementation IBController34

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [self test1];
//    [self test2];
    [self test3];
}

- (void)test3 {
    
    GCDTimer *timer = [GCDTimer timer];
    self.timer = timer;
    
    [timer event:^{
        NSLog(@"1");
    } timeIntervalWithSecs:1];
    [timer start];
}

- (void)test2 {
    
    GCDGroup *group = [GCDGroup group];
    [group async:^{
        NSLog(@"0");
    }];
    [group async:^{
        NSLog(@"1");
    }];
    [group async:^{
        NSLog(@"2");
    }];
    [group notify:^{
        NSLog(@"3");
    }];
}

- (void)test1 {
    
    [[GCDQueue background] async:^{
        NSLog(@"123");
    }];
    [[GCDQueue low] barrier:^{
        NSLog(@"abc");
    } async:YES];
    [[GCDQueue high] async:^{
        NSLog(@"456");
    }];
    
}


@end
