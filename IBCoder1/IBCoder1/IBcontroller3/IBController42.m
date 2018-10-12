//
//  IBController42.m
//  IBCoder1
//
//  Created by Bowen on 2018/10/12.
//  Copyright © 2018 BowenCoder. All rights reserved.
//

#import "IBController42.h"
#import "UIView+Gesture.h"

@interface IBController42 ()

@end

@implementation IBController42

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(100, 200, 200, 200)];
    view.backgroundColor = [UIColor redColor];
    [self.view addSubview:view];
    [view enableScaling];
    [view enableDragging];
    [view enableRotating];
    
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(100, 500, 200, 200)];
    view1.backgroundColor = [UIColor redColor];
    [self.view addSubview:view1];
    [view1 enableScaling];
    [view1 enableDragging];
    [view1 enableRotating];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
