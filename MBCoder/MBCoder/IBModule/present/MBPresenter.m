//
//  MBPresenter.m
//  MBCoder
//
//  Created by Bowen on 2019/11/14.
//  Copyright © 2019 inke. All rights reserved.
//

#import "MBPresenter.h"

@implementation MBPresenter

+ (instancetype)setup:(id<MBPresenterProtocol>)view
{
    MBPresenter *present = [[self alloc] init];
    present.attachView = view;
    [view attachPresenter:present];
    return present;
}

- (void)attachView:(id)view
{
    self.attachView = view;
}

- (void)detachView
{
    self.attachView = nil;
}

@end
