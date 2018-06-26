//
//  IBCoreSpotlight.m
//  IBCoder1
//
//  Created by Bowen on 2018/5/28.
//  Copyright © 2018年 BowenCoder. All rights reserved.
//

#import "IBCoreSpotlight.h"
#import <CoreSpotlight/CoreSpotlight.h>

@interface NSObject (IBCoreSportlight)

@end

@implementation NSObject (IBCoreSportlight)

- (NSData *)cs_thumbnailData {
    return UIImagePNGRepresentation([UIImage imageNamed:@"AppIcon"]);
}

- (NSNumber *)cs_rating {
    return nil;
}

@end

@implementation IBCoreSpotlight

static void ib_performSafely(dispatch_block_t block) {
    
    if ([UIDevice currentDevice].systemVersion.floatValue > 9.0) {
        block();
    }
}

+ (void)insertObjects:(NSArray *)array {
    ib_performSafely(^{
        [[CSSearchableIndex defaultSearchableIndex] indexSearchableItems:[self _converts:array]completionHandler:^(NSError * _Nullable error) {
        }];
    });
}

+ (void)removeObjectsUsingIdentifier:(NSArray *)array {
    ib_performSafely(^{
        [[CSSearchableIndex defaultSearchableIndex] deleteSearchableItemsWithIdentifiers:[self _reverseIdentifier:array] completionHandler:^(NSError * _Nullable error) {
            
        }];
    });
    
}

+ (void)removeObjectsUsingDomain:(NSArray *)array {
    ib_performSafely(^{
        [[CSSearchableIndex defaultSearchableIndex] deleteSearchableItemsWithDomainIdentifiers:[self _reverseDomain:array] completionHandler:^(NSError * _Nullable error) {
            
        }];
    });
}

+ (void)removeAllObjects {
    ib_performSafely(^{
        [[CSSearchableIndex defaultSearchableIndex] deleteAllSearchableItemsWithCompletionHandler:^(NSError * _Nullable error) {
            
        }];
    });
}

+ (NSArray *)_converts:(NSArray *)array {
    
    NSMutableArray *temp = [NSMutableArray array];
    [array enumerateObjectsWithOptions:0 usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [temp addObject:[self _convert:obj]];
        
    }];
    return temp.copy;
}

+ (NSArray *)_reverseDomain:(NSArray *)array {
    NSMutableArray *domainArray = [NSMutableArray array];
    [array enumerateObjectsWithOptions:(NSEnumerationConcurrent) usingBlock:^(id<IBCoreSportlight>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *domian = [self _domainIdentifier:obj.cs_domain];
        if (![domainArray containsObject:domian]) {
            [domainArray addObject:domian];
        }
    }];
    
    return domainArray.copy;
}

+ (NSArray *)_reverseIdentifier:(NSArray *)array {
    
    NSMutableArray *identifierArray = [NSMutableArray array];
    [array enumerateObjectsWithOptions:(NSEnumerationConcurrent) usingBlock:^(id<IBCoreSportlight>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [identifierArray addObject:obj.cs_identifier];
    }];
    
    return identifierArray.copy;
}

+ (CSSearchableItem *)_convert:(id <IBCoreSportlight>)obj {
    
    NSAssert([obj conformsToProtocol:@protocol(IBCoreSportlight)], @"error invalid parameter (Class doesn't conform protocol IBCoreSportlight)");
    
    CSSearchableItemAttributeSet *as = [[CSSearchableItemAttributeSet alloc] initWithItemContentType:NSStringFromClass(obj.class)];
    
    as.title = obj.cs_title;
    as.contentDescription = obj.cs_contentDescription;
    as.thumbnailData = obj.cs_thumbnailData;
    as.rating = obj.cs_rating;
    as.keywords = [obj.cs_title componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    as.relatedUniqueIdentifier = [self _uniqueIdentifier:obj];
    
    CSSearchableItem *item = [[CSSearchableItem alloc] initWithUniqueIdentifier:as.relatedUniqueIdentifier domainIdentifier:[self _domainIdentifier:obj.cs_domain] attributeSet:as];

    return item;
}

+ (NSString *)_uniqueIdentifier:(id<IBCoreSportlight>)obj {
    return [NSString stringWithFormat:@"%@.%@",[self _domainIdentifier:obj.cs_domain],obj.cs_identifier];
}


+ (NSString *)_domainIdentifier:(NSString *)domain {
    return [NSString stringWithFormat:@"%@.%@",[NSBundle mainBundle].bundleIdentifier,domain];
}

@end
