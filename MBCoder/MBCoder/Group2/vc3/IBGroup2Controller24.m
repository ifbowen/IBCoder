//
//  IBGroup2Controller24.m
//  MBCoder
//
//  Created by BowenCoder on 2020/2/19.
//  Copyright © 2020 inke. All rights reserved.
//

#import "IBGroup2Controller24.h"

@interface IBGroup2Controller24 ()

@end

@implementation IBGroup2Controller24

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

/*
 一、系统的优化
 1、__builtin_expect(EXP, N)的作用[意思是：EXP==N的概率很大]
 帮助程序处理分支预测，达到优化程序。
 a、处理器一般采用流水线模式，有些里面有多个逻辑运算单元，系统可以提前取多条指令进行并行处理，
    但遇到跳转时，则需要重新取指令，这相对于不用重新去指令就降低了速度。
 b、作用优化分支（比如if）处理。
 
 例子：
 if (__builtin_expect(x, 0)) {
    return 1;
 } else {
    return 2;
 }
 
 x的期望值为0，也就是x有很大概率为0， 所以走if分支的可能性较小，所以编译会这样编译
 
 if (!x) {
    return 2;
 } else {
    return 1;
 }
 
 每次cpu都能大概率的执行到预取的编译后的if分支，从而提高了分支的预测准确性，从而提高了cpu指令的执行速度
 
 2、总结：
 likely(x)也叫fastpath __builtin_expect(!!(x), 1) 该条件多数情况下会发生
 unlikely(x)也叫slowpath  __builtin_expect(!!(x), 0) 该条件下极少发生
 
*/

@end
