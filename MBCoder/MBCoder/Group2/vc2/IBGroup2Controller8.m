//
//  IBGroup2Controller8.m
//  IBCoder1
//
//  Created by Bowen on 2019/9/24.
//  Copyright © 2019 BowenCoder. All rights reserved.
//

#import "IBGroup2Controller8.h"

@interface IBGroup2Controller8 ()

@end

@implementation IBGroup2Controller8

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    
    NSString *html = @"{\"71.40\":71.40,\"8.37\":8.37,\"80.40\":80.40,\"188.40\":188.40}";
    NSData *jsonData_ = [html dataUsingEncoding:NSUTF8StringEncoding];
    NSError *jsonParsingError_ = nil;
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[NSJSONSerialization JSONObjectWithData:jsonData_ options:0 error:&jsonParsingError_]];
    NSLog(@"dic:%@", dic);
    NSLog(@"dic:%@", [self cc_correctDecimalLoss:dic]);
    
    NSDecimalNumber *dnumber = [[NSDecimalNumber alloc] initWithFloat:8.9];
    double dfNumber = dnumber.doubleValue; // 打断点看f的值
    NSLog(@"NSDecimalNumber: %lf", dfNumber);
    
    NSNumber *number = @7.9;
    double fNumber = number.doubleValue; // 打断点看f的值，不是精确的7.9
    NSLog(@"NSNumber: %lf", fNumber);
    
    double ceshi = 6.9;

    NSString *numStr = @"5.9";
    float fStr = numStr.floatValue;
    NSLog(@"NSString: %lf", fStr);
    NSLog(@"=============================");
}

/*
 原因：
 https://blog.csdn.net/jye13/article/details/8190321
 代码之谜（五）- 浮点数（谁偷了你的精度？）
 */

#pragma mark correct decimal number

- (NSMutableDictionary *)cc_correctDecimalLoss:(NSMutableDictionary *)dic{
    if (dic) {
        return [self parseDic:dic];
    }
    return nil;
}

- (NSMutableDictionary *)parseDic:(NSMutableDictionary *)dic{
    NSArray *allKeys = [dic allKeys];
    for (int i=0; i<allKeys.count; i++) {
        NSString *key = allKeys[i];
        id v = dic[key];
        if ([v isKindOfClass:[NSDictionary class]]){
            NSMutableDictionary *mutDic = [NSMutableDictionary dictionaryWithDictionary:v];
            [dic setObject:[self parseDic:mutDic] forKey:key];
        } else if ([v isKindOfClass:[NSArray class]]){
            NSMutableArray *mutArr = [NSMutableArray arrayWithArray:v];
            [dic setObject:[self parseArr:mutArr] forKey:key];
        } else if ([v isKindOfClass:[NSNumber class]]){
            [dic setObject:[self parseNumber:v] forKey:key];
        }
    }
    return dic;
}

- (NSMutableArray *)parseArr:(NSMutableArray *)arr{
    for (int i=0; i<arr.count; i++) {
        id v = arr[i];
        if ([v isKindOfClass:[NSDictionary class]]){
            NSMutableDictionary *mutDic = [NSMutableDictionary dictionaryWithDictionary:v];
            [arr replaceObjectAtIndex:i withObject:[self parseDic:mutDic]];
        }else if ([v isKindOfClass:[NSArray class]]){
            NSMutableArray *mutArr = [NSMutableArray arrayWithArray:v];
            [arr replaceObjectAtIndex:i withObject:[self parseArr:mutArr]];
        }else if ([v isKindOfClass:[NSNumber class]]){
            [arr replaceObjectAtIndex:i withObject:[self parseNumber:v]];
        }
    }
    return arr;
}

- (NSDecimalNumber *)parseNumber:(NSNumber *)number{
    //直接传入精度丢失有问题的Double类型
    double conversionValue = [number doubleValue];
    NSString *doubleString = [NSString stringWithFormat:@"%lf", conversionValue];
    NSDecimalNumber *decimalNumber = [NSDecimalNumber decimalNumberWithString:doubleString];
    return decimalNumber;
}

@end
