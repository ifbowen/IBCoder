//
//  NSObject+debugDescription.m
//  ModelLog
//
//  Created by BowenCoder on 2017/8/3.
//  Copyright © 2017年 BowenCoder. All rights reserved.
//

#import "NSObject+Log.h"
#import <objc/runtime.h>

@implementation NSObject (Log)

//遍历model属性并打印
- (NSDictionary *)ib_description
{
    //初始化一个字典
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    //得到当前Class的所有属性
    uint count;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    for (int i = 0; i < count; i++) {//循环并使用KVC得到每个属性的值
        objc_property_t property = properties[i];
        id name = @(property_getName(property));
        id value = [self valueForKey:name] ? : [NSNull null];//默认值为nil字符串
        [dictionary setObject:value forKey:name]; //装载到字典中
    }
    NSDictionary *classInfo = @{
                                @"className": NSStringFromClass(self.class),
                                @"memory"   : [NSString stringWithFormat:@"%p",self]
                                };
    [dictionary setObject:classInfo forKey:@"classInfo"];
    //释放
    return dictionary;
}

@end


@implementation NSDictionary (Log)

- (NSString *)ib_description {

    return [self ib_descriptionWithLocale:nil indent:0];
}

- (NSString *)ib_descriptionWithLocale:(id)locale indent:(NSUInteger)level {
    
    NSMutableString *desc = [NSMutableString string];
    
    NSMutableString *tab = [NSMutableString string];
    for (NSUInteger i = 0; i < level; ++i) {
        [tab appendString:@"\t"];
    }
    
    [desc appendString:@"\t{\n"];
    
    for (id key in self.allKeys) {
        id obj = [self objectForKey:key];
        
        if ([obj isKindOfClass:[NSString class]]) {//字符串
            [desc appendFormat:@"%@\t%@ = \"%@\",\n", tab, key, obj];
            
        } else if ([obj isKindOfClass:[NSNull class]] || //空值，数字
                   [obj isKindOfClass:[NSNumber class]]) {
            [desc appendFormat:@"%@\t%@ = %@,\n", tab, key, obj];

        } else if ([obj isKindOfClass:[NSArray class]]      ||
                   [obj isKindOfClass:[NSDictionary class]] ||
                   [obj isKindOfClass:[NSSet class]]) { //集合
            [desc appendFormat:@"%@\t%@ = %@,\n", tab, key, [obj ib_descriptionWithLocale:locale indent:level + 1]];
        } else if ([obj isKindOfClass:[NSData class]]) { //二进制
            
            NSError *error = nil;
            NSObject *result =  [NSJSONSerialization JSONObjectWithData:obj
                                                                options:NSJSONReadingMutableContainers
                                                                  error:&error];
            if (error == nil && result != nil) {
                if ([result isKindOfClass:[NSDictionary class]]
                    || [result isKindOfClass:[NSArray class]]
                    || [result isKindOfClass:[NSSet class]]) {
                    NSString *str = [((NSDictionary *)result) ib_descriptionWithLocale:locale indent:level + 1];
                    [desc appendFormat:@"%@\t%@ = %@,\n", tab, key, str];
                } else if ([obj isKindOfClass:[NSString class]]) {
                    [desc appendFormat:@"%@\t%@ = \"%@\",\n", tab, key, result];
                }
            } else {
                @try {
                    NSString *str = [[NSString alloc] initWithData:obj encoding:NSUTF8StringEncoding];
                    if (str != nil) {
                        [desc appendFormat:@"%@\t%@ = \"%@\",\n", tab, key, str];
                    } else {
                        [desc appendFormat:@"%@\t%@ = %@,\n", tab, key, obj];
                    }
                }
                @catch (NSException *exception) {
                    [desc appendFormat:@"%@\t%@ = %@,\n", tab, key, obj];
                }
            }
        } else { //自定义对象
            NSObject *customObj = obj;
            NSMutableDictionary *dict = customObj.ib_description.mutableCopy;
            
            NSString *className = [dict valueForKeyPath:@"classInfo.className"];
            NSString *memory = [dict valueForKeyPath:@"classInfo.memory"];
            NSMutableString *jointKey = [NSMutableString stringWithFormat:@"%@<%@:%@>",key,className,memory];
            [dict removeObjectForKey:@"classInfo"];
            [desc appendFormat:@"%@\t%@ = %@,\n", tab, jointKey, [dict ib_descriptionWithLocale:locale indent:level+1]];
        }
    }
    
    [desc appendFormat:@"%@}", tab];
    
    return desc;
}

