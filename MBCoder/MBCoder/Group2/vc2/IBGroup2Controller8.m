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
    
    // 在计算机中绝对值等于自己的数有两个，0 和最小的负数。
    // x的绝对值定义为：正数和0的绝对值等于它自己，负数的绝对值等于-x
    // 学过计算机原理的都知道，负数在计算机中以补码形式存储，计算补码的方式和取反操作类似。
    // 符号位不变，其它位取反，最后加一。
    
    long num = -pow(2, 63);
    
    long num1 = labs(num);
    
    NSLog(@"%ld", num1);
}

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

/*
 一、计算机不能精确表达浮点数
 
 1、原因：
 a、在十进制转二进制的过程中丢失精度，不能整除
 b、浮点数参与计算时，浮点数参与计算时，有一个步骤叫对阶，以加法为例，要把小的指数域转化为大的指数域，也就是左移小指数浮点数的小数点，
   一旦小数点左移，必然会把52位有效域的最右边的位给挤出去，这个时候挤出去的部分也会发生“舍入”。这就又会发生一次精度丢失。
 
 总结、在计算机中，浮点数没有办法精确表示的根本原因在于计算机有限的内存无法表示无限的小数位。只能截断，截断就造精度的缺失。
 
 二、浮点数的表示方法
 1、国际标准IEEE754形式：V =  pow(-1, S) * M * pow(2, E);
 a、pow(-1, S) 表示符号位，当s=0，V为正数；s=1，V为负数；
 b、M 表示有效数字，1≤M<2；
 c、2^E 表示指数位
 
 2、IEEE754规定，浮点数分单精度双精度之分：
 32位的单精度浮点数，最高1位是符号位s，接着的8位是指数E，剩下的23位是有效数字M
 64位的双精度浮点数，最高1位是符号位s，接着的11位是指数E，剩下的52位为有效数字M

 3、IEEE754规定，有效数字M和指数E
 有效数字M
 （1）1≤M<2，也即M可以写成1.xxxxx的形式，其中xxxxx表小数部分
 （2）计算机内部保存M时，默认这个数第一位总是1，所以舍去。只保存后面的xxxxx部分，节省一位有效数字
 指数E（阶码）
 （1）E为无符号整数。E为8位，范围是0～255；E为11位，范围是0～2047
 （2）因为科学计数法中的E是可以出现负数的，所以IEEE 754规定E的真实值必须再减去一个中间数（偏移值），127或1023
 
 4、浮点数加法
 浮点数的加法运算（不要问哥为啥只讲加法～）分为下面几个步骤：
 
 1）对阶
 顾名思义就是对齐阶码，使两数的小数点位置对齐，小阶向大阶对齐；
 2）尾数求和
 对阶完对尾数求和
（3）规格化
 尾数必须规格化成1.M的形式
（4）舍入
 在规格化时会损失精度，所以用舍入来提高精度，常用的有0舍1入法，置1法
（5）校验判断
 最后一步是校验结果是否溢出。若阶码上溢则置为溢出，下溢则置为机器零
 
 5、非规格化浮点和规格浮点
 规格浮点约定小数点前一位默认是1。
 非规格浮点约定小数点前一位可以为0，这样小数精度就相当于多了最多2^22范围
 但是，精度的提升是有代价的。由于CPU硬件只支持，或者默认对一个32bit的二进制使用规格化解码。
 因此需要支持32bit非规格数值的转码和计算的话，需要额外的编码标识，也就是需要额外的硬件或者软件层面的支持。
 以下是wiki上的两端摘抄，说明了非规格化计算的效率非常低。一般来说，由软件对非规格化浮点数进行处理将带来极大的性能损失，
 而由硬件处理的情况会稍好一些，但在多数现代处理器上这样的操作仍是缓慢的。极端情况下，规格化浮点数操作可能比硬件支持的非规格化浮点数操作快100倍。
 
 
 注意：计算器采用了一种叫做定点数的数据类型，但是表示范围有限


*/
