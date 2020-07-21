//
//  IBController13.m
//  IBCoder1
//
//  Created by Bowen on 2018/5/8.
//  Copyright © 2018年 BowenCoder. All rights reserved.
//

#import "IBController13.h"
#import <objc/runtime.h>
#import <objc/message.h>
/*
 一、isa指针问题
 isa：是一个Class类型的指针。
 当调用对象方法时，通过instance的isa找到class，然后调用对象方法的实现；如果没有，通过superclass找到父类的class，最后找到对象方法的实现进行调用
 当调用类方法时，通过class的isa找到meta-class，然后调用类方法的实现；如果没有，通过superclass找到父类的meta-class，最后找到类方法的实现进行调用
 注意的是:元类(meteClass)也是类，它也是对象。元类也有isa指针,它的isa指针最终指向的是一个根元类(root meteClass)。根元类的isa指针指向本身，
        这样形成了一个封闭的内循环。

 1、isa、superclass总结
 1）instance的isa指向class
 2）class的isa指向meta-class
 3）meta-class的isa指向基类的meta-class
 4）class的superclass指向父类的class，如果没有父类，superclass指针为nil
 5）meta-class的superclass指向父类的meta-class，基类的meta-class的superclass指向基类的class
 6）instance调用对象方法的轨迹：isa找到class，方法不存在，就通过superclass找父类
 7）class调用类方法的轨迹：isa找meta-class，方法不存在，就通过superclass找父类

 注意：从64bit开始，isa需要进行一次位运算（&ISA_MASK），才能计算出真实地址
 
 2、引用计数的存储
 在arm64架构之前，isa就是一个普通的指针，存储着Class、Meta-Class对象的内存地址
 从arm64架构开始，对isa进行了内存优化，变成了一个共用体（union）结构，还使用位域来存储更多的信息
 union isa_t {
    Class cls;
    uintptr_t bits;
    struct {
        uintptr_t nonpointer        : 1; 0代表普通指针，存储类，元类对象的内存地址；1代表优化过，使用位域存储引用计数，析构状态等信息
        uintptr_t has_assoc         : 1; 是否有设置过关联对象，如果没有，释放时会更快
        uintptr_t has_cxx_dtor      : 1; 是否有C++的析构函数（.cxx_destruct），如果没有，释放时会更快
        uintptr_t shiftcls          : 44;存储着Class、Meta-Class对象的内存地址信息
        uintptr_t magic             : 6; 用于在调试时分辨对象是否未完成初始化
        uintptr_t weakly_referenced : 1; 用于在调试时分辨对象是否未完成初始化
        uintptr_t deallocating      : 1; 对象是否正在释放
        uintptr_t has_sidetable_rc  : 1; 引用计数器是否过大无法存储在isa中,如果为1，那么引用计数会存储在一个叫SideTable的类的属性中
        uintptr_t extra_rc          : 8  里面存储的值是引用计数
    };
 };
 
 在64bit中，引用计数可以直接存储在优化过的isa指针中，也可能存储在SideTable类中
 struct SideTable {
    spinlock_t slock;
    RefcountMap refcnts; refcnts是一个存放着对象引用计数的散列表
    weak_table_t weak_table; weak_table 弱引用哈希表
 }
 
 二、Runtime实现的机制是什么，怎么用，一般用于干嘛？
 1) 使用时需要导入的头文件 <objc/message.h> <objc/runtime.h>
 2) Runtime 运行时机制，它是一套C语言库。
 3) 实际上我们编写的所有OC代码，最终都是转成了runtime库的东西。
    比如：
    类转成了 Runtime 库里面的结构体等数据类型，
    方法转成了 Runtime 库里面的C语言函数，
    平时调方法都是转成了 objc_msgSend 函数（所以说OC有个消息发送机制）
    // OC是动态语言，每个方法在运行时会被动态转为消息发送，即：objc_msgSend(receiver, selector)。
    // [stu show];  在objc动态编译时，会被转意为：objc_msgSend(stu, @selector(show));
 4) 因此，可以说 Runtime 是OC的底层实现，是OC的幕后执行者。
 
 三、什么是 Method Swizzle（黑魔法），什么情况下会使用？
 1) 在没有一个类的实现源码的情况下，想改变其中一个方法的实现，除了继承它重写、和借助类别重名方法暴力抢先之外，还有更加灵活的方法 Method Swizzle。
 2) Method Swizzle 指的是改变一个已存在的选择器对应的实现的过程。OC中方法的调用能够在运行时通过改变，通过改变类的调度表中选择器到最终函数间的映射关系。
 3) 在OC中调用一个方法，其实是向一个对象发送消息，查找消息的唯一依据是selector的名字。利用OC的动态特性，可以实现在运行时偷换selector对应的方法实现。
 4) 每个类都有一个方法列表，存放着selector的名字和方法实现的映射关系。IMP有点类似函数指针，指向具体的方法实现。
 5) 我们可以利用 method_exchangeImplementations 来交换2个方法中的IMP。
 6) 我们可以利用 class_replaceMethod 来修改类。
 7) 我们可以利用 method_setImplementation 来直接设置某个方法的IMP。
 8) 归根结底，都是偷换了selector的IMP。
 
 四、_objc_msgForward 函数是做什么的，直接调用它将会发生什么？
 答：_objc_msgForward是 IMP 类型，用于消息转发的：当向一个对象发送一条消息，但它并没有实现的时候，_objc_msgForward会尝试做消息转发。
 
 五、应用
 总结起来，iOS中的RunTime的作用有以下几点：
 1.发送消息(obj_msgSend)
 2.方法交换(method_exchangeImplementations)
 3.消息转发
 4.动态添加方法
 5.给分类添加属性
 6.获取到类的成员变量及其方法
 7.动态添加类
 8.解档与归档
 9.字典转模型
 
 六、runtime如何实现weak属性？
 weak策略表明该属性定义了一种“非拥有关系” (nonowning relationship)。为这种属性设置新值时，设置方法既不保留新值，也不释放旧值。
 此特质同assign类似;然而在属性所指的对象遭到摧毁时，属性值也会清空(nil out)
 那么runtime如何实现weak变量的自动置nil？
 runtime对注册的类，会进行布局，会将 weak 对象放入一个hash表中。用weak指向的对象内存地址作为key，当此对象的引用计数为0的时候会调
 用对象的dealloc方法，假设weak指向的对象内存地址是a，那么就会以a为key，在这个weak hash表中搜索，找到所有以a为key的weak对象，
 从而设置为 nil。具体细节：http://www.cocoachina.com/ios/20170328/18962.html
 
 (静态变量)SideTablesMap->(对象地址找到)SideTable->weak_table_t（以对象地址hash算法找索引，取出weak_entry_t）
 ->weak_entry_t（定长数组，动态数组（以弱指针的地址hash算法找索引，取出weak_referrer_t））-> weak_referrer_t
 
 weak属性需要在dealloc中置nil么
 在ARC环境无论是强指针还是弱指针都无需在dealloc设置为nil，ARC会自动帮我们处理
 即便是编译器不帮我们做这些，weak也不需要在dealloc中置nil
 在属性所指的对象遭到摧毁时，属性值也会清空！
 
 七、runtime如何通过selector找到对应的IMP地址？（分别考虑类方法和实例方法）
 1.每一个类对象中都一个对象方法列表（对象方法缓存）
 2.类方法列表是存放在类对象中isa指针指向的元类对象中（类方法缓存）
 3.方法列表中每个方法结构体中记录着方法的名称,方法实现,以及参数类型，其实selector本质就是方法名称,通过这个方法名称就可以在方法列表中找到
   对应的方法实现.
 5.当我们发送一个消息给一个NSObject对象时，这条消息会在对象的类对象方法列表里查找
 6.当我们发送一个消息给一个类时，这条消息会在类的Meta Class对象的方法列表里查找

 八、使用runtime Associate方法关联的对象，需要在主对象dealloc的时候释放么？
    无论在MRC下还是ARC下均不需要，被关联的对象在生命周期内要比对象本身释放的晚很多，它们会在被 NSObject -dealloc调用
 的object_dispose()方法中释放
 
 九、_objc_msgForward函数是做什么的？直接调用它将会发生什么？
    _objc_msgForward是IMP类型，用于消息转发的：当向一个对象发送一条消息，但它并没有实现的时候，_objc_msgForward会尝试做消息转发
 直接调用_objc_msgForward是非常危险的事，这是把双刃刀，如果用不好会直接导致程序Crash，但是如果用得好，能做很多非常酷的事
 
 十、简述下Objective-C中调用方法的过程（runtime）
 Objective-C是动态语言，每个方法在运行时会被动态转为消息发送，即：objc_msgSend(receiver, selector)，整个过程介绍如下：
 
 a.实例对象发送消息（对象调用实例方法时，是在对应类对象及其继承链上找方法。）
 1.objc在向一个对象发送消息时，runtime库会根据对象的isa指针找到该对象实际所属的类
 2.然后在该类中的方法列表以及其父类方法列表中寻找方法运行
 3.如果，在最顶层的父类（一般也就NSObject）中依然找不到相应的方法时，程序在运行时会挂掉并抛出异常unrecognized selector sent to XXX
   但是在这之前，objc的运行时会给出三次拯救程序崩溃的机会，
 
 b.类对象发送消息(类对象调用类方法时，是在其元类及继承链上找方法。)
 1.元类的isa指针都指向根元类（NSObject），根元类的isa指针指向自己NSObject
 2.在iOS中静态方法就是类方法，静态方法效率高但占内存
 3.如果我们调用一个类方法没有对应实现，但根元类有同名的实例方法的实现，会不会崩溃
    类的实例方法是存储在类的methodLists中，而类方法则是存储在元类的methodLists中，根据类关系图（工程已导入），
    NSObject的元类的superclass是指向Class(NSObject)，当调用没有实现的类方法时，在其元类及继承链上找方法，最终会走到根元类。
    而根元类会指向自己（NSObject）并且实例方法存在NSObject的methodLists，所以会找到实例方法并调用。
 
 注意点，一般使用频繁的方法用静态方法，用的少的方法用动态的。静态的速度快，占内存。动态的速度相对慢些，
 但调用完后，立即释放类，可以节省内存，可以根据自己的需要选择是用动态方法还是静态方法。
 
 十一、类结构
 1、
 struct objc_object {
 private:
     isa_t isa;
 };
 2、
 struct objc_class : objc_object {
    Class superclass;
    cache_t cache;
    class_data_bits_t bits;
 };
 3、
 struct class_data_bits_t {
    uintptr_t bits;
 public:
     class_rw_t* data() {
         return (class_rw_t *)(bits & FAST_DATA_MASK);
     }
 };
 4、
 struct class_rw_t {
    uint32_t flags;
    uint32_t version;

    const class_ro_t *ro;

    method_array_t methods;
    property_array_t properties;
    protocol_array_t protocols;

 };
 5、
 struct class_ro_t {
     uint32_t flags;
     uint32_t instanceStart;
     uint32_t instanceSize;

     const uint8_t * ivarLayout;
     
     const char * name;
     method_list_t * baseMethodList;
     protocol_list_t * baseProtocols;
     const ivar_list_t * ivars;

     const uint8_t * weakIvarLayout;
     property_list_t *baseProperties;
 };
 6、
 struct property_t {
     const char *name;
     const char *attributes;
 };
7、
 struct ivar_t {
    int32_t *offset;
    const char *name;
    const char *type;
    uint32_t alignment_raw;
    uint32_t size;
 };
 8、
 struct method_t {
     SEL name;          // 函数名
     const char *types; // 编码（返回值和参数类型）
     MethodListIMP imp; // 函数指针
 };
 9、
 struct cache_t {
    struct bucket_t *_buckets; // 散列表
    mask_t _mask;              // 散列表长度
    mask_t _occupied;          // 已缓存的方法数量
 };
 10、
 struct bucket_t {
    cache_key_t _key;    // SEL作为key
    MethodCacheIMP _imp; // 函数的内存地址
 };
 
 十二、super
`1、结构
 struct objc_super {
     id receiver;
     Class super_class;
 };
 objc_msgSendSuper2(struct objc_super * _Nonnull super, SEL _Nonnull op, ...)

 1、[super class]为什么打印当前类？
 1）消息接收者仍是子类对象
 2）从父类开始查找方法的实现
 3）class实现：
 - (Class)class {
     return object_getClass(self);
 }
 
 */

