//
//  IBController2.h
//  IBCoder1
//
//  Created by Bowen on 2018/4/24.
//  Copyright © 2018年 BowenCoder. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PersonDelegate <NSObject>

@optional

- (void)personNameChange;

@end

@interface Person : NSObject

@property (nonatomic,copy) NSString *name;
@property (nonatomic,assign) int age;
@property (nonatomic,copy) NSString *sex;

@property (nonatomic, assign) id<PersonDelegate> delegate;

@end

typedef void(^Block)(NSString *name);

@interface IBController2 : UIViewController

@property (nonatomic, copy) Block block;

@end
