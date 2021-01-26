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
//    [self test0];
//    [self test1];
//    [self test2];
//    [self test3];
    [self test3_1];
}


/**
 指针的三个容易弄混淆的概念
 指针地址：指针自身的地址，即内存中用于存放指针变量的内存地址
 指针保存的地址：指针所保存的变量在内存中的地址，通俗讲就是指针所指向的对象的内存地址
 指针所保存的地址的值：指针所指对象的数值。
 
 指针混淆
 指针是一个变量，只是指向了其他变量的地址
 数组是是多个元素的集合，在内存中分布在地址相连的单元中，所以可以通过其下标访问不同单元的元素。
 它的数组名可以相当一个指针,代表数组的首地址；
 
 最主要的原因是它们都可以以指针形式和以数组下标形式这两种形式去访问。
 
 常量指针和指针常量区别：
 1、本质
 指针常量：本质上一个常量，指针用来说明常量的类型，表示该常量是一个指针类型的常量。
 常量指针：本质上是一个指针，常量表示指针指向的内容，说明该指针指向一个“常量”。

 2、地址
 指针常量：在指针常量中，指针自身的值是一个常量，不可改变，始终指向同一个地址。在定义的同时必须初始化。
 常量指针：指针可以指向其他地址

 3、内容
 指针常量：指向的内容可以修改
 常量指针：在常量指针中，指针指向的内容是不可改变的，指针看起来好像指向了一个常量。
 
 
 
 */
- (void)test4
{
    int m = 10;
    const int n =20;
    
    int const *ptr1 = &m; // 指向的内容不能改变
    int * const ptr2 = &m; // 指针不能指向其他地方
    
    ptr1 = &n;  // 正确
//    ptr2 = &n; // 错误
    
//    *ptr1 = 3; // 错误
    *ptr2 = 3; // 正确
    
}

- (void)test3_1 {
    NSMutableString *str1 = @"1".mutableCopy;
    
    NSMutableArray *arr1 = @[str1, @[str1]].mutableCopy;
    
    // 一层深拷贝
    NSMutableArray *arr2 = [[NSMutableArray alloc] initWithArray:arr1 copyItems:YES];
    
    NSMutableString *str2 = [arr1 objectAtIndex:0];
    [str2 appendString:@"1"];
    
    NSLog(@"arr2--%@", arr2);

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

- (void)test0 {
    
    //原则，修改新旧对象，不影响旧新对象
    
    NSArray *arr1 = @[@1, @2, @3];
    NSArray *logArr1 = [arr1 copy];
    NSArray *logArr2 = [arr1 mutableCopy];
    NSLog(@"%p--%p--%p", arr1, logArr1, logArr2);
    NSLog(@"123");
    
    NSMutableArray *muArr1 = [NSMutableArray arrayWithObjects:@1,@2,@3, nil];
    NSMutableArray *logMuArr1 = [muArr1 mutableCopy];
    NSMutableArray *logMuarr2 = [muArr1 copy];
    NSLog(@"%p--%p--%p", muArr1, logMuArr1, logMuarr2);
    [logMuarr2 addObject:@4];
    NSLog(@"123");
    
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
