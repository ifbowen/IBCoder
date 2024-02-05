//
//  MBProducerConsumerQueue.m
//  MBCoder
//
//  Created by wenbo on 2024/2/1.
//  Copyright © 2024 inke. All rights reserved.
//

#import "MBProducerConsumerQueue.h"

@interface MBProducerConsumerQueue ()

@property (nonatomic, strong) NSCondition *condition;
@property (nonatomic, strong) NSOperationQueue *producerQueue;
@property (nonatomic, strong) NSOperationQueue *consumerQueue;
@property (nonatomic, strong) NSMutableArray *products;

@end

@implementation MBProducerConsumerQueue

- (void)scheduleProducerQueue {
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        [self.condition lock];
        while (self.products.count >= 3) {
            NSLog(@"图片数量已经生产完");
            [self.condition wait];
        }
        UIImage *image = [[UIImage alloc] init];
        [self.products addObject:image];
        NSLog(@"生产图片个数:%lu", (unsigned long)self.products.count);
        [self.condition signal];
        [self.condition unlock];
    }];
    [self.producerQueue addOperation:operation];
}

- (void)scheduleConsumerQueue {
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        [self.condition lock];
        while (self.products.count == 0) {
            NSLog(@"图片已经消费完");
            [self.condition wait];
        }
        [self.products removeObjectAtIndex:0];
        NSLog(@"剩余图片个数:%lu", (unsigned long)self.products.count);
        [self.condition signal];
        [self.condition unlock];
    }];
    [self.consumerQueue addOperation:operation];
}

#pragma mark - getter

- (NSCondition *)condition {
    if (!_condition) {
        _condition = [[NSCondition alloc] init];
    }
    return _condition;
}

- (NSOperationQueue *)producerQueue {
    if (!_producerQueue) {
        _producerQueue = [[NSOperationQueue alloc] init];
        [_producerQueue setMaxConcurrentOperationCount:2];
    }
    return _producerQueue;
}

- (NSOperationQueue *)consumerQueue {
    if (!_consumerQueue) {
        _consumerQueue = [[NSOperationQueue alloc] init];
        [_consumerQueue setMaxConcurrentOperationCount:2];
    }
    return _consumerQueue;
}

- (NSMutableArray *)products {
    if (!_products) {
        _products = [[NSMutableArray alloc] initWithCapacity:3];
    }
    return _products;
}


@end
