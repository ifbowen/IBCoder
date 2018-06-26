//
//  IBVController20.m
//  IBCoder1
//
//  Created by Bowen on 2018/5/14.
//  Copyright © 2018年 BowenCoder. All rights reserved.
//

#import "IBController20.h"
#import "UIImageView+WebCache.h"

/*
 
 号外：苹果官方给出了一个下载高清大图的demo,内存消耗很低。感兴趣的朋友也可以看看：
 https://developer.apple.com/library/ios/samplecode/LargeImageDownsizing/Introduction/Intro.html
 
 */

@interface IBBigImageCell : UITableViewCell

@property (nonatomic, strong) UIImageView *imgView;

@end

@implementation IBBigImageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupCell];
    }
    return self;
}

- (void)setupCell {
    self.imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 5, 414, 245)];
    [self.contentView addSubview:self.imgView];
}

@end

@interface IBController20 ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *images;

@end

@implementation IBController20

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [[SDWebImageManager sharedManager] cancelAll];
    [[SDImageCache sharedImageCache] clearMemory];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.images.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"BigImageCellID";
    IBBigImageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    cell.imgView.image = nil;
    if (!cell) {
        cell = [[IBBigImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    //出现崩溃的时候使用(经测试没有出现内存飙升，网上显示在iOS7有问题)
//    [[SDImageCache sharedImageCache].config setShouldDecompressImages:NO]; //处理从硬盘读取时是否解压缩
//    [[SDWebImageDownloader sharedDownloader] setShouldDecompressImages:NO]; //处理下载完成时是否解压缩
    [cell.imgView sd_setImageWithURL:self.images[indexPath.row] placeholderImage:nil options:SDWebImageCacheMemoryOnly|SDWebImageScaleDownLargeImages progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        NSLog(@"%ld---%ld", receivedSize, expectedSize);
    } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        NSLog(@"%@---%@",imageURL, image);
    }];
    return cell;
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
        _images = @[@"http://down.699pic.com/photo/50074/2409.jpg?_upt=c63eb60a1526356734&_upd=500742409.jpg",
                    @"http://down.699pic.com/photo/50023/0577.jpg?_upt=00dab2a21526357156&_upd=500230577.jpg"];
    }
    return _images;
}


@end
