//
//  MBMemoryProfiler.m
//  MBCoder
//
//  Created by BowenCoder on 2020/3/9.
//  Copyright © 2020 inke. All rights reserved.
//

#import "MBMemoryProfiler.h"
#import "MBRetainCycleLoggerPlugin.h"
#import <FBAllocationTracker/FBAllocationTracker.h>
#import <FBRetainCycleDetector/FBRetainCycleDetector.h>

@interface MBMemoryProfiler ()

@property (nonatomic, strong) FBMemoryProfiler *memoryProfiler;

@end

@implementation MBMemoryProfiler

+ (instancetype)profiler
{
    static MBMemoryProfiler *profiler = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        profiler = [[MBMemoryProfiler alloc] init];
    });
    
    return profiler;
}

- (void)setup
{
    [FBAssociationManager hook];
    [[FBAllocationTrackerManager sharedManager] startTrackingAllocations];
    [[FBAllocationTrackerManager sharedManager] enableGenerations];

    self.memoryProfiler = [[FBMemoryProfiler alloc] initWithPlugins:@[[MBRetainCycleLoggerPlugin new]]
                                    retainCycleDetectorConfiguration:nil];
    [self.memoryProfiler enable];
}

@end
