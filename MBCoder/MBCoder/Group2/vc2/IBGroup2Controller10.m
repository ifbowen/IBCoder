//
//  IBGroup2Controller10.m
//  MBCoder
//
//  Created by Bowen on 2019/10/10.
//  Copyright © 2019 inke. All rights reserved.
//

#import "IBGroup2Controller10.h"
#import <YogaKit/UIView+Yoga.h>

/*
 弹性盒子由弹性容器(Flex container)和弹性子元素(Flex item)组成。
 一、flex-direction
 flex-direction 属性指定了弹性子元素在父容器中的位置。
 
 row：横向从左到右排列（左对齐），默认的排列方式。
 row-reverse：反转横向排列（右对齐，从后往前排，最后一项排在最前面。
 column：纵向排列。
 column-reverse：反转纵向排列，从后往前排，最后一项排在最上面。
 
 二、justify-content 属性
 内容对齐（justify-content）属性应用在弹性容器上，把弹性项沿着弹性容器的主轴线（main axis）对齐。
 
 flex-start：弹性项目向行头紧挨着填充。这个是默认值。
 第一个弹性项的main-start外边距边线被放置在该行的main-start边线，而后续弹性项依次平齐摆放。
 
 flex-end：弹性项目向行尾紧挨着填充。
 第一个弹性项的main-end外边距边线被放置在该行的main-end边线，而后续弹性项依次平齐摆放。
 
 center：弹性项目居中紧挨着填充。
 （如果剩余的自由空间是负的，则弹性项目将在两个方向上同时溢出）。
 
 space-between：弹性项目平均分布在该行上。
 如果剩余空间为负或者只有一个弹性项，则该值等同于flex-start。否则，第1个弹性项的外边距和行的main-start边线对齐，
 而最后1个弹性项的外边距和行的main-end边线对齐，然后剩余的弹性项分布在该行上，相邻项目的间隔相等。
 
 space-around：弹性项目平均分布在该行上，两边留有一半的间隔空间。
 如果剩余空间为负或者只有一个弹性项，则该值等同于center。否则，弹性项目沿该行分布，且彼此间隔相等（比如是20px），
 同时首尾两边和弹性容器之间留有一半的间隔（1/2*20px=10px）。
 
 三、align-items 属性
 align-items 设置或检索弹性盒子元素在侧轴（纵轴）方向上的对齐方式。
 
 flex-start：弹性盒子元素的侧轴（纵轴）起始位置的边界紧靠住该行的侧轴起始边界。
 flex-end：弹性盒子元素的侧轴（纵轴）起始位置的边界紧靠住该行的侧轴结束边界。
 center：弹性盒子元素在该行的侧轴（纵轴）上居中放置。（如果该行的尺寸小于弹性盒子元素的尺寸，则会向两个方向溢出相同的长度）。
 baseline：如弹性盒子元素的行内轴与侧轴为同一条，则该值与'flex-start'等效。其它情况下，该值将参与基线对齐。
 stretch：如果指定侧轴大小的属性值为'auto'，则其值会使项目的边距盒的尺寸尽可能接近所在行的尺寸，
 但同时会遵照'min/max-width/height'属性的限制。
 
 四、flex-wrap 属性
 flex-wrap 属性用于指定弹性盒子的子元素换行方式。
 
 nowrap - 默认， 弹性容器为单行。该情况下弹性子项可能会溢出容器。
 wrap - 弹性容器为多行。该情况下弹性子项溢出的部分会被放置到新行，子项内部会发生断行
 wrap-reverse -反转 wrap 排列。
 
 五、align-content 属性
 align-content 属性用于修改 flex-wrap 属性的行为。类似于 align-items, 但它不是设置弹性子元素的对齐，而是设置各个行的对齐。

 stretch - 默认。各行将会伸展以占用剩余的空间。
 flex-start - 各行向弹性盒容器的起始位置堆叠。
 flex-end - 各行向弹性盒容器的结束位置堆叠。
 center -各行向弹性盒容器的中间位置堆叠。
 space-between -各行在弹性盒容器中平均分布。
 space-around - 各行在弹性盒容器中平均分布，两端保留子元素与子元素之间间距大小的一半。

 六、align-self
 align-self 属性用于设置弹性元素自身在侧轴（纵轴）方向上的对齐方式。
 
 auto：如果'align-self'的值为'auto'，则其计算值为元素的父元素的'align-items'值，如果其没有父元素，则计算值为'stretch'。
 flex-start：弹性盒子元素的侧轴（纵轴）起始位置的边界紧靠住该行的侧轴起始边界。
 flex-end：弹性盒子元素的侧轴（纵轴）起始位置的边界紧靠住该行的侧轴结束边界。
 center：弹性盒子元素在该行的侧轴（纵轴）上居中放置。（如果该行的尺寸小于弹性盒子元素的尺寸，则会向两个方向溢出相同的长度）。
 baseline：如弹性盒子元素的行内轴与侧轴为同一条，则该值与'flex-start'等效。其它情况下，该值将参与基线对齐。
 stretch：如果指定侧轴大小的属性值为'auto'，则其值会使项目的边距盒的尺寸尽可能接近所在行的尺寸，
 但同时会遵照'min/max-width/height'属性的限制。
 
 七、flex
 flex 属性用于指定弹性子元素如何分配空间。
 
 flex-grow：定义弹性盒子元素的扩展比率。
 flex-shrink：定义弹性盒子元素的收缩比率。
 flex-basis：定义弹性盒子元素的默认基准值。
 
 */