@interface Mother: NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *age;
@property (nonatomic, copy, readonly) NSString *birthday;


- (void)run;
+ (void)run;


@end

@implementation Mother

- (instancetype)init
{
    self = [super init];
    if (self) {
        _birthday = @"1962";
    }
    return self;
}

+ (BOOL)accessInstanceVariablesDirectly {
    return NO;
}

- (void)goodMother:(NSString *)name {
    NSLog(@"%s--%@",__func__, name);
}

- (void)run {
    NSLog(@"%s",__func__);
}

+ (void)run {
    NSLog(@"%s",__func__);
}

- (void)sleep {
    NSLog(@"%s",__func__);
}

///演示对象，类，元类，根元类地址内存
- (void)print {
    NSLog(@"This object is %p.", self);
    NSLog(@"Class is %@, and super is %@.", [self class], [self superclass]);
    const char *name = object_getClassName(self);
    Class metaClass = objc_getMetaClass(name);
    NSLog(@"MetaClass is %p",metaClass);
    Class currentClass = [self class];
    for (int i = 1; i < 5; i++)
    {
        NSLog(@"Following the isa pointer %d times gives %p", i, currentClass);
        unsigned int countMethod = 0;
        NSLog(@"---------------**%d start**-----------------------",i);
        Method * methods = class_copyMethodList(currentClass, &countMethod);
        [self printMethod:countMethod methods:methods ];
        NSLog(@"---------------**%d end**-----------------------",i);
        currentClass = object_getClass(currentClass);
    }
    NSLog(@"NSObject's class is %p", [NSObject class]);
    NSLog(@"NSObject's meta class is %p", object_getClass([NSObject class]));
}

