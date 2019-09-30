//
//  main.m
//  MBCoder
//
//  Created by Bowen on 2019/9/30.
//  Copyright © 2019 inke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

CFAbsoluteTime StartTime;

int main(int argc, char * argv[]) {
    StartTime = CFAbsoluteTimeGetCurrent();
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
