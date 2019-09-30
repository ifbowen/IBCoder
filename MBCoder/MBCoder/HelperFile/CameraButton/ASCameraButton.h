//
//  ASCameraButton.h
//  Assassin
//
//  Created by Bowen on 2018/9/29.
//  Copyright © 2018年 inke. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CameraHandler)(void);

@interface ASCameraButton : UIButton

/** 拍摄时长 默认15 */
@property (nonatomic, assign) NSTimeInterval timeDuration;
/** 开始回调 */
@property (nonatomic,   copy) CameraHandler startHandle;
/** 结束回调 */
@property (nonatomic,   copy) CameraHandler endHandle;

/**
 重置状态 还原到最初
 */
- (void)resetState;


@end