- (void)printMethod:(int)count methods:(Method *) methods {
    for (int j = 0; j < count; j++) {
        Method method = methods[j];
        SEL methodSEL = method_getName(method);
        const char * selName = sel_getName(methodSEL);
        if (methodSEL) {
            NSLog(@"sel------%s", selName);
        }
    }
}

@end

@interface Mother(ext)

@property (nonatomic, copy) NSString *son;

@end

@implementation Mother(ext)

- (void)goodMother:(NSString *)name {
    NSLog(@"%s--%@",__func__, name);
}

- (void)setSon:(NSString *)son {
    // 第一个参数：给哪个对象添加关联
    // 第二个参数：关联的key，通过这个key获取
    // 第三个参数：关联的value
    // 第四个参数:关联的策略
    objc_setAssociatedObject(self, "bowen", son, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)son {
    // 根据关联的key，获取关联的值。
    return objc_getAssociatedObject(self, "bowen");
}

@end

@interface Mother(ext2)

@end

@implementation Mother(ext2)

- (void)goodMother:(NSString *)name {
    [self callOriginalMethod:_cmd param:name];
    NSLog(@"%s--%@",__func__, name);
}


/*
 分类重写原类方法时，调用原类方法
 1.使用下面这个方法
 2.使用Aspects方法
 3._cmd 表示当前方法
 */
- (void)callOriginalMethod:(SEL)selector param:(NSString *)param {
    unsigned int count;
    unsigned int index = 0;
    
    //获得指向该类所有方法的指针
    Method *methods = class_copyMethodList([self class], &count);
    
    for (int i = 0; i < count; i++) {
        //获得该类的一个方法指针
        Method method = methods[i];
        //获取方法
        SEL methodSEL = method_getName(method);
        if (methodSEL == selector) {
            index = i;
        }
    }
    SEL fontSEL = method_getName(methods[index]);
    IMP fontIMP = method_getImplementation(methods[index]);
    ((void (*)(id, SEL, NSString *))fontIMP)(self,fontSEL,param);
    
    free(methods);
}

/*
 Class cls = NSClassFromString(@"LinkHandler");
 SEL selector = @selector(handleLink:source:from:);
 IMP imp = [cls methodForSelector:selector];
 ((id(*)(id, SEL, NSString *, id, int))imp)(cls, selector, linkUrl, room.roomInnerWebVC, 0);
 */


@end



@interface IBController13 ()

@end


@implementation IBController13

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 类与元类
    NSLog(@"%d", [NSObject isKindOfClass:[NSObject class]]); // 1
    NSLog(@"%d", [NSObject isMemberOfClass:[NSObject class]]); // 0
    NSLog(@"%d", [IBController13 isKindOfClass:[NSObject class]]); // 1
    NSLog(@"%d", [IBController13 isKindOfClass:[IBController13 class]]); // 0
    NSLog(@"%d", [IBController13 isMemberOfClass:[IBController13 class]]); // 0
    NSLog(@"%d", [IBController13 isKindOfClass:object_getClass([IBController13 class])]); // 1
    NSLog(@"%d", [IBController13 isMemberOfClass:object_getClass([IBController13 class])]); // 1
    
    NSLog(@"++++++++++++++++++++++++++++++++++++++++++++++");
    // 实例与对象
    NSLog(@"%d", [[[NSObject alloc] init] isKindOfClass:[NSObject class]]); // 1
    NSLog(@"%d", [[[NSObject alloc] init]  isMemberOfClass:[NSObject class]]); // 1

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
//    [self accessToMemberVariable];

//    [self accessToMemberVariable];
//    [self accessToProperty];
//    [self accessToMethod];
//    [self accessToProtocol];
//    [self sendMsg];
//    [self addMethod];
//    [self exchangeMethod];
//    [self addCategoryProperty];
//    [self createClass];
    [self forbidKVC];
    
}

