//
//  VVStack.m
//  MBCoder
//
//  Created by Bowen on 2019/10/30.
//  Copyright © 2019 inke. All rights reserved.
//

#import "VVStack.h"

@interface VVStack()

@property (nonatomic, strong) NSMutableArray *numbers;

@end

@implementation VVStack

- (id)init {
    if (self = [super init]) {
        _numbers = [NSMutableArray new];
    }
    return self;
}

- (void)push:(double)num {
    [self.numbers addObject:@(num)];
}

- (double)pop {
    double result = [self top];
    [self.numbers removeLastObject];
    return result;
}

- (double)top {
    return [[self.numbers lastObject] doubleValue];
}

@end
