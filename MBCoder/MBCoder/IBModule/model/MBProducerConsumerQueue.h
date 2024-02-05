//
//  MBProducerConsumerQueue.h
//  MBCoder
//
//  Created by wenbo on 2024/2/1.
//  Copyright © 2024 inke. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 生产者和消费者是一种经典的并发编程模式，用于解决多线程环境下生产和消费数据的问题。在该模式中，生产者负责生成数据并将其放入共享的缓冲区，而消费者则负责从缓冲区中取出数据并进行处理。
 生产者和消费者模式的主要目标是实现生产者和消费者之间的解耦，使它们可以独立地进行操作，而不需要直接相互依赖。这样可以提高系统的并发性和吞吐量，同时避免了生产者和消费者之间的竞争条件和资源争用。
 在该模式中，生产者和消费者之间通常通过一个共享的缓冲区进行通信。生产者将生成的数据放入缓冲区，而消费者则从缓冲区中取出数据进行消费。当缓冲区为空时，消费者会等待生产者生成数据；当缓冲区已满时，生产者会等待消费者消费数据。这样可以确保生产者和消费者之间的同步和协调。
 生产者和消费者模式可以应用于各种场景，例如多线程编程、并发网络通信、消息队列等。它提供了一种有效的方式来处理并发环境下的数据交换和处理，确保数据的正确性和一致性。
 */

/// 生产者，消费者队列
@interface MBProducerConsumerQueue : NSObject

- (void)scheduleProducerQueue;

- (void)scheduleConsumerQueue;

@end

NS_ASSUME_NONNULL_END