- (void)forbidKVC {
    Mother *mother = [[Mother alloc] init];
    NSLog(@"母亲生日:%@", mother.birthday);
    Ivar _birthday = class_getInstanceVariable([Mother class], "_birthday");
    object_setIvar(mother, _birthday, @"1992");
    NSLog(@"母亲生日:%@", mother.birthday);
    
    [mother setValue:@"2012" forKey:mother.birthday];
    NSLog(@"母亲生日:%@", mother.birthday);
}

- (void)print {
    [[[Mother alloc] init] print];
    [[[Mother alloc] init] goodMother:@"fang"]; //测试在分类重写方法中调用原类方法
}


///创建类
- (void)createClass {
    //使用objc_allocateClassPair创建一个类Class
    const char *ClassName = "Bowen";
    Class kClass = objc_getClass(ClassName);
    
    if (!kClass) {
        Class superClass = [NSObject class];
        kClass = objc_allocateClassPair(superClass, ClassName, 0);
    }
    
    //使用class_addIvar添加一个成员变量
    class_addIvar(kClass, "_name", sizeof(NSString*), log2(sizeof(NSString*)), @encode(NSString*));
    //使用class_addMethod添加成员方法
    class_addMethod(kClass, @selector(food:), (IMP)food, "v@:*");
    //注册到运行时环境
    objc_registerClassPair(kClass);
    //实例化类
    id instance = [[kClass alloc] init];
    //获取变量名
    Ivar nameIvar = class_getInstanceVariable(kClass, "_name");
    //给变量复制
    object_setIvar(instance, nameIvar, @"面条");
    //调用函数
    [instance performSelector:@selector(food:) withObject:object_getIvar(instance, nameIvar)];

    
}


