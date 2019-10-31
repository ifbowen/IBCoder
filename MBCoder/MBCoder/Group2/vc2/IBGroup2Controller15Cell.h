//
//  IBGroup2Controller15Cell.h
//  MBCoder
//
//  Created by Bowen on 2019/10/31.
//  Copyright © 2019 inke. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MBFeedEntity : NSObject

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@property (nonatomic, copy, readonly) NSString *identifier;
@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, copy, readonly) NSString *content;
@property (nonatomic, copy, readonly) NSString *username;
@property (nonatomic, copy, readonly) NSString *time;
@property (nonatomic, copy, readonly) NSString *imageName;

@end

@interface IBGroup2Controller15Cell : UITableViewCell

@property (nonatomic, strong) MBFeedEntity *entity;

@end

NS_ASSUME_NONNULL_END
