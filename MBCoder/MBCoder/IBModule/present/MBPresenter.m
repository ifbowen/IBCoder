//
//  MBPresenter.m
//  MBCoder
//
//  Created by Bowen on 2019/11/14.
//  Copyright © 2019 inke. All rights reserved.
//

#import "MBPresenter.h"

@interface MBPresenter ()

@end

@implementation MBPresenter

+ (instancetype)setup:(id<MBPresenterControllerProtocol>)controller
{
    MBPresenter *present = [[self alloc] init];
    present.controller = controller;
    return present;
}

- (void)attachView:(id<MBPresenterViewProtocol>)view
{
    self.attachView = view;
    [self.attachView attachPresenter:self];
}

- (void)detachView
{
    self.attachView = nil;
}

@end
