//
//  IBController10.h
//  IBCoder1
//
//  Created by Bowen on 2018/5/8.
//  Copyright © 2018年 BowenCoder. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IBCell : UITableViewCell

@property (nonatomic, strong) UIImageView *imgView;

- (void)draw:(NSString *)url;
- (void)clear;
- (void)releaseMemory;

@end

@interface IBController10 : UIViewController

@end
