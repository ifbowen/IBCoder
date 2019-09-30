//
//  IBGroup2Controller4.h
//  IBCoder1
//
//  Created by Bowen on 2019/5/28.
//  Copyright © 2019 BowenCoder. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <extobjc.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MyProtocol <NSObject>

@concrete
- (void)eat;

@end

@concreteprotocol(MyProtocol)
- (void)eat
{
    NSLog(@"%s", __func__);
}

@end


@interface IBGroup2Controller4 : UIViewController<MyProtocol>

@end

@interface IBGroup2Controller4 (ext)


- (void)sleep;

@end

@safecategory(IBGroup2Controller4, ext)

- (void)sleep
{
    NSLog(@"%s", __func__);
}

@end

@interface IBGroup2Controller4 (ext1)

@property (nonatomic, strong) id testNonatomicRetainProperty;

@end

NS_ASSUME_NONNULL_END
