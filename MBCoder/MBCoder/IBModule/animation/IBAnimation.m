//
//  IBAnimation.m
//  IBCoder1
//
//  Created by Bowen on 2018/6/29.
//  Copyright © 2018年 BowenCoder. All rights reserved.
//

#import "IBAnimation.h"

@implementation IBAnimation

@end


@interface UIViewAnimationContainer ()

@property (nonatomic) NSMutableArray *views;
@property (nonatomic) BOOL isOpened;
@property (nonatomic) UIView *viewOpened;

@end

@implementation UIViewAnimationContainer

- (instancetype)init {
    
    self = [super init];
    if (self) {
        self.isOpened = false;
        self.views = [[NSMutableArray alloc] init];
    }
    return self;
}
- (instancetype)initWithViews:(NSArray *)views {
    
    if (self = [self init]) {
        self.isOpened = false;
        self.views = [[NSMutableArray alloc] initWithArray:views];
        [self initViews];
    }
    return self;
}

- (void)setViews:(NSArray *)views {
    _views = [[NSMutableArray alloc] initWithArray:views];
    [self initViews];
}

- (void)addView:(UIView *)view {
    
    [self.views addObject:view];
    [self initListener:view];
}

- (void)initViews{
    
    for (UIView *view in self.views) {
        [self initListener:view];
    }
}

- (void)initListener:(UIView *)view{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchElement:)];
    [view addGestureRecognizer:tap];
}

- (void)touchElement:(UITapGestureRecognizer*)gesture{
    if(self.isOpened){
        [self closeThisView:gesture.view];
    }else{
        [self openThisView:gesture.view];
    }
}

- (void)openThisView:(UIView*)view {
    
    if(self.isOpened){
        [self closeThisView:self.viewOpened];
    }
    
    if([self.views containsObject:view]) {
        
        struct CGPoint origin = view.frame.origin;
        for(id item in self.views){
            
            UIView *viewItem = item;
            if (viewItem != view) {
                
                // Add Animation to UIView
                [viewItem explosition:origin distance:1024.0f duration:0.4f delay:0.0f];
                
            }else{
                [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionAllowUserInteraction
                                 animations:^{
                                     viewItem.frame = CGRectMake(0,0,768, 1004);
                                     
                                 } completion:nil];
            }
        }
        self.isOpened = true;
        self.viewOpened = view;
    }
}

- (void)closeThisView:(UIView *)view {
    
    if(view == self.viewOpened){
        int numberColumn = 0,numberRaw=0;
        for(id item in self.views){
            UIView *viewItem = item;
            [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionAllowUserInteraction
                             animations:^{
                                 viewItem.frame = CGRectMake(10 + numberColumn * 252, 10 + numberRaw * 248, 242, 238);
                                 
                             } completion:nil];
            numberColumn++;
            if (numberColumn > 2) {
                numberRaw++;
                numberColumn =0;
            }
        }
        self.isOpened = false;
    }
}

@end


@implementation UIView (Animation)

- (void)explosition:(CGPoint)origin distance:(float)distance duration:(float)duration delay:(float)delay {
    
    CGPoint final = [self finalPosition:self.frame.origin endPoint:origin distance:distance];
    
    [UIView animateWithDuration:duration delay:delay options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         self.frame = CGRectMake(final.x, final.y, self.frame.size.width, self.frame.size.height);
                     } completion:nil];
    
}

- (CGPoint)finalPosition:(CGPoint)startPoint endPoint:(CGPoint)endPoint distance:(float)distance {
    
    CGPoint origin  = CGPointMake(endPoint.x, endPoint.y);
    CGPoint start   = CGPointMake(startPoint.x, startPoint.y);
    
    float startDistance = sqrtf((start.x - origin.x)*(start.x - origin.x) + (start.y - origin.y)*(start.y - origin.y));
    float distanceX = (start.x - origin.x) * ( startDistance + distance ) / startDistance;
    float distanceY = (start.y - origin.y) * ( startDistance + distance ) / startDistance;
    
    float finalX;
    float finalY;
    
    if (origin.x == start.x && origin.y == start.y) {
        finalX = origin.x;
        finalY = origin.y;
    } else if (origin.x == start.x) {
        finalX = origin.x;
        finalY = origin.y + distanceY;
    } else if (origin.y == start.y){
        finalX = origin.x + distanceX;
        finalY = origin.y;
    } else {
        finalX = origin.x + distanceX;
        finalY = origin.y + distanceY;
    }
    
    CGPoint final = CGPointMake(finalX, finalY);
    
    return final;
}



@end

