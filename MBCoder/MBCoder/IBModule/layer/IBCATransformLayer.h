//
//  IBCATransformLayer.h
//  IBCoder1
//
//  Created by Bowen on 2018/6/7.
//  Copyright © 2018年 BowenCoder. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface IBCATransformLayer : CATransformLayer

- (CALayer *)cubeWithTransform:(CATransform3D)transform;

@end
