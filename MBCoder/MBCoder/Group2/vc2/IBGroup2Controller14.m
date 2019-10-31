//
//  IBGroup2Controller14.m
//  MBCoder
//
//  Created by Bowen on 2019/10/30.
//  Copyright © 2019 inke. All rights reserved.
//

#import "IBGroup2Controller14.h"
#import "VVStack.h"

@interface IBGroup2Controller14 ()

@end

@implementation IBGroup2Controller14

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
}

/**
 一、Mock和Stub
 Mock
 关注行为验证。细粒度的测试，即代码的逻辑，多数情况下用于单元测试。
 mock 通常需要你事先设定期望。你告诉它你期望发生什么，然后执行测试代码并验证最后的结果与事先定义的期望是否一致。

 Stub
 关注状态验证。粗粒度的测试，在某个依赖系统不存在或者还没实现或者难以测试的情况下使用，例如访问文件系统，数据库连接，远程协议等。
 Stub能实现当特定的方法被调用时，返回一个指定的模拟值。如果你的测试用例需要一个伴生对象来提供一些数据，
 可以使用 stub 来取代数据源，在测试设置时可以指定返回每次一致的模拟数据。

 Stub和Mock的相同处
 stub和mock都是为了配合测试，对被测程序所依赖的单元的模拟。

 Stub和Mock的区别
 stub基于状态，mock基于行为
 stub难于维护
 mock有对本身的调用验证
 Stub是完全模拟一个外部依赖， 而Mock用来判断测试通过还是失败
 
 一、TDD
 测试驱动开发(Test Driven Development，以下简称TDD)是保证代码质量的不二法则，也是先进程序开发的共识。
 
 
 二、BDD
 而Kiwi是一个iOS平台十分好用的行为驱动开发(Behavior Driven Development，以下简称BDD)的测试框架，有着非常漂亮的语法，可以写出结构性强，非常容易读懂的测试。
 
 */

@end
