//
//  IBGroup2Controller9.m
//  MBCoder
//
//  Created by Bowen on 2019/10/9.
//  Copyright © 2019 inke. All rights reserved.
//

#import "IBGroup2Controller9.h"
#import <FDFullscreenPopGesture/UINavigationController+FDFullscreenPopGesture.h>
#import <TZScrollViewPopGesture/UINavigationController+TZPopGesture.h>

@interface IBGroup2Controller9 ()

@end

@implementation IBGroup2Controller9

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self configScrollView];
}

- (void)configScrollView {
    
    self.fd_prefersNavigationBarHidden = YES;
    self.fd_interactivePopDisabled = YES;
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    scrollView.contentSize = CGSizeMake(1000, 0);
    scrollView.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:scrollView];
    
    // scrollView需要支持侧滑返回
    [self tz_addPopGestureToView:scrollView];
    
}

@end