///给分类添加属性
- (void)addCategoryProperty {
    Mother *mama = [[Mother alloc] init];
    mama.son = @"YinLong";
    NSLog(@"%@",mama.son);
}

///交换方法实现
- (void)exchangeMethod {
    SEL runSEL = @selector(run);
    SEL sleepSEL = @selector(sleep);
    
    Method runMethod = class_getInstanceMethod([Mother class], runSEL);
    Method sleepMethod = class_getInstanceMethod([Mother class], sleepSEL);
    
    BOOL isAdd = class_addMethod([Mother class], sleepSEL, method_getImplementation(sleepMethod), "v@:");
    
    if (isAdd) {
        class_replaceMethod([Mother class], runSEL, method_getImplementation(sleepMethod), "v@:");
    } else {
        method_exchangeImplementations(runMethod, sleepMethod);
    }
    Mother *mama = [[Mother alloc] init];
    [mama run];
    
}

///添加方法
- (void)addMethod {
    class_addMethod([Mother class], @selector(eat:), (IMP)food, "v@:*");
    Mother *mama = [[Mother alloc] init];
    [mama performSelector:@selector(eat:) withObject:@"饺子"];
}

void food(id self, SEL _cmd, NSString *food) {
    NSLog(@"%s %@",__func__, food);
}

