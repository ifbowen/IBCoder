//
//  IBController9.m
//  IBCoder1
//
//  Created by Bowen on 2018/5/3.
//  Copyright © 2018年 BowenCoder. All rights reserved.
//

#import "IBController9.h"
#import "UIImageView+WebCache.h"
#import "UIView+Ext.h"

@implementation IBTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupCell];
    }
    return self;
}

- (void)setupCell {
    self.imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 414, 250)];
    [self.contentView addSubview:self.imgView];
}

@end

//按需加载
@interface IBController9 ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, copy) NSArray *images;
@property (strong,nonatomic) UITableView *tableView;

@end

/*
 
 一、滑动过程中不加载重用问题
 如果是lazy加载,滑动过程中是不进行网络请求的,cell上的图片就会发生重用,当你停下来能进行网络请求的时候,才会变回到当前Cell应有的图片,大概1-2秒的延迟吧(不算延迟,就是没有进行请求,也不是没有缓存的问题).怎么解决呢?这个时候我们就要在Model对象中定义个一个UIImage的属性,异步下载图片后,用已经缓存在沙盒中的图片路径给它赋值,这样,才cellForRowAtIndexPath方法中,判断这个UIImage对象是否为空,若为空,就进行网络请求,不为空,就直接将它赋值给cell的imageView对象,这样就能很好的解决图片短暂重用问题.

 二、tableview优化
 1、cell复用
 2、预先计算缓存高度
 3、渲染（异步绘制框架）
 4、视图层级优化（不要动态创建视图，善用hidden；减少视图层级）
 5、减少透明view
    使用透明view会引起blending，在iOS的图形处理中，blending主要指的是混合像素颜色的计算。最直观的例子就是，我们把两个图层叠加在一起，如果第一个图层的透明的，则最终像素的颜色计算需要将第二个图层也考虑进来。这一过程即为Blending。增加的计算复杂度
 6、不要阻塞主线程
 7、内存优化
 1）cell按需加载
 2）使用Autorelease Pool（避免内存峰值）
 3）gzip/zip压缩
 4）懒加载控件、页面（对于不是立刻使用的数据，都应该使用延迟加载的方式，比如网络连接失败的提示界面，可能一直都用不到）
 5）不要使用太多的xib/storyboard（载入时会将其内部的图片在内的所有资源载入内存，即使未来很久才会使用，对比代码写的延迟加载，在性能和内存上就差了很多）
 6）重大开销对象，比如NSDateFormatter和 NSCalendar用属性存储
 7）减少离屏渲染（离屏渲染指的是在图像在绘制到当前屏幕前，需要先进行一次渲染，之后才绘制到当前屏幕。）
 
 OpenGL中，GPU屏幕渲染有以下两种方式：
    On-Screen Rendering即当前屏幕渲染，指的是GPU的渲染操作是在当前用于显示的屏幕缓冲区中进行。
    Off-Screen Rendering即离屏渲染，指的是GPU在当前屏幕缓冲区以外新开辟一个缓冲区进行渲染操作。
 
 为什么离屏渲染会发生卡顿？主要包括两方面内容：
    创建新的缓冲区。
    上下文切换，离屏渲染的整个过程，需要多次切换上下文环境（CPU渲染和GPU切换），先是从当前屏幕（On-Screen）切换到离屏（Off-Screen）；等到离屏渲染结束以后，将离屏缓冲区的渲染结果显示到屏幕上又需要将上下文环境从离屏切换到当前屏幕。而上下文环境的切换是要付出很大代价的。
 
 设置了以下属性时，都会触发离屏渲染：
 layer.shouldRasterize，光栅化
 layer.mask，遮罩
 layer.allowsGroupOpacity为YES，layer.opacity的值小于1.0
 layer.cornerRadius，并且设置layer.masksToBounds为YES。可以使用剪切过的图片，或者使用layer画来解决。
 layer.shadows，(表示相关的shadow开头的属性)，使用shadowPath代替。
 
 离屏渲染的优化建议
 使用ShadowPath指定layer阴影效果路径。
 使用异步进行layer渲染（Facebook开源的异步绘制框架AsyncDisplayKit）。
 设置layer的opaque值为YES，减少复杂图层合成。
 尽量使用不包含透明（alpha）通道的图片资源。
 尽量设置layer的大小值为整形值。
 直接让美工把图片切成圆角进行显示，这是效率最高的一种方案。
 很多情况下用户上传图片进行显示，可以在客户端处理圆角。
 使用代码手动生成圆角image设置到要显示的View上，利用UIBezierPath（Core Graphics框架）画出来圆角图片。
 
 8）合理使用光栅化 shouldRasterize
    光栅化是把GPU的操作转到CPU上，生成位图缓存，直接读取复用。
 
 优点：
 CALayer会被光栅化为bitmap，shadows、cornerRadius等效果会被缓存。
 缺点：
 更新已经光栅化的layer，会造成离屏渲染。
 bitmap超过100ms没有使用就会移除。
 受系统限制，缓存的大小为 2.5X Screen Size。
 shouldRasterize适合静态页面显示，动态页面会增加开销。如果设置了shouldRasterize为YES，那也要记住设置rasterizationScale为contentsScale。
 
 圆角是否产生离屏渲染
 单层内容需要添加圆角和裁切，所以可以不需要用到离屏渲染技术。
 但如果加上了背景色、边框或其他有图像内容的图层，就会产生为 多层 添加圆角和裁切，所以还是会触发离屏渲染
 
 异步渲染
 在子线程绘制，主线程渲染。例如 VVeboTableViewDemo
 
 
 
 */

