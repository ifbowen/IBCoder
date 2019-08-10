//
//  IBGroup2Controller5.m
//  IBCoder1
//
//  Created by Bowen on 2019/8/10.
//  Copyright © 2019 BowenCoder. All rights reserved.
//

#import "IBGroup2Controller5.h"

@interface IBGroup2Controller5 ()

@end

@implementation IBGroup2Controller5

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

/*
 一、图片解压缩
 1、图片加载的工作流
 概括来说，从磁盘中加载一张图片，并将它显示到屏幕上，中间的主要工作流如下：
 
 1）使用 +imageWithContentsOfFile: 方法从磁盘中加载一张图片，这个时候的图片并没有解压缩；
 2）将生成的 UIImage 赋值给 UIImageView ；
 3）隐式的 CATransaction 捕获到了 UIImageView 图层树的变化；
 4）在主线程的下一个 run loop 到来时，Core Animation 提交了这个隐式的 transaction ，这个过程可能
    会对图片进行 copy 操作，而受图片是否字节对齐等因素的影响，这个 copy 操作可能会涉及以下部分或全部步骤：
    a、分配内存缓冲区用于管理文件 IO 和解压缩操作；
    b、将文件数据从磁盘读到内存中；
    c、将压缩的图片数据解码成未压缩的位图形式，这是一个非常耗时的 CPU 操作；
    d、最后 Core Animation 使用未压缩的位图数据渲染 UIImageView 的图层。
 
 2、为什么需要解压缩
 位图就是一个像素数组，数组中的每个像素就代表着图片中的一个点，JPEG 和 PNG 图片，都是一种压缩的位图图形格式。
 
 假如一张图片像素为：30*30
 解压缩后的图片大小 = 图片的像素宽30 * 图片的像素高30 * 每个像素所占的字节数 4
 
 
 
 
 */

@end
