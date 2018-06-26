//
//  IBController31.m
//  IBCoder1
//
//  Created by Bowen on 2018/5/28.
//  Copyright © 2018年 BowenCoder. All rights reserved.
//

#import "IBController31.h"
#import "UIView+Ext.h"

@interface IBController31 ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIImageView *imgView;

@end

@implementation IBController31

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor orangeColor];
    self.title = @"UIScrollView";
    [self setupUI];
}

- (void)setupUI {
    UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
    scroll.backgroundColor = [UIColor lightGrayColor];
    scroll.delegate = self;
    scroll.contentSize = CGSizeMake(self.view.width * 2, self.view.height * 2);
    [self.view addSubview:scroll];
    self.imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"AppIcon"]];
    self.imgView.center = self.view.center;
    [scroll addSubview:self.imgView];
//    scroll.contentSize = self.imgView.image.size;
    scroll.maximumZoomScale = 5.0;
    scroll.minimumZoomScale = 1.0;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSLog(@"%@",NSStringFromCGPoint(scrollView.contentOffset));
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
//    NSLog(@"%@",NSStringFromCGPoint(scrollView.contentOffset));
//    self.imgView.center = scrollView.contentOffset;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
//    self.imgView.center = self.view.center;

    return self.imgView;
}





@end
