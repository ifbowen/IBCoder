//
//  IBController17.m
//  IBCoder1
//
//  Created by Bowen on 2018/5/9.
//  Copyright © 2018年 BowenCoder. All rights reserved.
//

#import "IBController17.h"

@interface IBController17 ()

@end

@implementation IBController17

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    NSLog(@"%ld", [IBController17 getCurrentTimepp]);
    NSLog(@"%@", [IBController17 timestampSwitchTime:[IBController17 getCurrentTimepp] /1000 andFormatter:@"YYYY-MM-dd HH:mm:ss"]);
}


//时间戳转换成时间（10位时间戳）
+(NSString *)timestampSwitchTime:(NSInteger)timestamp andFormatter:(NSString *)format{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:format]; // （@"YYYY-MM-dd hh:mm:ss"）----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:timestamp];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    
    return confromTimespStr;
}


//获取当前的时间戳
+(long)getCurrentTimepp{
    //日期格式
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    //当前日期
    NSDate *datenow = [NSDate date];
    //时间戳
    long timespp = [datenow timeIntervalSince1970]*(1000);
    
    //    //时间字符串
    //    NSString *currentTimeString = [formatter stringFromDate:datenow];
    
    return timespp;
    
}

@end
