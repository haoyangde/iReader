//
//  NSDictionary+Safe.m
//  iReader
//
//  Created by zzyong on 2018/6/5.
//  Copyright © 2018年 zzyong. All rights reserved.
//

#import "NSDictionary+Safe.h"

@implementation NSDictionary (IR_Safe)

- (id)safeObjectForKey:(id)aKey
{
    if (DEBUG) {
        return [self objectForKey:aKey];
    } else {
        if (aKey) {
           return [self objectForKey:aKey];
        }
        return nil;
    }
}

@end

@implementation NSMutableDictionary (IR_Safe)

- (void)safeRemoveObjectForKey:(id)aKey
{
    if (DEBUG) {
        [self removeObjectForKey:aKey];
    } else {
        if (aKey) {
            [self removeObjectForKey:aKey];
        }
    }
}

- (void)safeSetObject:(id)anObject forKey:(id)aKey
{
    if (DEBUG) {
        [self setObject:anObject forKey:aKey];
    } else {
        if (aKey && anObject) {
            [self setObject:anObject forKey:aKey];
        }
    }
}

@end