@interface IBGroup2Controller10 ()

@end

@implementation IBGroup2Controller10

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    [self layout5];
}

/**
 中心布局加上嵌套布局
 */
- (void)layout1
{
    [self.view configureLayoutWithBlock:^(YGLayout * layout) {
        layout.isEnabled = YES;
        layout.justifyContent = YGJustifyCenter;
        layout.alignItems     = YGAlignCenter;
    }];
    
    UIView *redView = [UIView new];
    redView.backgroundColor = UIColor.redColor;
    [redView configureLayoutWithBlock:^(YGLayout * layout) {
        layout.isEnabled = YES;
        layout.width = layout.height = YGPointValue(100);
    }];
    [self.view addSubview:redView];
    
    UIView *yellowView = [UIView new];
    yellowView.backgroundColor = UIColor.yellowColor;
    [yellowView configureLayoutWithBlock:^(YGLayout *layout) {
        layout.isEnabled = YES;
        layout.margin = YGPointValue(10);
        layout.flexGrow = 1;
    }];
    [redView addSubview:yellowView];
    
    [self.view.yoga applyLayoutPreservingOrigin:YES];
    
}

- (void)layout2
{
    [self.view configureLayoutWithBlock:^(YGLayout * layout) {
        layout.isEnabled = YES;
        layout.width = YGPointValue(self.view.bounds.size.width);
        layout.height = YGPointValue(self.view.bounds.size.height);
        layout.alignItems = YGAlignCenter;
    }];
    
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = [UIColor lightGrayColor];
    [contentView configureLayoutWithBlock:^(YGLayout * layout) {
        layout.isEnabled = true;
        layout.flexDirection =  YGFlexDirectionRow;
        layout.width = YGPointValue(320);
        layout.height = YGPointValue(80);
        layout.marginTop = YGPointValue(100);
        layout.padding =  YGPointValue(10); // 设置了全部子项目的填充值
    }];
    
    UIView *child1 = [[UIView alloc] init];
    child1.backgroundColor = [UIColor redColor];
    [child1 configureLayoutWithBlock:^(YGLayout * layout) {
        layout.isEnabled = YES;
        layout.width = YGPointValue(80);
        layout.marginRight = YGPointValue(10);
    }];
    
    UIView *child2 = [[UIView alloc] init];
    child2.backgroundColor = [UIColor blueColor];
    [child2 configureLayoutWithBlock:^(YGLayout * layout) {
        layout.isEnabled = YES;
        layout.width = YGPointValue(80);
        layout.flexGrow = 1;
        layout.height = YGPointValue(20);
        layout.alignSelf = YGAlignCenter;
        
    }];
    
    [contentView addSubview:child1];
    [contentView addSubview:child2];
    [self.view addSubview:contentView];
    [self.view.yoga applyLayoutPreservingOrigin:YES];
}

