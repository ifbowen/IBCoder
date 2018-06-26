//
//  IBController37.m
//  IBCoder1
//
//  Created by Bowen on 2018/6/20.
//  Copyright © 2018年 BowenCoder. All rights reserved.
//

#import "IBController37.h"
#import "AFHTTPSessionManager+RACSupport.h"

@interface IBController37 ()

@end

@implementation IBController37

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self test1];
}


- (void)test1 {
    NSURL *url;
    NSString *path=@"https://api.ishowchina.com/v3/search/poi?region=%E5%8C%97%E4%BA%AC&page_num=2&datasource=poi&scope=2&query=%E7%9A%87%E5%86%A0%E5%81%87%E6%97%A5%E9%85%92%E5%BA%97&type=%E9%85%92%E5%BA%97&page_size=3&ts=1514358214000&scode=775a26c87455fa2adbcd4c39336e19f9&ak=ba3b7217a815b3acd6fd7b525f698be0";
    NSDictionary *params;
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]
                                     initWithBaseURL:url];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/javascript",@"text/plain", nil];
    
    [[manager rac_POST:path parameters:params] subscribeNext:^(RACTuple *JSONAndHeaders) {
        //Voila, a tuple with (JSON, HTTPResponse)
        NSLog(@"%@",JSONAndHeaders);
    } error:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
}

@end
