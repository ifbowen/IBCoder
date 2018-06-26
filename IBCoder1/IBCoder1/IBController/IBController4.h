//
//  IBController4.h
//  IBCoder1
//
//  Created by Bowen on 2018/4/26.
//  Copyright © 2018年 BowenCoder. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Student : NSObject

@property (nonatomic, copy) void(^pblock)(void);
@property (nonatomic, strong) NSMutableArray<void(^)(void)> *arr;

+(instancetype)shareInstance;

@end


@interface IBController4 : UIViewController


@end
