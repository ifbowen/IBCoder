//
//  IBCoreSpotlight.h
//  IBCoder1
//
//  Created by Bowen on 2018/5/28.
//  Copyright © 2018年 BowenCoder. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IBCoreSportlight <NSObject>

#pragma mark - CSGeneral
@required
- (NSString *)cs_title;
- (NSString *)cs_contentDescription;
- (NSString *)cs_identifier;
- (NSString *)cs_domain;

@optional
- (NSData *)cs_thumbnailData;
- (NSNumber *)cs_rating;

//...
#pragma mark - CSMedia
#pragma mark - CSMusic
#pragma mark - CSDocuments
#pragma mark - CSImages
#pragma mark - CSMessaging

@end

/*
 Core Spotlight框架用来索引应用内的内容。它创建的索引存储在设备上，不与Apple共享，也不能被其他应用或者设备访问。
 Apple的指南中特别提到Core Spotlight创建的索引最好在几千的数量级别之下。索引太多很有可能会带来性能问题。
 */

@interface IBCoreSpotlight : NSObject

+ (void)insertObjects:(NSArray *)array;

+ (void)removeObjectsUsingIdentifier:(NSArray *)array;

+ (void)removeObjectsUsingDomain:(NSArray *)array;

+ (void)removeAllObjects;

@end
