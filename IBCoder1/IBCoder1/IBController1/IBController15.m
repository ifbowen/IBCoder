//
//  IBController15.m
//  IBCoder1
//
//  Created by Bowen on 2018/5/8.
//  Copyright © 2018年 BowenCoder. All rights reserved.
//

#import "IBController15.h"
#import "Calculate.h"
#import "BProxy.h"
#import "YYWeakProxy.h"

@interface IBController15 ()

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation IBController15

//- (void)viewWillDisappear:(BOOL)animated {
//    [self.timer invalidate];
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    test1();
    test2();
    [self test3];
}

void test1 () {
    Calculate *cal = [[Calculate alloc] init];
    [cal add];
    [cal add1];
}

void test2() {
    BProxy *proxy = [BProxy proxy];
    [proxy purchaseBookWithTitle:@"上衣"];
    [proxy purchaseClothesWithSize:BClothesSizeLarge];
}

- (void)test3 {
    self.timer = [NSTimer timerWithTimeInterval:1
                                         target:[YYWeakProxy proxyWithTarget:self]
                                       selector:@selector(timerInvoked:)
                                       userInfo:nil
                                        repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];

}

- (void)timerInvoked:(NSTimer *)timer{
    NSLog(@"1");
}
- (void)dealloc
{
    NSLog(@"%s",__func__);
}

@end
