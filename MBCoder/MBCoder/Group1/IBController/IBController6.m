//
//  IBController6.m
//  IBCoder1
//
//  Created by Bowen on 2018/4/28.
//  Copyright © 2018年 BowenCoder. All rights reserved.
//

#import "IBController6.h"
#import "IBView.h"

@interface IBController6 ()

@property (nonatomic, strong) UIView *iView;
@property (nonatomic, strong) NSLayoutConstraint *height;
@property (nonatomic, strong) IBView *ibView;

@end

@implementation IBController6

/*
 一、UIViewAutoresizing

 UIViewAutoresizingNone    不会随父视图的改变而改变
 
 UIViewAutoresizingFlexibleLeftMargin 自动调整view与父视图左边距，以保证右边距不变
 
 UIViewAutoresizingFlexibleWidth 自动调整view的宽度，保证左边距和右边距不变
 
 UIViewAutoresizingFlexibleRightMargin 自动调整view与父视图右边距，以保证左边距不变
 
 UIViewAutoresizingFlexibleTopMargin 自动调整view与父视图上边距，以保证下边距不变
 
 UIViewAutoresizingFlexibleHeight  自动调整view的高度，以保证上边距和下边距不变
 
 UIViewAutoresizingFlexibleBottomMargin 自动调整view与父视图的下边距，以保证上边距不变
 
 注意：设置视图的属性autoresizesSubviews为yes才会生效(不一定)
 
 二、NSLayoutConstraint
 
 计算公式：view1.attr1 = view2.attr2 * multiplier + constant

                view1：要添加约束的视图对象
                view2：父视图
    NSLayoutAttribute：有上、下、左、右、宽、高等。
            relatedBy：两个参考属性之间关系
           multiplier：约束的比例，比如view1的宽是view2的宽的两倍，这个multiplie就是2.
             constant：约束常量
 +(instancetype)constraintWithItem:(id)view1
                         attribute:(NSLayoutAttribute)attr1
                         relatedBy:(NSLayoutRelation)relation
                            toItem:(nullable id)view2
                         attribute:(NSLayoutAttribute)attr2
                        multiplier:(CGFloat)multiplier
                          constant:(CGFloat)c;
 
 
 VFL语言语法格式
  H：代表水平方向    H:|  代表水平方向距离父视图
  V：代表垂直方向    V:|  代表垂直方向距离父视图
  |：边界
  -：间隙
 []：要添加的约束view
 
 NSLayoutFormatOptions：设置为0即可
 metrics:属性替换字典，例如我们上边用到的距离左边界20，如果这个20是变量width,我们将20的地方换成width，然后配置这个字典@{@“width":@20}，
         这样在布局时，系统会把width换成20。dictionary的key必须是NSString值，dictionary的value必须是NSNumber类型。
   views:对象的映射字典，原理也是将字符串中的对象名映射成真实的对象，NSDictionaryOfVariableBindings(对象)会帮我们生成这样的字典
 
 + (NSArray<__kind of NSLayoutConstraint *> *)constraintsWithVisualFormat:(NSString *)format
                                                                  options:(NSLayoutFormatOptions)opts
                                                                  metrics:(nullable NSDictionary *)metrics
                                                                    views:(NSDictionary *)views;
例子：
 [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-100-[label(100)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(label)]
 H:|-20-[label(100@1000)]
 前面的H代表是水平的布局还是垂直的布局，H代表水平，V表示垂直，|表示父视图的边沿，-20-表示距离20px，[]内是要布局摆放的视图对象名，()中是约束的尺寸，H下则为宽度，V下则为高度,@后面的数字代表优先级。(约束还具有 1 到 1000 之间的优先级。具有优先级 1000 的约束是必需的。小于 1,000 的所有优先级是可选的。默认情况下，所有约束都是需要 (优先级 = 1,000)。在解决所要的约束后，AutoLayout将从最高到最低的优先级顺序来处理所有可选约束，如果它不能解决一个可选的约束，它将尝试来作为尽可能接近所需的结果，然后移动到下一个约束。这种不平等、 平等和优先级的结合给你强大的灵活性。通过结合多个约束,可以定义动态地适应用户界面元素在屏幕中的大小和位置。)
 
 注意事项：
 1、约束前子视图已经添加到父视图上
 2、一定要禁止将Autoresizing Mask转换为约束（translatesAutoresizingMaskIntoConstraints设置为no）
 3、子视图约束添加到父视图上
 4、如果是设置view自身的属性，不涉及到与其他view的位置约束关系。第四个参数为nil，第五个参数为NSLayoutAttributeNotAnAttribute
 5、在设置宽和高这两个约束时，relatedBy参数使用的是 NSLayoutRelationGreaterThanOrEqual，而不是 NSLayoutRelationEqual。
 
 
 三、于UIView的translatesAutoresizingMaskIntoConstraints属性
    除了AutoLayout，AutoresizingMask也是一种布局方式。
    默认情况下，translatesAutoresizingMaskIntoConstraints ＝ true , 此时视图的AutoresizingMask会被转换成对应效果的约束。
    这样很可能就会和我们手动添加的其它约束有冲突。此属性设置成false时，AutoresizingMask就不会变成约束。也就是说 当前 视图的 AutoresizingMask失效了。
 
 四、AutoLayout与Frame篇
 
    解决父视图是约束适配，子视图是frame适配问题
    1、把子视图frame设置写到layoutSubviews中或者写到viewDidLayoutSubviews中即可。因为父视图约束生效时view的center或者bounds就会被修改，center或者bounds被修改时layoutSubview,就会被调用，随后viewDidLayoutSubviews就回被调用。这个时候，设置约束的视图frame就不再是(0,0,0,0)了
    2、在设置完约束之后手动调用layoutIfNeeded方法，让视图立即layout，更新frame。在这之后就可以拿到设置约束的视图的尺寸了。
    3、假如父视图设置frame，子视图约束时，需要父视图先调用[superview setNeedsUpdateConstraints]和
       [superview updateConstraintsIfNeeded]两个方法
    4、在viewDidLoad中得到的view的frame不一定是最终的frame，比如导航栏设置不透明就不准
 
 五、刷新子布局
 
 1、layoutSubviews在以下情况下会被调用：(刷新子布局，需要重写)
 1）init初始化不会触发layoutSubviews，但是是用initWithFrame 进行初始化时，当rect的值不为CGRectZero时,也会触发
 2）addSubview会触发layoutSubviews
 3）设置view的Frame会触发layoutSubviews，当然前提是frame的值设置前后发生了变化
 4）滚动一个UIScrollView会触发layoutSubviews
 5）旋转Screen会触发父UIView上的layoutSubviews事件
 6）改变一个UIView大小的时候也会触发父UIView上的layoutSubviews事件
 
 2、setNeedsLayout方法： 标记为需要重新布局，异步调用layoutIfNeeded刷新布局，不立即刷新，但layoutSubviews一定会被调用
    layoutIfNeeded方法：如果，有需要刷新的标记，立即调用layoutSubviews进行布局（如果没有标记，不会调用layoutSubviews）
 
 3、重绘
 1）setNeedsDisplay方法：标记为需要重绘，异步调用drawRect
 2）drawRect:(CGRect)rect方法：重写此方法，执行重绘任务
 3）setNeedsDisplayInRect:(CGRect)invalidRect方法：标记为需要局部重绘
 
 4、sizeToFit和sizeThatFits
 sizeToFit:会计算出最优的size，而且会改变自己的size
 sizeThatFits:会计算出最优的size，但是不会改变自己的size
 场景：
 1）navigationBar中对navigationItem的设置，（添加两个视图以上的控件到Item）
 2）toolBar中的对UIBarButtonItem的设置（一般我们还要添加弹簧控件）
 上述两种场合就可以用sizeToFit这个方法，来让系统给我们做自动布局。（注意：如果就添加一个控件的话，我们直接设置frame也是可以的）
 3）在tabBar中我们不能手动的添加的子控件，因为tabBar是根据控制器系统默认自动添加的tabBarItem。（猜想系统可能也会自动调用了这个方法）
 4）UILabel中添加文字，然后让调整label的大小来适应文字，我们也调用sizeToFit的方法。
 
 
5、注意:
 0）先调用layoutSubviews，在调用viewcontroller中的viewWillLayoutSubviews和viewDidLayoutSubviews
 1）如果要立即刷新，要先调用[view setNeedsLayout]，把标记设为需要布局，然后马上调用[view layoutIfNeeded]，实现布局
 2）在视图第一次显示之前，标记总是“需要刷新”的，可以直接调用[view layoutIfNeeded]
 3）layoutSubviews对subviews重新布局
 4）layoutSubviews方法调用先于drawRect
 5）setNeedsLayout在receiver标上一个需要被重新布局的标记，在系统runloop的下一个周期自动调用layoutSubviews
 6）layoutIfNeeded方法如其名，UIKit会判断该receiver是否需要layout.根据Apple官方文档,layoutIfNeeded方法应该是这样的
 7）layoutIfNeeded遍历的不是superview链，应该是subviews链
 8）drawRect是对receiver的重绘，能获得context
 9）setNeedDisplay在receiver标上一个需要被重新绘图的标记，在下一个draw周期自动重绘，iphone device的刷新频率是60hz，也就是1/60秒后重绘
 
 六、updateViewConstraints与updateConstraints篇
 1、setNeedsUpdateConstraints当一个自定义view的某个属性发生改变，并且可能影响到constraint时，需要调用此方法去标记constraints需要在未来的某个点更新，系统然后调用updateConstraints.
 2、needsUpdateConstraints 使用此返回值去决定是否需要调用updateConstraints作为正常布局过程的一部分。
 3、updateConstraintsIfNeeded 立即触发约束更新，自动更新布局。
 4、updateConstraints 自定义view应该重写此方法在其中建立constraints. 注意：要在实现在最后调用[super updateConstraints]，在完成自己组件的autolayout约束设定后，需要调用父类的更新设定以保证约束生效。
 
 updating constraints->layout->display
 
 七、intrinsicContentSize和invalidateIntrinsicContentSize
    intrinsicContentSize：内置大小，控件本身内容控制控件大小
    invalidateIntrinsicContentSize：内置大小变化后，需重新计算尺寸，调用invalidateIntrinsicContentSize刷新
 
 八、setContentHuggingPriority和setContentCompressionResistancePriority
    setContentHuggingPriority：该优先级表示一个控件抗被拉伸的优先级。优先级越高，越不容易被拉伸。
    setContentCompressionResistancePriority：该优先级和上面那个优先级相对应，表示一个控件抗压缩的优先级。优先级越高，越不容易被压缩
 
*/

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%s",__func__);
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    
    self.iView = [[UIView alloc] init];
    self.iView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:self.iView];
    self.iView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:self.iView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0];
    NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:self.iView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0];
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:self.iView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0];
    NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:self.iView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:100.0];
    
    self.height = height;
    [self.view addConstraints:@[left,right,top,height]];
    
//    [self.iView layoutIfNeeded]; //手动调用出现尺寸
//    NSLog(@"%@",NSStringFromCGRect(self.view.frame));
    
    self.ibView = [[IBView alloc] initWithFrame:CGRectMake(0, 250, 414, 44)];
    self.ibView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.ibView];

    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self test1];
    
}

- (void)test1 {
    
    NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:self.iView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:200.0];
    [self.view removeConstraint:self.height];
    [self.view addConstraints:@[height]];
    
    self.ibView.frame = CGRectMake(0, 250, 414, 80);
}

- (void)updateViewConstraints {
    [super updateViewConstraints];
    NSLog(@"%s",__func__);
}


- (void)viewWillLayoutSubviews {
    NSLog(@"%s",__func__);

}

- (void)viewDidLayoutSubviews {
    NSLog(@"%s--%@",__func__,NSStringFromCGRect(self.iView.frame));

}



@end
