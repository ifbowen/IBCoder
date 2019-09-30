//
//  GCDMacros.h
//  IBCoder1
//
//  Created by Bowen on 2018/6/8.
//  Copyright © 2018年 BowenCoder. All rights reserved.
//

/**
 *  Inserts code that executes a block only once, regardless of how many times the macro is invoked.
 *
 *  @param block The block to execute once.
 */
#ifndef GCDOnce
#define GCDOnce(block) \
{ \
  static dispatch_once_t onceToken; \
  dispatch_once(&onceToken, block); \
}
#endif

/**
 *  Inserts code that declares, creates, and returns a single instance, regardless of how many times the macro is invoked.
 *
 *  @param block A block that creates and returns the instance value.
 */
#ifndef GCDSharedInstance
#define GCDSharedInstance(block) \
{ \
  static dispatch_once_t onceToken; \
  static id sharedInstance = nil; \
  dispatch_once(&onceToken, ^{ sharedInstance = block(); }); \
  return sharedInstance; \
}
#endif
