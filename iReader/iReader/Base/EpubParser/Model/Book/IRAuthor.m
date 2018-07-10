//
//  IRAuthor.m
//  iReader
//
//  Created by zouzhiyong on 2018/3/15.
//  Copyright © 2018年 zouzhiyong. All rights reserved.
//

#import "IRAuthor.h"

@implementation IRAuthor

+ (instancetype)authorWithName:(NSString *)name
{
    IRAuthor *author = [[self alloc] init];
    author.name = name;
    return author;
}

@end
