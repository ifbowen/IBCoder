//
//  IBController5.m
//  IBCoder1
//
//  Created by Bowen on 2018/4/27.
//  Copyright © 2018年 BowenCoder. All rights reserved.
//

#import "IBController5.h"

@interface IBController5 ()

@property (nonatomic, copy) NSString *name1;
@property (nonatomic, copy) NSMutableString *name2;
@property (nonatomic, strong) NSString *name3; //内容可能被外界修改
@property (nonatomic, strong) NSMutableString *name4; //可能崩溃

@end

@implementation IBController5

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [self test1];
//    [self test2];
    [self test3];
}

- (void)test3 {
    //利用归档实现完全深拷贝
    NSMutableString *a = @"bowen1".mutableCopy;
    NSMutableString *b = @"bowen2".mutableCopy;
    NSMutableString *c = @"bowen3".mutableCopy;
    NSMutableString *d = @"bowen4".mutableCopy;
    NSArray *arr = @[a,b,c,d];
    NSArray *temp = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:arr]];
    [a appendString:@"1"];
    NSLog(@"%@",temp);
    
    //自定义对象（需要实现nscoding协议+归档）

}


- (void)test2 {
    //不走set方法，就不经过copy，所以还是可变的
    _name2 = @"bowen".mutableCopy;
    [_name2 appendString:@"1"];
    
    self.name2 = @"bowen".mutableCopy;
    [self.name2 appendString:@"2"];
}

- (void)test1 {
    
    NSString *temp = @"bowen";
    NSMutableString *str = @"wenzheng".mutableCopy;
    //浅拷贝(不可变=不可变）
    self.name1 = temp;
    NSLog(@"%p---%p",temp, self.name1);//指针复制
    
    //深拷贝(不可变 = 可变)
    self.name1 = str;
    NSLog(@"%p---%p",str, self.name1);//内存复制
    
    
    
    //浅拷贝（可变 = 不可变）
    self.name2 = temp;
    NSLog(@"%p---%p",temp, self.name2);
    
    //深拷贝(可变 = 可变)
    self.name2 = str;
    NSLog(@"%p---%p",str, self.name1);
    

    
    //浅拷贝（不可变 = 可变）(strong 会被外界修改)
    self.name3 = str;
    NSLog(@"%p---%p",str, self.name3);
    [str appendString:@"1"];
    NSLog(@"%@---%@",str, self.name3);
    
    //浅拷贝(可变 = 不可变)(strong 崩溃)
    self.name4 = temp;
    NSLog(@"%p---%p",temp, self.name4);
    
    [self.name4 appendString:@"2"];


    
}


@end
