//
//  IBGroup2Controller2.m
//  IBCoder1
//
//  Created by Bowen on 2019/9/23.
//  Copyright © 2019 BowenCoder. All rights reserved.
//

#import "IBGroup2Controller7.h"

@interface IBGroup2Controller7 ()

@end

@implementation IBGroup2Controller7

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(recognizer)];
    [self.view addGestureRecognizer:recognizer];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleMapTap)];
    [self.view addGestureRecognizer:singleTap];
    
    [singleTap requireGestureRecognizerToFail:recognizer];
    
}

- (void)recognizer
{
    NSLog(@"recognizer");
}

- (void)handleMapTap
{
    NSLog(@"handleMapTap");
}

@end
