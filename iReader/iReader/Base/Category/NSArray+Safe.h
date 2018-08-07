//
//  NSArray+Safe.h
//  iReader
//
//  Created by zzyong on 2018/6/5.
//  Copyright © 2018年 zzyong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Safe)

- (id)safeObjectAtIndex:(NSUInteger)index;

@end

@interface NSMutableArray (Safe)

- (void)safeAddObject:(id)anObject;

- (void)safeInsertObject:(id)anObject atIndex:(NSUInteger)index;

- (void)safeRemoveObjectAtIndex:(NSUInteger)index;

- (void)safeReplaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject;

@end
