//
//  MBRetainCycleLoggerPlugin.m
//  MBCoder
//
//  Created by BowenCoder on 2020/3/9.
//  Copyright © 2020 inke. All rights reserved.
//

#import "MBRetainCycleLoggerPlugin.h"

@implementation MBRetainCycleLoggerPlugin

- (void)memoryProfilerDidFindRetainCycles:(NSSet *)retainCycles
{
  NSLog(@"#memory# %@", retainCycles);
}

- (void)memoryProfilerDidMarkNewGeneration
{
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

@end
