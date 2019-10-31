//
//  SimpleStringSpec.m
//  MBCoder
//
//  Created by Bowen on 2019/10/31.
//  Copyright 2019 inke. All rights reserved.
//

#import <Kiwi/Kiwi.h>

SPEC_BEGIN(SimpleStringSpec)

describe(@"SimpleString", ^{
    context(@"when assigned to 'Hello world'", ^{
        NSString *greeting = @"Hello world";
        it(@"should exist", ^{
            [[greeting shouldNot] beNil];
        });

        it(@"should equal to 'Hello world'", ^{
            [[greeting should] equal:@"Hello world"];
        });
    });
});

SPEC_END


/**
 
 一个典型的BDD的测试用例包活完整的三段式上下文，测试大多可以翻译为Given..When..Then的格式
 
 行为描述（Specs）和期望（Expectations），Kiwi测试的基本结构
 
 describe描述需要测试的对象内容
 context描述测试上下文，也就是这个测试在When来进行
 it中的是测试的本体，描述了这个测试应该满足的条件
 
 一个describe可以包含多个context，来描述类在不同情景下的行为；
 一个context可以包含多个it的测试例
 
 
 Kiwi还有一些其他的行为描述关键字，其中比较重要的包括

 beforeAll(aBlock) - 当前scope内部的所有的其他block运行之前调用一次
 afterAll(aBlock) - 当前scope内部的所有的其他block运行之后调用一次
 beforeEach(aBlock) - 在scope内的每个it之前调用一次，对于context的配置代码应该写在这里
 afterEach(aBlock) - 在scope内的每个it之后调用一次，用于清理测试后的代码
 specify(aBlock) - 可以在里面直接书写不需要描述的测试
 pending(aString, aBlock) - 只打印一条log信息，不做测试。这个语句会给出一条警告，可以作为一开始集中书写行为描述时还未实现的测试的提示。
 xit(aString, aBlock) - 和pending一样，另一种写法。因为在真正实现时测试时只需要将x删掉就是it，但是pending语意更明确，因此还是推荐pending
 更多的：https://github.com/kiwi-bdd/Kiwi/wiki
 
 在Kiwi中期望都由should或者shouldNot开头
 
 Kiwi为我们提供了一个标量转对象的语法糖，叫做theValue
 
 */
