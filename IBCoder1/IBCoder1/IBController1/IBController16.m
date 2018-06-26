//
//  IBController16.m
//  IBCoder1
//
//  Created by Bowen on 2018/5/9.
//  Copyright © 2018年 BowenCoder. All rights reserved.
//

#import "IBController16.h"
#import "Son.h"

@interface IBKVOExp : NSObject

@property (nonatomic, copy) NSString *name;

@end

@implementation IBKVOExp

@end

@interface IBController16 ()

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) IBKVOExp *kvoExp;

@end

/*
 https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/KeyValueObserving/Articles/KVOImplementation.html
 一、KVO底层实现原理
 1、KVO是基于runtime机制实现的
 2、当某个类的属性对象第一次被观察时，系统就会在运行期动态地创建该类的一个派生类，在这个派生类中重写基类中任何被观察属性的setter 方法。派生类在被重写的setter方法内实现真正的通知机制
 3、如果原类为Person，那么生成的派生类名为NSKVONotifying_Person（不过现在打印不显示派生类了）
 4、每个类对象中都有一个isa指针指向当前类，当一个类对象的第一次被观察，那么系统会偷偷将isa指针指向动态生成的派生类，从而在给被监控属性赋值时执行的是派生类的setter方法
 5、键值观察通知依赖于NSObject 的两个方法: willChangeValueForKey: 和 didChangevlueForKey:；在一个被观察属性发生改变之前， willChangeValueForKey:一定会被调用，这就 会记录旧的值。而当改变发生后，didChangeValueForKey:会被调用，继而 observeValueForKey:ofObject:change:context: 也会被调用。
 6、补充：KVO的这套实现机制中苹果还偷偷重写了class方法，让我们误认为还是使用的当前类，从而达到隐藏生成的派生类
 
 二、KVC底层实现原理
 KVC运用了一个isa-swizzling技术. isa-swizzling就是类型混合指针机制, 将2个对象的isa指针互相调换, 就是俗称的黑魔法.
 KVC主要通过isa-swizzling, 来实现其内部查找定位的. 默认的实现方法由NSOject提供isa指针, 如其名称所指,(就是is a kind of的意思), 指向分发表对象的类. 该分发表实际上包含了指向实现类中的方法的指针, 和其它数据。
 
 具体主要分为三大步
 当一个对象调用setValue方法时，方法内部会做以下操作：
 1). 检查是否存在相应的key的set方法，如果存在，就调用set方法。
 2). 如果set方法不存在，就会查找与key相同名称并且带下划线的成员变量，如果有，则直接给成员变量属性赋值。
 3). 如果没有找到_key，就会查找相同名称的属性key，如果有就直接赋值。
 4). 如果还没有找到，则调用valueForUndefinedKey:和setValue:forUndefinedKey:方法。
 这些方法的默认实现都是抛出异常，我们可以根据需要重写它们。
 
 KVC:设置不了类型为指针类型的成员变量
 
 */

@implementation IBController16

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew context:nil];
    self.kvoExp = [[IBKVOExp alloc] init];
    [self.kvoExp addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew context:nil];
    self.kvoExp.name = @"123";
    
    Son *son = [[Son alloc] init];
    [son setValue:@"xiaolan" forKey:@"_girlfriend"];
//    [son setValue:@(2) forKey:@"_parents"];

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.name = @"456";
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    NSLog(@"%@",object);
}

- (void)dealloc
{
    [self.kvoExp removeObserver:self forKeyPath:@"name"];
    [self removeObserver:self forKeyPath:@"name"];
}


@end
