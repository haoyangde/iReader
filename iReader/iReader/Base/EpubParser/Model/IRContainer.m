//
//  IRContainer.m
//  iReader
//
//  Created by zzyong on 2018/7/9.
//  Copyright © 2018年 zouzhiyong. All rights reserved.
//

#import "IRContainer.h"

@implementation IRContainer

+ (instancetype)containerWithFullPath:(NSString *)fullPath mediaType:(IRMediaType *)mediaType
{
    IRContainer *container = [[self alloc] init];
    container.fullPath = fullPath;
    container.mediaType = mediaType;
    
    return container;
}

@end
