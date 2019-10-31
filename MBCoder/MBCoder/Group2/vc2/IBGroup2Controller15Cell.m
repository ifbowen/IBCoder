//
//  IBGroup2Controller15Cell.m
//  MBCoder
//
//  Created by Bowen on 2019/10/31.
//  Copyright © 2019 inke. All rights reserved.
//

#import "IBGroup2Controller15Cell.h"
#import "Masonry.h"
#import "UIMacros.h"

@implementation MBFeedEntity

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = super.init;
    if (self) {
        _identifier = [self uniqueIdentifier];
        _title = dictionary[@"title"];
        _content = dictionary[@"content"];
        _username = dictionary[@"username"];
        _time = dictionary[@"time"];
        _imageName = dictionary[@"imageName"];
    }
    return self;
}

- (NSString *)uniqueIdentifier
{
    static NSInteger counter = 0;
    return [NSString stringWithFormat:@"unique-id-%@", @(counter++)];
}

@end

@interface IBGroup2Controller15Cell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIImageView *contentImageView;
@property (nonatomic, strong) UILabel *usernameLabel;
@property (nonatomic, strong) UILabel *timeLabel;

@end

@implementation IBGroup2Controller15Cell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupCell];
    }
    return self;
}

- (void)setupCell
{
    // Fix the bug in iOS7 - initial constraints warning
    self.bounds = [UIScreen mainScreen].bounds;

    self.contentView.backgroundColor = randomColor;
    
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(@0).offset(10);
    }];
    
    [self.contentView addSubview:self.contentLabel];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0).offset(10);
        make.right.equalTo(@0).offset(-10);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
    }];
    
    [self.contentView addSubview:self.contentImageView];
    [self.contentImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0).offset(10);
        make.top.equalTo(self.contentLabel.mas_bottom).offset(15);
    }];
    
    [self.contentView addSubview:self.usernameLabel];
    [self.usernameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0).offset(10);
        make.bottom.equalTo(@0).offset(-10);
    }];
    
    [self.contentView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@0).offset(-10);
        make.top.equalTo(self.contentImageView.mas_bottom).offset(5);
        make.bottom.equalTo(@0).offset(-10);
    }];

}

- (void)setEntity:(MBFeedEntity *)entity
{
    _entity = entity;
    
    self.titleLabel.text = entity.title;
    self.contentLabel.text = entity.content;
    self.contentImageView.image = entity.imageName.length > 0 ? [UIImage imageNamed:entity.imageName] : nil;
    self.usernameLabel.text = entity.username;
    self.timeLabel.text = entity.time;
    
    if (!entity.imageName.length) {
        [self.contentImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentLabel.mas_bottom);
        }];
    } else {
        [self.contentImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentLabel.mas_bottom).offset(15);
        }];
    }
}

// If you are not using auto layout, override this method, enable it by setting
// "fd_enforceFrameLayout" to YES.
- (CGSize)sizeThatFits:(CGSize)size {
    CGFloat totalHeight = 0;
    totalHeight += [self.titleLabel sizeThatFits:size].height;
    totalHeight += [self.contentLabel sizeThatFits:size].height;
    totalHeight += [self.contentImageView sizeThatFits:size].height;
    totalHeight += [self.usernameLabel sizeThatFits:size].height;
    totalHeight += 50; // margins
    return CGSizeMake(size.width, totalHeight);
}

#pragma mark - getter

- (UILabel *)titleLabel {
    if(!_titleLabel){
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.backgroundColor = [UIColor redColor];
        _titleLabel.textColor = UIColor.blackColor;
    }
    return _titleLabel;
}

- (UILabel *)contentLabel {
    if(!_contentLabel){
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textColor = UIColor.blackColor;
        _contentLabel.backgroundColor = [UIColor orangeColor];
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
}

- (UIImageView *)contentImageView {
    if(!_contentImageView){
        _contentImageView = [[UIImageView alloc] init];
        _contentImageView.backgroundColor = [UIColor purpleColor];
    }
    return _contentImageView;
}

- (UILabel *)usernameLabel {
    if(!_usernameLabel){
        _usernameLabel = [[UILabel alloc] init];
        _usernameLabel.textColor = UIColor.blackColor;
        _usernameLabel.backgroundColor = [UIColor blueColor];
    }
    return _usernameLabel;
}

- (UILabel *)timeLabel {
    if(!_timeLabel){
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = UIColor.blackColor;
        _timeLabel.backgroundColor = [UIColor blueColor];
    }
    return _timeLabel;
}


@end