/**
 等间距排列
 */
- (void)layout3
{
    [self.view configureLayoutWithBlock:^(YGLayout *layout) {
        layout.isEnabled = YES;
        layout.justifyContent =  YGJustifySpaceBetween;
        layout.alignItems     =  YGAlignCenter;
    }];
    
    for ( int i = 1 ; i <= 10 ; ++i )
    {
        UIView *item = [UIView new];
        item.backgroundColor = [UIColor colorWithHue:( arc4random() % 256 / 256.0 )
                                          saturation:( arc4random() % 128 / 256.0 ) + 0.5
                                          brightness:( arc4random() % 128 / 256.0 ) + 0.5
                                               alpha:1];
        [item configureLayoutWithBlock:^(YGLayout *layout) {
            layout.isEnabled = YES;
            layout.height     = YGPointValue(10*i);
            layout.width      = YGPointValue(10*i);
        }];
        
        [self.view addSubview:item];
    }
    [self.view.yoga applyLayoutPreservingOrigin:YES];

}

/**
 等间距，自动设宽
 */
- (void)layout4
{
    [self.view configureLayoutWithBlock:^(YGLayout *layout) {
        layout.isEnabled = YES;
        layout.flexDirection  =  YGFlexDirectionRow;
        layout.alignItems     =  YGAlignCenter;
        layout.paddingHorizontal = YGPointValue(5);
    }];
    
    YGLayoutConfigurationBlock layoutBlock =^(YGLayout *layout) {
        layout.isEnabled = YES;
        layout.height= YGPointValue(100);
        layout.marginHorizontal = YGPointValue(5);
        layout.flexGrow = 1;
    };
    
    UIView *redView = [UIView new];
    redView.backgroundColor = UIColor.redColor;
    
    UIView *yellowView = [UIView new];
    yellowView.backgroundColor = UIColor.yellowColor;

    [redView configureLayoutWithBlock:layoutBlock];
    [yellowView configureLayoutWithBlock:layoutBlock];
    
    [self.view addSubview:redView];
    [self.view addSubview:yellowView];
    
    [self.view.yoga applyLayoutPreservingOrigin:YES];

}

/*
 UIScrollView 排列自动计算 contentSize
 */
- (void)layout5
{
    [self.view configureLayoutWithBlock:^(YGLayout *layout) {
        layout.isEnabled      = YES;
        layout.justifyContent =  YGJustifyCenter;
        layout.alignItems     =  YGAlignStretch;
    }];
    
    UIScrollView *scrollView = [[UIScrollView alloc] init] ;
    scrollView.backgroundColor = [UIColor grayColor];
    [scrollView configureLayoutWithBlock:^(YGLayout *layout) {
        layout.isEnabled = YES;
        layout.flexDirection = YGFlexDirectionColumn;
        layout.height = YGPointValue(500);
    }];
    [self.view addSubview:scrollView];
    
    UIView *contentView = [UIView new];
    [contentView configureLayoutWithBlock:^(YGLayout * _Nonnull layout) {
        layout.isEnabled = YES;
    }];
    
    for ( int i = 1 ; i <= 20 ; ++i )
    {
        UIView *item = [UIView new];
        item.backgroundColor = [UIColor colorWithHue:( arc4random() % 256 / 256.0 )
                                          saturation:( arc4random() % 128 / 256.0 ) + 0.5
                                          brightness:( arc4random() % 128 / 256.0 ) + 0.5
                                               alpha:1];
        [item  configureLayoutWithBlock:^(YGLayout *layout) {
            layout.isEnabled = YES;
            layout.height     = YGPointValue(20*i);
            layout.width      = YGPointValue(100);
            layout.marginLeft = YGPointValue(10);
        }];
        
        [contentView addSubview:item];
    }
    
    [scrollView addSubview:contentView];
    [self.view.yoga applyLayoutPreservingOrigin:YES];
    scrollView.contentSize = contentView.bounds.size;
}

@end
