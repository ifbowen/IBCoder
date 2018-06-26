//
//  IBController32.m
//  IBCoder1
//
//  Created by Bowen on 2018/6/1.
//  Copyright © 2018年 BowenCoder. All rights reserved.
//

#import "IBController32.h"
#import "GCDQueue.h"

@interface IBController32 ()

@end

@implementation IBController32

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关联属性";
    self.view.backgroundColor = [UIColor whiteColor];
//    连接：https://draveness.me/ao
    
}


/*
 
 参考：https://blog.csdn.net/zyx196/article/details/50816976
 extension看起来很像一个匿名的category，但是extension和有名字的category几乎完全是两个东西。 extension在编译期决议，它就是类的一部分，在编译期和头文件里的@interface以及实现文件里的@implement一起形成一个完整的类，它伴随类的产生而产生，亦随之一起消亡。extension一般用来隐藏类的私有信息，你必须有一个类的源码才能为一个类添加extension，所以你无法为系统的类比如NSString添加extension。
 
 但是category则完全不一样，它是在运行期决议的。
 就category和extension的区别来看，我们可以推导出一个明显的事实，extension可以添加实例变量，而category是无法添加实例变量的（因为在运行期，对象的内存布局已经确定，如果添加实例变量就会破坏类的内部布局，这对编译型语言来说是灾难性的）。
 
 需要注意的有两点：
 1)、category的方法没有“完全替换掉”原来类已经有的方法，也就是说如果category和原来类都有methodA，那么category附加完成之后，类的方法列表里会有两个methodA
 2)、category的方法被放到了新方法列表的前面，而原来类的方法被放到了新方法列表的后面，这也就是我们平常所说的category的方法会“覆盖”掉原来类的同名方法，这是因为运行时在查找方法的时候是顺着方法列表的顺序查找的，它只要一找到对应名字的方法，就会罢休^_^，殊不知后面可能还有一样名字的方法。
 3)、这两个方法的先后顺序取决于compile sources中文件的先后顺序
 */



@end
