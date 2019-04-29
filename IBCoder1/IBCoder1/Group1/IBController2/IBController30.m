//
//  IBController30.m
//  IBCoder1
//
//  Created by Bowen on 2018/5/28.
//  Copyright © 2018年 BowenCoder. All rights reserved.
//

#import "IBController30.h"
#import "IBCoreSpotlight.h"

@interface Car : NSObject <IBCoreSportlight>

@property (nonatomic, copy) NSString *sid;
@property (nonatomic, copy) NSString *info;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSNumber *rate;

@end


@implementation Car

- (NSString *)cs_contentDescription {
    return self.info;
}

- (NSString *)cs_identifier {
    return self.sid;
}

- (NSString *)cs_title {
    return self.name;
}

- (NSString *)cs_domain {
    return NSStringFromClass(self.class);
}

- (NSNumber *)cs_rating {
    return self.rate;
}

@end

@interface IBController30 ()

@end

@implementation IBController30

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"CoreSpotlight";
    [self initData];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [IBCoreSpotlight removeAllObjects];
}

- (void)initData {
    
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 0; i < 5; i++) {
        Car *car = [[Car alloc] init];
        car.sid = [NSString stringWithFormat:@"1000%d",i];
        car.info = @"奔驰-年轻没有标准答案！新生代车型携手NINE PERCENT，年轻够任性，一起放开活！";
        car.name = @"梅赛德斯";
//        car.rate = [NSNumber numberWithInt:i];
        [arr addObject:car];
    }
    [IBCoreSpotlight insertObjects:arr];

}

@end
