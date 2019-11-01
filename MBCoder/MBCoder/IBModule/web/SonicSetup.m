//
//  SonicSetup.m
//  MBCoder
//
//  Created by Bowen on 2019/11/1.
//  Copyright © 2019 inke. All rights reserved.
//

#import "SonicSetup.h"
#import <Sonic.h>
#import "SonicOfflineCacheConnection.h"
#import "SonicEventObserver.h"

@implementation SonicSetup

+ (void)setup
{
    //NSURLProtocol
    [NSURLProtocol registerClass:[SonicURLProtocol class]];
    
    //start web thread
    UIWebView *web = [[UIWebView alloc]initWithFrame:CGRectZero];
    [web loadHTMLString:@"" baseURL:nil];
    
    //Subclass the SonicConnection to return offline cache
    [SonicSession registerSonicConnection:[SonicOfflineCacheConnection class]];
    
    //add event observer
    SonicEventObserver *observer = [SonicEventObserver new];
    [[SonicEventStatistics shareStatistics] addEventObserver:observer];

}

@end