///发送消息
- (void)sendMsg {
    Mother *mama = [[Mother alloc] init];
    
    // 调用对象方法
    [mama run];
    
    // 本质：让对象发送消息
    ((void(*)(id,SEL))objc_msgSend)(mama, @selector(run));
    
    // 调用类方法的方式：两种
    // 第一种通过类名调用
    [Mother run];
    // 第二种通过类对象调用
    [[Mother class] run];
    // 用类名调用类方法，底层会自动把类名转换成类对象调用
    // 本质：让类对象发送消息
    ((void(*)(id,SEL))objc_msgSend)([Mother class], @selector(run));
}

///获得成员变量
- (void)accessToMemberVariable {
    NSLog(@"成员变量");
    unsigned int count;
    Ivar *ivars = class_copyIvarList([UIResponder class], &count);
    for (int i = 0; i < count; i++) {
        Ivar ivar = ivars[i];
        const char *nameC = ivar_getName(ivar);
        NSString *nameOC = [NSString stringWithUTF8String:nameC];
        NSLog(@"%@",nameOC);
    }
    free(ivars);
}

///获得属性
- (void)accessToProperty
{
    NSLog(@"属性");
    unsigned int count;
    //获得指向该类所有属性的指针
    objc_property_t *properties = class_copyPropertyList([Mother class], &count);
    
    for (int i = 0; i < count; i++) {
        //获得该类一个属性的指针
        objc_property_t property = properties[i];
        
        //获得属性的名称
        const char *nameC = property_getName(property);
        //C的字符串转成OC字符串
        NSString *nameOC = [NSString stringWithUTF8String:nameC];
        NSLog(@"%@",nameOC);
    }
    free(properties);
}
///获得方法
- (void)accessToMethod
{
    NSLog(@"方法");
    unsigned int count;
    //获得指向该类所有方法的指针
    Method *methods = class_copyMethodList([UIView class], &count);
    
    for (int i = 0; i < count; i++) {
        
        //获得该类的一个方法指针
        Method method = methods[i];
        //获取方法
        SEL methodSEL = method_getName(method);
        //将方法名转化成字符串
        const char *methodC = sel_getName(methodSEL);
        //C的字符串转成OC字符串
        NSString *methodOC = [NSString stringWithUTF8String:methodC];
        //获得方法参数个数
        int arguments = method_getNumberOfArguments(method);
        NSLog(@"%@方法的参数个数：%d",methodOC, arguments);
    }
    free(methods);
}
///获得协议
- (void)accessToProtocol
{
    NSLog(@"协议");
    unsigned int count;
    //获取指向该类遵循的所有协议的指针
    __unsafe_unretained Protocol **protocols = class_copyProtocolList([Mother class], &count);
    
    for (int i = 0; i < count; i++) {
        //获取指向该类遵循的一个协议的指针
        Protocol *protocol = protocols[i];
        
        //获得属性的名称
        const char *nameC = protocol_getName(protocol);
        //C的字符串转成OC字符串
        NSString *nameOC = [NSString stringWithUTF8String:nameC];
        NSLog(@"%@",nameOC);
        
    }
    free(protocols);
}




@end
