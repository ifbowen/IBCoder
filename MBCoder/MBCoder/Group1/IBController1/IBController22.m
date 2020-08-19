//
//  IBController22.m
//  IBCoder1
//
//  Created by Bowen on 2018/5/17.
//  Copyright © 2018年 BowenCoder. All rights reserved.
//

#import "IBController22.h"
#import "Son.h"

/*
 最常见的多项式时间算法复杂度关系为：
 O(1) < O(logn) < O(n) < O(nlogn) < O(n2) < O(n3)
 
 时间复杂度：
 一般情况下，算法中<基本操作重复执行的次数>是问题规模n的某个函数f(n)，进而分析f(n)随n的变化情况并确定T(n)的数量级。这里用"O"来表示数量级，给
 出算法的时间复杂度。
 T(n)=O(f(n));
 它表示随着问题规模的n的增大，算法的执行时间的增长率和f(n)的增长率相同，这称作算法的渐进时间复杂度，简称时间复杂度。而我们一般讨论的是最坏时间复
 杂度，这样做的原因是：最坏情况下的时间复杂度是算法在任何输入实例上运行时间的上界，分析最坏的情况以估算算法指向时间的一个上界。
 
 时间复杂度的分析方法：
 1、时间复杂度就是函数中基本操作所执行的次数,这里的函数是指数学里面的函数，而不是C语法里的函数
 2、一般默认的是最坏时间复杂度，即分析最坏情况下所能执行的次数
 3、忽略掉常数项
 4、关注运行时间的增长趋势，关注函数式中增长最快的表达式，忽略系数
 5、计算时间复杂度是估算随着n的增长函数执行次数的增长趋势
 6、递归算法的时间复杂度为：递归总次数 * 每次递归中基本操作所执行的次数
 
 空间复杂度：
 算法的空间复杂度并不是计算实际占用的空间，而是<计算整个算法的辅助空间单元的个数>，与问题的规模没有关系。算法的空间复杂度S(n)定义为该算法所耗费
 空间的数量级。
 S(n)=O(f(n))
 若算法执行时所需要的辅助空间相对于输入数据量n而言是一个常数，则称这个算法的辅助空间为O(1);
 递归算法的空间复杂度：递归深度N*每次递归所要的辅助空间， 如果每次递归所需的辅助空间是常数，则递归的空间复杂度是 O(N).
 
 是对一个算法在运行过程中临时占用存储空间大小的量度，记做S(n)=O(f(n))。比如直接插入排序的时间复杂度是O(n^2),空间复杂度是O(1) 。而一般的递归
 算法就要有O(n)的空间复杂度了，因为每次递归都要存储返回信息。一个算法的优劣主要从算法的执行时间和所需要占用的存储空间两个方面衡量。
 */

@interface IBController22 ()

@end

@implementation IBController22

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    NSLog(@"二分查找:%ld",[self binarySearch:@[@1,@2,@3,@4,@5] value:5 startIndex:0 endIndex:4]);
//    int arr[] = {1,4,2,0,3,7,2,6,8,5};
//    bublleSort(arr, 5);
//    insertionSort(arr, 5);
    
    int a[10] = {3,1,5,7,2,4,9,6,10,8};
    quickSort(a,0,9);
    NSLog(@"haha");
}

//https://www.cnblogs.com/onepixel/articles/7674659.html

/**
 插入排序（从未排序的数组中选择第一个和已排序的从后往前比较）
 从第一个元素开始，该元素可以认为已经被排序；
 取出下一个元素，在已经排序的元素序列中从当前位置向前扫描；
 如果该元素（已排序）大于新元素，将该元素移到下一位置；
 重复步骤3，直到找到已排序的元素小于或者等于新元素的位置；
 将新元素插入到该位置后；
 重复步骤2~5。
 */
void insertionSort(int *arr, int length) {
    int preIndex, current;
    for (int i = 1; i < length; i++) {
        preIndex = i - 1;
        current = arr[i];
        while (arr[preIndex] > current) {
            arr[preIndex + 1] = arr[preIndex]; //元素一直往后去
            preIndex--;
        }
        arr[preIndex + 1] = current;
    }
}

//冒泡
void bublleSort(int *arr, int length) {
    for(int i = 0; i < length - 1; i++) { //趟数
        for(int j = 0; j < length - i - 1; j++) { //比较次数
            if(arr[j] > arr[j+1]) {
                int temp = arr[j];
                arr[j] = arr[j+1];
                arr[j+1] = temp;
            }
        }
    }
}

/*
 找到最小索引然后交换位置
    首先在未排序序列中找到最小（大）元素，存放到排序序列的起始位置，然后，再从剩余未排序元素中继续寻找最小（大）元素，然后放到
 已排序序列的末尾。以此类推，直到所有元素均排序完毕。
 */
void selectSort(int *arr, int length) {
    for (int i = 0; i < length - 1; i++) { //趟数
        for (int j = i + 1; j < length; j++) { //比较次数
            if (arr[i] > arr[j]) {
                int temp = arr[i];
                arr[i] = arr[j];
                arr[j] = temp;
            }
        }
    }
}

void swap(int *a, int *b)
{
    int tmp = *a;
    *a = *b;
    *b = tmp;
}

int partition(int a[], int low, int high)
{
    int privotKey = a[low];                                //基准元素
    while(low < high){                                    //从表的两端交替地向中间扫描
        while(low < high  && a[high] >= privotKey) --high;  //从high 所指位置向前搜索，至多到low+1 位置。将比基准元素小的交换到低端
        swap(&a[low], &a[high]);
        while(low < high  && a[low] <= privotKey ) ++low;
        swap(&a[low], &a[high]);
    }
    return low;
}