@end

@implementation NSArray (Log)

- (NSString *)ib_description {

    return [self ib_descriptionWithLocale:nil indent:0];
}

- (NSString *)ib_descriptionWithLocale:(id)locale indent:(NSUInteger)level {
    
    NSMutableString *desc = [NSMutableString string];
    
    NSMutableString *tab = [NSMutableString string];
    for (NSUInteger i = 0; i < level; ++i) {
        [tab appendString:@"\t"];
    }
    
    [desc appendString:@"\t(\n"];
    
    for (id obj in self) {
        if ([obj isKindOfClass:[NSString class]]) { //字符串
            [desc appendFormat:@"%@\t\"%@\",\n", tab, obj];

        } else if ([obj isKindOfClass:[NSNull class]]   || //空值，数字
                   [obj isKindOfClass:[NSNumber class]]) {
            [desc appendFormat:@"%@\t%@,\n", tab, obj];
            
        } else if ([obj isKindOfClass:[NSDictionary class]] ||
                   [obj isKindOfClass:[NSArray class]]      ||
                   [obj isKindOfClass:[NSSet class]]) {
            NSString *str = [obj ib_descriptionWithLocale:locale indent:level + 1];
            [desc appendFormat:@"%@\t%@,\n", tab, str];
            
        }  else if ([obj isKindOfClass:[NSData class]]) {
            
            NSError *error = nil;
            NSObject *result =  [NSJSONSerialization JSONObjectWithData:obj
                                                                options:NSJSONReadingMutableContainers
                                                                  error:&error];
            if (error == nil && result != nil) {
                if ([result isKindOfClass:[NSDictionary class]] ||
                    [result isKindOfClass:[NSArray class]]      ||
                    [result isKindOfClass:[NSSet class]]) {
                    NSString *str = [((NSDictionary *)result) ib_descriptionWithLocale:locale indent:level + 1];
                    [desc appendFormat:@"%@\t%@,\n", tab, str];
                } else if ([obj isKindOfClass:[NSString class]]) {
                    [desc appendFormat:@"%@\t\"%@\",\n", tab, result];
                }
            } else {
                @try {
                    NSString *str = [[NSString alloc] initWithData:obj encoding:NSUTF8StringEncoding];
                    if (str != nil) {
                        [desc appendFormat:@"%@\t\"%@\",\n", tab, str];
                    } else {
                        [desc appendFormat:@"%@\t%@,\n", tab, obj];
                    }
                }
                @catch (NSException *exception) {
                    [desc appendFormat:@"%@\t%@,\n", tab, obj];
                }
            }
        } else {
            NSObject *customObj = obj;
            NSMutableDictionary *dict = customObj.ib_description.mutableCopy;
            NSString *className = [dict valueForKeyPath:@"classInfo.className"];
            NSString *memory = [dict valueForKeyPath:@"classInfo.memory"];
            NSMutableString *key = [NSMutableString stringWithFormat:@"<%@:%@>",className,memory];
            [dict removeObjectForKey:@"classInfo"];            
            [desc appendFormat:@"%@\t%@ = %@,\n", tab, key, [dict ib_descriptionWithLocale:locale indent:level+1]];
        }
    }
    [desc appendFormat:@"%@)", tab];
    return desc;
}

@end

























