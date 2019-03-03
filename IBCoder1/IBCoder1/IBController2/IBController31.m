//
//  IBController31.m
//  IBCoder1
//
//  Created by Bowen on 2018/5/28.
//  Copyright © 2018年 BowenCoder. All rights reserved.
//

/*
 
 NSLayoutAttributeLeft 和 NSLayoutAttributeRight 代表从左右进行布局
 NSLayoutAttributeLeading和 NSLayoutAttributeTrailing 代表从前后进行布局
 
 UIScrollView ContentSize 无效
 使用Masonry进行自动布局，虽然开始已经设置了scrollView的contentSize，但是实际上在自动布局的情况下，
 contentSize的大小并不是原先设置的那样，而是由内容约束来定义的(leading,trailing)，后执行的Masonry布局代码重定义了contentSize。
 因此，自动布局的情况下去定义contentSize是无效的。 而mas_leading,mas_trailing是根据contentSize来确定的具体位置，
 而不是根据scrollview的frame来确定。 因此布局得到的并不是想要得到的结果。（其间相互依赖，导致结果异常）

 个人经验：
 在自动布局的情况下，contentSize的大小并不是原先设置的那样，而是由内容约束来定义的。
 因此UIScrollView的子视图约束不能影响以前设置好的contentSize，所以子视图约束约束
 的参照物不能全是UIScrollView。
 
 */

#import "IBController31.h"
#import "UIView+Ext.h"
#import "Masonry.h"

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
    UIScrollView *scroll = [[UIScrollView alloc] init];
    scroll.backgroundColor = [UIColor lightGrayColor];
    scroll.delegate = self;
    scroll.contentSize = CGSizeMake(self.view.width, self.view.height * 2);
    [self.view addSubview:scroll];
    [scroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
//    self.imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"AppIcon"]];
//    self.imgView.center = self.view.center;
//    [scroll addSubview:self.imgView];
//    scroll.contentSize = self.imgView.image.size;
//    scroll.maximumZoomScale = 5.0;
//    scroll.minimumZoomScale = 1.0;
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor redColor];
    [scroll addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(scroll);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(100);
    }];

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
