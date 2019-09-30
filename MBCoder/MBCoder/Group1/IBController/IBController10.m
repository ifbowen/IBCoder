//
//  IBController9.m
//  IBCoder1
//
//  Created by Bowen on 2018/5/3.
//  Copyright © 2018年 BowenCoder. All rights reserved.
//

#import "IBController10.h"
#import "UIImageView+WebCache.h"
#import "UIView+WebCache.h"

#import "UIView+Ext.h"

@implementation IBCell{
    BOOL _drawed;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupCell];
    }
    return self;
}

- (void)setupCell {
    self.imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 414, 250)];
    [self.contentView addSubview:self.imgView];
}
//将主要内容绘制到图片上
- (void)draw:(NSString *)url{
    if (_drawed) {
        return;
    }
    _drawed = YES;
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil options:SDWebImageCacheMemoryOnly];
}

- (void)clear{
    if (!_drawed) {
        return;
    }
    _imgView.backgroundColor = [UIColor lightGrayColor];
    _imgView.image = nil;
    [_imgView sd_cancelCurrentImageLoad];
    _drawed = NO;
}

- (void)releaseMemory{

    [self clear];
    [super removeFromSuperview];
}


@end

//按需加载(优化了加载速度)
@interface IBController10 ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, copy) NSArray *images;
@property (strong,nonatomic) UITableView *tableView;

@end

@implementation IBController10 {
    NSMutableArray *_needLoadArr;
    BOOL            _scrollToToping;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _needLoadArr = [NSMutableArray array];
    [self.view addSubview:self.tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.images.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"IBController10";
    IBCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[IBCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    [self drawCell:cell withIndexPath:indexPath];
    return cell;
}

#pragma mark - scrollview delegate
//按需加载 - 如果目标行与当前行相差超过指定行数，只在目标滚动范围的前后指定3行加载。
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    NSLog(@"%lf---%lf",targetContentOffset->y,velocity.y);
    //targetContentOffset：停止后的contentOffset
    NSIndexPath *ip = [self.tableView indexPathForRowAtPoint:CGPointMake(0, targetContentOffset->y)];
    
    //当前可见第一行row的index
    NSIndexPath *cip = [[self.tableView indexPathsForVisibleRows] firstObject];
    
    //设置最小跨度，当滑动的速度很快，超过这个跨度时候执行按需加载
    NSInteger skipCount = 4;
    
    //快速滑动(跨度超过了4个cell)
    if (labs(cip.row-ip.row)>skipCount) {
        //某个区域里的单元格的indexPath
        NSArray *temp = [self.tableView indexPathsForRowsInRect:CGRectMake(0, targetContentOffset->y, self.tableView.width, self.tableView.height)];
        NSMutableArray *arr = [NSMutableArray arrayWithArray:temp];
        if (velocity.y<0) {
            //向上滚动
            NSIndexPath *indexPath = [temp lastObject];
            //超过倒数第3个
            if (indexPath.row+3<self.images.count) {
                [arr addObject:[NSIndexPath indexPathForRow:indexPath.row+1 inSection:0]];
                [arr addObject:[NSIndexPath indexPathForRow:indexPath.row+2 inSection:0]];
                [arr addObject:[NSIndexPath indexPathForRow:indexPath.row+3 inSection:0]];
            }
        } else {
            //向下滚动
            NSIndexPath *indexPath = [temp firstObject];
            //超过正数第3个
            if (indexPath.row>3) {
                [arr addObject:[NSIndexPath indexPathForRow:indexPath.row-3 inSection:0]];
                [arr addObject:[NSIndexPath indexPathForRow:indexPath.row-2 inSection:0]];
                [arr addObject:[NSIndexPath indexPathForRow:indexPath.row-1 inSection:0]];
            }
        }
        //添加arr里的内容到needLoadArr的末尾
        [_needLoadArr addObjectsFromArray:arr];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [_needLoadArr removeAllObjects];
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView{
    _scrollToToping = NO;
    [self loadContent];
}

- (void)drawCell:(IBCell *)cell withIndexPath:(NSIndexPath *)indexPath{
    
    [cell clear];
    //当前的cell的indexPath不在needLoadArr里面，不用绘制
    if (_needLoadArr.count>0&&[_needLoadArr indexOfObject:indexPath]==NSNotFound) {
        [cell clear];
        return;
    }
    if (_scrollToToping) {
        return;
    }
    [cell draw:self.images[indexPath.row]];
}

- (void)loadContent{
    if (_scrollToToping) {
        return;
    }
    if (self.tableView.indexPathsForVisibleRows.count<=0) {
        return;
    }
    if (self.tableView.visibleCells&&self.tableView.visibleCells.count>0) {
        for (id temp in [self.tableView.visibleCells copy]) {
            IBCell *cell = (IBCell *)temp;
            NSIndexPath *index = [self.tableView indexPathForCell:cell];
            [cell draw:self.images[index.row]];
        }
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
