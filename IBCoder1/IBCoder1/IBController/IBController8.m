//
//  IBController8.m
//  IBCoder1
//
//  Created by Bowen on 2018/5/3.
//  Copyright © 2018年 BowenCoder. All rights reserved.
//

#import "IBController8.h"
#import "UIImageView+WebCache.h"
#import "UIView+WebCache.h"
#import "IBRunLoopLoad.h"

#define  ShowImageTableViewReusableIdentifier @"ShowImageTableViewReusableIdentifier"
#define ImageWidth 50

@interface IBRunLoopLoadCell ()

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *topLbl;
@property (nonatomic, strong) UILabel *bottomLbl;
@property (nonatomic, strong) NSIndexPath *indexPath;

@end

@implementation IBRunLoopLoadCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupCell];
    }
    return self;
}

- (void)setupCell {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 300, 25)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor redColor];
    label.font = [UIFont boldSystemFontOfSize:13];
    [self.contentView addSubview:label];
    self.topLbl = label;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 30, 200, 65)];
    imageView.backgroundColor = [UIColor lightGrayColor];
//    imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imgView = imageView;
    [self.contentView addSubview:imageView];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(5, 99, 300, 35)];
    label1.lineBreakMode = NSLineBreakByWordWrapping;
    label1.numberOfLines = 0;
    label1.backgroundColor = [UIColor clearColor];
    label1.textColor = [UIColor colorWithRed:0 green:100.f/255.f blue:0 alpha:1];
    label1.font = [UIFont boldSystemFontOfSize:13];
    [self.contentView addSubview:label1];
    self.bottomLbl = label1;
    
}

- (void)setLblText:(NSInteger)index {
    self.topLbl.text = [NSString stringWithFormat:@"%zd - Drawing index is top priority", index + 1];
    self.bottomLbl.text = [NSString stringWithFormat:@"%zd - Drawing large image is low priority. Should be distributed into different run loop passes.", index + 1];
}

- (void)setImageUrl:(NSString *)url {
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil options:SDWebImageLowPriority|SDWebImageCacheMemoryOnly];
}

@end


@interface IBController8 ()<UITableViewDelegate,UITableViewDataSource>

@property (strong,nonatomic) UITableView* showImageTableView;
@property (nonatomic, copy) NSArray *images;

@end

@implementation IBController8


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.showImageTableView registerClass:[IBRunLoopLoadCell class] forCellReuseIdentifier:ShowImageTableViewReusableIdentifier];
    [self.view addSubview:self.showImageTableView];
}

//懒加载
-(UITableView *)showImageTableView{
    if (!_showImageTableView) {
        _showImageTableView = [[UITableView alloc] initWithFrame:self.view.frame];
        _showImageTableView.delegate = self;
        _showImageTableView.dataSource = self;
    }
    
    return _showImageTableView;
}

//数据源代理
#pragma mark- UITableViewDelegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    IBRunLoopLoadCell* cell = [tableView dequeueReusableCellWithIdentifier:ShowImageTableViewReusableIdentifier];
    cell.imgView.image = nil;
    [cell setLblText:indexPath.row];
    cell.indexPath = indexPath;
    [[IBRunLoopLoad sharedRunLoop] addTask:^{
        if ([cell.indexPath isEqual:indexPath]) {
            [cell setImageUrl:self.images[indexPath.row]];
        }
    }];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.images.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 135;
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

- (void)dealloc
{
    NSLog(@"%s",__func__);
}
@end
