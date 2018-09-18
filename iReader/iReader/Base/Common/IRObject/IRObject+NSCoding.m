//
//  IRObject+NSCoding.m
//  iReader
//
//  Created by zzyong on 2018/9/18.
//  Copyright © 2018年 zouzhiyong. All rights reserved.
//

#import "IRObject+NSCoding.h"

@implementation IRObject (NSCoding)

- (instancetype)initWithCoder:(NSCoder *)coder
{
    for (NSString *key in self.class.propertyKeys) {
        id value = [coder decodeObjectForKey:key];
        if (!value) {
            continue;
        }
        [self setValue:value forKeyPath:key];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    for (NSString *key in self.class.propertyKeys) {
        id value = [self valueForKeyPath:key];
        if (!value) {
            return;
        }
        [coder encodeObject:value forKey:key];
    }
}

- (nullable id)valueForUndefinedKey:(NSString *)key
{
    return nil;
}

- (void)setValue:(nullable id)value forUndefinedKey:(NSString *)key
{
    // do nothing
}

@end
