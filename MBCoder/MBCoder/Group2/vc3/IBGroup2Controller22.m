//
//  IBGroup2Controller22.m
//  MBCoder
//
//  Created by Bowen on 2019/12/4.
//  Copyright © 2019 inke. All rights reserved.
//

#import "IBGroup2Controller22.h"
#import "MBPresentationController.h"

@interface MBPresentationViewController : UIViewController

@end

@implementation MBPresentationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

@end

@interface IBGroup2Controller22 ()

@property (nonatomic, strong) UIViewController *vc;
@property (nonatomic, strong) MBPresentationController *presentation;


@end

@implementation IBGroup2Controller22

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    MBPresentationViewController *vc =[[MBPresentationViewController alloc] init];
    MBPresentationController *presentation = [[MBPresentationController alloc] initWithPresentedViewController:vc presentingViewController:self];
    presentation.frame = CGRectMake(0, self.view.frame.size.height-300, self.view.frame.size.width, 300);
    vc.transitioningDelegate = presentation;
    self.vc = vc;
    self.presentation = presentation;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"present" forState:UIControlStateNormal];
    [button setBackgroundColor:UIColor.orangeColor];
    button.frame = CGRectMake(0, 100, self.view.frame.size.width, 44);
    [button addTarget:self action:@selector(present) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)present
{
    [self presentViewController:self.vc animated:YES completion:nil];
}


@end