/**
 快速排序的基本思想：通过一趟排序将待排记录分隔成独立的两部分，其中一部分记录的关键字均比另一部分的关键字小，则可分别对这两部分记录继续进行排序，
                 以达到整个序列有序。
 
 
 快速排序使用分治法来把一个串（list）分为两个子串（sub-lists）。具体算法描述如下：
 1)从数列中挑出一个元素，称为 “基准”（pivot）；
 2)重新排序数列，所有元素比基准值小的摆放在基准前面，所有元素比基准值大的摆在基准的后面（相同的数可以到任一边）。在这个分区退出之后，该基准就处于数
   列的中间位置。这个称为分区（partition）操作；
 3)递归地（recursive）把小于基准值元素的子数列和大于基准值元素的子数列排序。 */
void quickSort(int a[], int low, int high){
    if(low < high){
        int privotLoc = partition(a,  low,  high);  //将表一分为二
        quickSort(a,  low,  privotLoc -1);            //递归对低子表递归排序
        quickSort(a,   privotLoc + 1, high);        //递归对高子表递归排序
    }
}

/**
 二分查找
 折半查找的原理：
 1> 数组必须是有序的
 2> 必须已知min和max（知道范围）
 3> 动态计算mid的值，取出mid对应的值进行比较
 4> 如果mid对应的值大于要查找的值，那么max要变小为mid-1
 5> 如果mid对应的值小于要查找的值，那么min要变大为mid+1
 */
- (NSInteger)binarySearch:(NSArray *)array
                    value:(NSInteger)value
               startIndex:(NSInteger )start
                 endIndex:(NSInteger )end{
    NSInteger midIndex = start + (array.count - end)/2;
    NSInteger midValue = [array[midIndex] integerValue];
    if (midValue == value) {
        return midIndex;
    }
    if (midValue > value) {
        return [self binarySearch:array value:value startIndex:start endIndex:midValue-1];
    }
    if (midValue < value) {
        return [self binarySearch:array value:value startIndex:midValue + 1 endIndex:end];
    }
    return 0;
}

/*                           i       k
 数组1： 已经比较存在相同的元素   尚未比较  已经比较不存在相同的元素
 j
 数组2： 已经比较存在相同的元素   待比较元素
 
 算法流程：
 从数组1的尚未比较的元素中拿出第一个元素array1(i)，用array1(i)与array2(j)进行比较（其中j>i且j<array2的长度），可能出现下面两种情况，
 1.数组2中找到了一个与array1(i)相等的元素，则将array2(j)与array2(i)进行交换，i加一，进行下次迭代
 2.数组2直到结尾也没找到与array1(i)相等的元素，则将array1(i)与尚未进行比较的最后一个元素array1(k)进行交换，i不加一，进行下次迭代。
 */
- (void)getDifferenceSet
{
    //定义两个数组
    int array1[] = {7,1,2,5,4,3,5,6,3,4,5,6,7,3,2,5,6,6};
    int size1 = 18;
    int array2[] = {8,2,1,3,4,5,3,2,4,5,3,2,1,3,5,4,6,9};
    int size2 = 18;
    int end = size1;
    bool swap = false;//标识变量，表示两种情况中的哪一种
    
    for (int i = 0; i < end; ) {
        swap = false;//开始假设是第一种情况
        for (int j = i; j < size2; j++) { //找到与该元素存在相同的元素，将这个相同的元素交换到与该元素相同下标的位置上
            if (array1[i] == array2[j]) { //第二种情况，找到了相等的元素
                int tmp = array2[i];//对数组2进行交换
                array2[i] = array2[j];
                array2[j] = tmp;
                swap = true;//设置标志
                break;
            }
        }
        if (swap != true) { //第一种情况，没有相同元素存在时，将这个元素交换到尚未进行比较的尾部
            int tmp = array1[i];
            array1[i] = array1[--end];
            array1[end] = tmp;
        } else {
            i++;
        }
    }
    // 结果就是在end表示之前的元素都找到了匹配，而end元素之后的元素都未被匹配
    
    // 先输出差集
    NSLog(@"only in array1");
    for(int i = end; i < size1; i++) {
        printf("%d ", array1[i]);
    }
    printf("\n");
    
    NSLog(@"only in array2");
    for(int i = end ; i < size2; i++) {
        printf("%d ", array2[i]);
    }
    printf("\n");
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    testDemo();
}

void testDemo() {
    NSArray *names = @[@"夏侯惇", @"貂蝉", @"诸葛亮", @"张三", @"李四", @"流火绯瞳"];
    NSArray *ages = @[@"2018-01-29", @"2018-01-30", @"2018-01-28", @"2018-01-21", @"2018-02-01", @"2018-02-01"];
    NSArray *heights = @[@"170", @"163", @"180", @"165", @"163", @"176"];
    
    NSMutableArray *peoples = [NSMutableArray arrayWithCapacity:names.count];
    for (int i = 0; i< names.count; i++) {
        Son *son = [[Son alloc]init];
        [son setValue:@"nan" forKey:@"sex"];
        son.name = names[i];
        son.age = ages[i];
        son.height = heights[i];
        [peoples addObject:son];
    }
    //双重排列的的属性类型必须一样
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"age" ascending:NO];
    NSSortDescriptor *sort1 = [NSSortDescriptor sortDescriptorWithKey:@"height" ascending:YES];
    
    [peoples sortUsingDescriptors:@[sort,sort1]];
    
    // 输出排序结果
    for (Son *temp in peoples) {
        NSLog(@"age: %@, height: %@, sex: %@, name: %@", temp.age, temp.height, temp.sex, temp.name);
    }

}

@end
