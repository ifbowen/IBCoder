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
 
 2、Category的加载处理过程
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
