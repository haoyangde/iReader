//
//  NSDictionary+Safe.h
//  iReader
//
//  Created by zzyong on 2018/6/5.
//  Copyright © 2018年 zzyong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Safe)

- (id)safeObjectForKey:(id)aKey;

@end

@interface NSMutableDictionary (Safe)

- (void)safeRemoveObjectForKey:(id)aKey;

- (void)safeSetObject:(id)anObject forKey:(id)aKey;

@end
