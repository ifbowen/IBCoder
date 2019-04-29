//
//  IBController35.m
//  IBCoder1
//
//  Created by Bowen on 2018/6/11.
//  Copyright © 2018年 BowenCoder. All rights reserved.
//

#import "IBController35.h"
#import "NSObject+Log.h"
#import "IBController2.h"

@interface IBController35 ()

@end

@implementation IBController35

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    Person *p = [[Person alloc] init];
    p.name = @"bowen";
    p.age = 26;
    p.sex = @"男";
    
    NSDictionary *dict = @{
                           @"姓名" : @"博文",
                           @"性别" : @"男",
                           @"年龄" : @(26),
                           @"obj" : @[p,p],
                           @"p"   : p,
                           @"null": [NSNull null],
                           @"info": @{@"addr":@"北京",@"other":@{@"addr":@"北京",@"other":@"student"}}
                           };
    NSLog(@"字典%@",dict.ib_description);
    NSLog(@"%@",dict);
    
    NSArray *arr = @[@"博文", @"你好",p,dict,@12];
    NSLog(@"数组%@",arr.ib_description);

}

@end
