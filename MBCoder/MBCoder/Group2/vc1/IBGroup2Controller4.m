//
//  IBGroup2Controller4.m
//  IBCoder1
//
//  Created by Bowen on 2019/5/28.
//  Copyright © 2019 BowenCoder. All rights reserved.
//

#import "IBGroup2Controller4.h"

ADT(Color,
    constructor(Red),
    constructor(Green),
    constructor(Blue),
    constructor(Gray, double alpha),
    constructor(Other, double r, double g, double b),
    constructor(Named, __unsafe_unretained NSString *name)
    );

ADT(Multicolor,
    constructor(OneColor, const ColorT c),
    constructor(TwoColor, const ColorT first, const ColorT second),
    constructor(RecursiveColor, const MulticolorT *mc)
    );

@interface IBGroup2Controller4 ()

@end

@implementation IBGroup2Controller4


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.redColor;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    [self test1];
//    [self test2];
//    [self test3];
//    [self test4];
//    [self test5];
    [self test6];
//    [self test7];
//    [self test8];
    
}

// 抽象数据类型、Protocol
- (void)test1
{
    ColorT c = Color.Named(@"foobar");
    NSLog(@"%@", c.name);
    MulticolorT mc = Multicolor.TwoColor(Color.Named(@"nav"), Color.Other(0.25, 0.5, 0.75));
    NSLog(@"%@", mc.first.name);
    
    // Protocol
    [self eat];
    
}

/* keypath */
- (void)test2
{
    NSURL *URL = [NSURL URLWithString:@"http://www.google.com:8080/search?q=foo"];
    NSString * _Nonnull path1 = @keypath(URL.port);
    NSLog(@"%@", path1);
    
    NSString * _Nonnull path2 = @keypath(URL.port.stringValue);
    NSLog(@"%@", path2);
    
    NSString * _Nonnull path3 = @keypath(NSString.class.description);
    NSLog(@"%@", path3);
    
    NSString * _Nonnull path4 = @keypath(UIViewController.new, view);
    NSLog(@"%@", path4);
    
    NSString * _Nonnull path5 = @collectionKeypath(UIViewController.new, view, UIViewController.new, viewLoaded);
    NSLog(@"%@", path5);
    
    __unused NSString * _Nonnull path6 = @keypath(UIViewController.new, parentViewController);
    NSLog(@"%@", path6);

    
}

/* EXTNil */
- (void)test3
{
    id obj = [EXTNil null];
    [obj setValue:@"foo" forKey:@"bar"];
    NSDictionary *values = [obj dictionaryWithValuesForKeys:@[@"bar"]];
    NSLog(@"%@", values);
}

- (void)test4
{
    objc_property_t property = class_getProperty([IBGroup2Controller4 class], "viewLoaded");
    NSLog(@"property attributes: %s", property_getAttributes(property));
    ext_propertyAttributes *attributes = ext_copyPropertyAttributes(property);
    NSLog(@"%s--%d", attributes->getter, attributes->readonly);
}


- (void)test5
{
    [self sleep];
}

- (void)test6
{
    NSMutableString *str = [@"foo" mutableCopy];
    
    {
        @onExit { // 作用域结束清理
            [str appendString:@"bar"];
        };
        NSLog(@"%@", str);
    }
    NSLog(@"%@", str);
    @weakify(self);
    ^{
        @strongify(self);
        NSLog(@"%@", self);
    }();
}

- (void)test7
{
    NSString *str = @"foobar";
    if (@checkselector0(str, length)) {
        NSLog(@"test1");
    }
    
    
    if (@checkselector([NSURL class], URLWithString:)) {
        NSLog(@"test2");
    }
}

- (void)test8
{
    self.testNonatomicRetainProperty = @"123";
    NSLog(@"%@",self.testNonatomicRetainProperty);
}



@end

@implementation IBGroup2Controller4 (ext1)
@synthesizeAssociation(IBGroup2Controller4, testNonatomicRetainProperty);

@end
