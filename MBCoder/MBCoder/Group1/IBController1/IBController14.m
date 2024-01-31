//
//  IBController14.m
//  IBCoder1
//
//  Created by Bowen on 2018/5/8.
//  Copyright © 2018年 BowenCoder. All rights reserved.
//

#import "IBController14.h"
#import "Son.h"
 
@interface IBController14 ()
 
@end

@implementation IBController14

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    Son *son = [[Son alloc] init];
    [son run];
    [son sleep];
}

@end

/**
 一、分类category
 在 Objective-C 中，分类（Category）是一种扩展现有类的机制，它允许我们在不修改原始类的情况下，为该类添加新的方法、属性或协议。
 注意两点：
 - category的方法没有“完全替换掉”原类已经有的方法，分类和原类的方法都存在
 - 多个分类相同方法，调用先后顺序取决于compile sources中文件的先后顺序
 
 1、数据结构
 struct category_t {
    const char *name;
    classref_t cls;
    struct method_list_t *instanceMethods;
    struct method_list_t *classMethods;
    struct protocol_list_t *protocols;
    struct property_list_t *instanceProperties;
    // Fields below this point are not always present on disk.
    struct property_list_t *_classProperties;
 };
 
 2、Category的加载处理过程(按需加载，程序启动先加载实现load方法，或者静态实例的分类，后面调用方法在加载某一个分类）
 1）从__DATA 或者 __DATA_CONST 或者 __DATA_DIRTY 数据段中取出和mach_header_64类型匹配的sectname为__objc_catlist的数据
 2）把所有Category的方法、属性、协议数据，合并到一个大数组中，后面参与编译的Category数据，会在数组的前面
 3）将合并后的分类数据（方法、属性、协议），插入到类原来数据的前面
 
 3、源码解读顺序
 objc-os.mm
 _objc_init
 objc-runtime-new.mm
 load_images
 loadAllCategories
 load_categories_nolock
 getDataSection
 attachCategories
 attachLists
 realloc、memmove、 memcpy
 
 4、分类的实现原理涉及到 Objective-C 的编译和运行时机制：
 编译时：
 在编译时，编译器会将分类的实现文件（.m 文件）与原始类的实现文件合并成一个编译单元。编译器会为分类生成一个符号表，其中包含分类的方法列表和属性列表。
 
 运行时：
 运行时系统会根据符号表将分类的方法和属性添加到原始类的方法列表和属性列表的前面。当调用方法时，运行时在查找方法的时候是顺着方法列表的顺序查找的，找到匹配的方法后进行调用。

 总结起来，分类的实现原理是通过编译时和运行时的机制，将分类的方法和属性添加到原始类中，从而实现对原始类的扩展。这种机制使得我们可以在不修改原始类的情况下，为类添加新的功能和行为。
 
 5、扩展和分类的区别
  extension 在编译期决议。extension一般用来隐藏类的私有信息。category 在运行期决议的。
  总结，extension可以添加实例变量，而category是无法添加实例变量的，因为在运行期，对象的内存布局已经确定，如果添加实例变量就会破坏类的内部布局，这对编译型语言来说是灾难性的。

 二、+load方法
 1、概括
 +load方法会在runtime加载类、分类时调用
 每个类、分类的+load，在程序运行过程中只调用一次

 2、调用顺序
 1）先调用类的+load
 2.1.1按照编译先后顺序调用（先编译，先调用）
 2.1.2调用子类的+load之前会先调用父类的+load

 2）再调用分类的+load
 2.2.1按照编译先后顺序调用（先编译，先调用）
 
 3、objc4源码解读过程：objc-os.mm
 _objc_init

 load_images

 prepare_load_methods
 schedule_class_load
 add_class_to_loadable_list
 add_category_to_loadable_list

 call_load_methods
 call_class_loads
 call_category_loads
 (*load_method)(cls, SEL_load)

 +load方法是根据方法地址直接调用，并不是经过objc_msgSend函数调用
 
 三、+initialize方法
 1、概括
 +initialize方法会在类第一次接收到消息时调用
 
 2、调用顺序
 1）先调用父类的+initialize，再调用子类的+initialize
 (先初始化父类，再初始化子类，每个类只会初始化1次)
 
 2）+initialize和+load的很大区别是，+initialize是通过objc_msgSend进行调用的，所以有以下特点
 如果子类没有实现+initialize，会调用父类的+initialize（所以父类的+initialize可能会被调用多次）
 如果分类实现了+initialize，就覆盖类本身的+initialize调用
 
 3、objc4源码解读过程
 objc-msg-arm64.s
 objc_msgSend

 objc-runtime-new.mm
 class_getInstanceMethod
 lookUpImpOrNil
 lookUpImpOrForward
 initializeAndLeaveLocked
 initializeAndMaybeRelock
 initializeNonMetaClass
 callInitialize
 objc_msgSend(cls, SEL_initialize)
 
 四、load和initialize区别
 1、调用方式
 1）load根据函数地址调用
 2）initialize是通过objc_msgSend调用
 
 2、调用时刻
 1）load是runtime加载类，分类的时候调用（只调用一次）
 2）initialize是类第一次接收到消息的时候调用，每一个类只会initialize一次（父类的initialize方法可能会被调用多次）
 
 3、调用顺序
 如上

*/
