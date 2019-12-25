//
//  GMMarqueeCardView.m
//  MBCoder
//
//  Created by Bowen on 2019/12/24.
//  Copyright © 2019 inke. All rights reserved.
//

#import "GMMarqueeCardView.h"
#import "Masonry.h"
#import <GPUImage.h>

@interface GMMarqueeCardView ()

@property (nonatomic, strong) UIImageView *backgroundView;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger hue;
@property (nonatomic, strong) GPUImageHSBFilter *filter;

@property (nonatomic, strong) GPUImagePicture *imageSource;

@end

@implementation GMMarqueeCardView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
        [self.timer fire];
    }
    return self;
}

- (void)setupView
{
    self.hue = -2;
    
    UIImage *image = [UIImage imageNamed:@"marquee_light_yellow_light"];

    self.filter = [[GPUImageHSBFilter alloc] init];
    [self.filter forceProcessingAtSize:image.size];
    
    self.imageSource = [[GPUImagePicture alloc] initWithImage:image];
    [self.imageSource addTarget:self.filter];
    
    [self addSubview:self.backgroundView];
    [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (void)startAnimation
{
    if (self.hue >= 360) {
        self.hue = -2;
    }
    
    self.hue += 30;
    
    [self.filter reset];
    [self.filter rotateHue:self.hue];
    [self.filter useNextFrameForImageCapture];
    
    [self.imageSource processImage];
    
    UIImage *newImage = [self.filter imageFromCurrentFramebuffer];
    
    CGFloat width = newImage.size.width/2.0 - 1.0;
    CGFloat height = newImage.size.height/2.0 - 1.0;
    newImage = [newImage resizableImageWithCapInsets:UIEdgeInsetsMake(height, width, height, width) resizingMode:UIImageResizingModeStretch];
    
    self.backgroundView.image = newImage;
}

- (UIImageView *)backgroundView {
    if(!_backgroundView){
        UIImage *image = [UIImage imageNamed:@"marquee_light_yellow_light"];
        CGFloat width = image.size.width/2.0 - 1.0;
        CGFloat height = image.size.height/2.0 - 1.0;
        image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(height, width, height, width) resizingMode:UIImageResizingModeStretch];
        _backgroundView = [[UIImageView alloc] init];
        _backgroundView.image = image;
    }
    return _backgroundView;
}

- (NSTimer *)timer {
    if(!_timer){
        _timer = [NSTimer timerWithTimeInterval:0.03 target:self selector:@selector(startAnimation) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
    }
    return _timer;
}


@end