@implementation IBController9

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.images.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"cellID";
    IBTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    cell.imgView.image = nil;
    if (!cell) {
        cell = [[IBTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    [self setCell:cell index:indexPath];
    return cell;
}

- (void)setCell:(IBTableViewCell *)cell index:(NSIndexPath *)path {
    if (self.tableView.dragging == NO && self.tableView.decelerating == NO) {
        [cell.imgView sd_setImageWithURL:[NSURL URLWithString:self.images[path.row]] placeholderImage:nil options:SDWebImageCacheMemoryOnly];
    }
}

#pragma mark - scrollview delegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    //tableview停止滚动，开始加载图像
//    if (!decelerate)
//    {
//        NSLog(@"123");
//        [self loadImageForCellRows];
//    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //如果tableview停止滚动，开始加载图像
    NSLog(@"123");
    [self loadImageForCellRows];
}

- (void)loadImageForCellRows {
    NSArray *cells = [self.tableView indexPathsForVisibleRows];
    for (NSIndexPath *indexPath in cells) {
        IBTableViewCell *cell = (IBTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        [cell.imgView sd_setImageWithURL:[NSURL URLWithString:self.images[indexPath.row]] placeholderImage:nil options:SDWebImageCacheMemoryOnly];
    }
}


- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
        _tableView.rowHeight = 250;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (NSArray *)images {
    if (!_images) {
        _images = @[@"https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=1063018429,974188825&fm=200&gp=0.jpg",
                    @"https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=860353018,1603281892&fm=200&gp=0.jpg",
                    @"http://pic21.photophoto.cn/20111106/0020032891433708_b.jpg",
                    @"http://pic21.photophoto.cn/20111011/0006019003288114_b.jpg",
                    @"https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=2446086228,1541171154&fm=200&gp=0.jpg",
                    @"http://img.taopic.com/uploads/allimg/140804/240388-140P40P33417.jpg",
                    @"http://image.tupian114.com/20130521/15235862.jpg",
                    @"http://img.taopic.com/uploads/allimg/120819/214833-120Q919363810.jpg",
                    @"http://pic.58pic.com/58pic/14/27/40/58PIC6d58PICy68_1024.jpg",
                    @"http://f9.topitme.com/9/37/30/11224703137bb30379o.jpg",
                    @"https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=2784432848,511077205&fm=27&gp=0.jpg",
                    @"https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=188686010,320059973&fm=200&gp=0.jpg",
                    @"http://img3.duitang.com/uploads/item/201510/11/20151011223210_wxjQy.jpeg",
                    @"http://pic2.16pic.com/00/54/72/16pic_5472673_b.jpg",
                    @"https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=2653692883,494411913&fm=200&gp=0.jpg",
                    @"http://pic27.nipic.com/20130220/11588199_085535217129_2.jpg",
                    @"https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=1645710608,4064735852&fm=27&gp=0.jpg",
                    @"https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=1772973563,1603262817&fm=200&gp=0.jpg",
                    @"https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=4280515503,1510438976&fm=200&gp=0.jpg",
                    @"https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=3502465005,4153501499&fm=200&gp=0.jpg",
                    @"https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=238640327,3002157289&fm=200&gp=0.jpg",
                    @"https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=794351823,4243730852&fm=200&gp=0.jpg",
                    @"https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=1135159015,1853694453&fm=200&gp=0.jpg",
                    @"https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=1845261648,868382737&fm=200&gp=0.jpg",
                    @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2272679418,3405114051&fm=200&gp=0.jpg",
                    @"https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=2284109894,2856524976&fm=27&gp=0.jpg",
                    @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=1315891417,203781640&fm=27&gp=0.jpg",
                    @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2143735751,1143068346&fm=27&gp=0.jpg",
                    @"https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=1856111234,850015616&fm=200&gp=0.jpg",
                    @"https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=3524001812,1543361664&fm=200&gp=0.jpg"];
    }
    return _images;
}
- (void)dealloc {
    NSLog(@"%s",__func__);
}

@end
