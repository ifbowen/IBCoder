//
//  IBController18.m
//  IBCoder1
//
//  Created by Bowen on 2018/5/9.
//  Copyright © 2018年 BowenCoder. All rights reserved.
//

#import "IBController18.h"
#import "IBCMediator.h"
#import "IBCMediator+BViewController.h"

@interface IBController18 ()

@end

@implementation IBController18

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self testurl];
//    [self testTarget];
}


- (void)testTarget {
    [self presentViewController:[IBCMediator ibc_bController] animated:YES completion:nil];
}

- (void)testurl {
    UIViewController *vc = [IBCMediator performActionWithUrl:@"lothar://AViewController/present?id=1234&color=red" completion:^(id  _Nullable result) {
        NSLog(@"%@",result);
    }];
    [self presentViewController:vc animated:YES completion:nil];
}




@end
