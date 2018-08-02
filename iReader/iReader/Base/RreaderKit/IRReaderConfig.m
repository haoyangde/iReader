//
//  IRReaderConfig.m
//  iReader
//
//  Created by zzyong on 2018/7/27.
//  Copyright © 2018年 zouzhiyong. All rights reserved.
//

#import "IRReaderConfig.h"

@implementation IRReaderConfig

+ (instancetype)sharedInstance
{
    static IRReaderConfig *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (CGFloat)commonFontSize
{
    return 15;
}

- (CGFloat)H1FontSize
{
    return 24;
}

- (CGFloat)H2FontSize
{
    return 22;
}

- (CGFloat)H3FontSize
{
    return 20;
}

- (CGSize)pageSize
{
    static CGSize pageSize;
    
    if (!(pageSize.width && pageSize.height)) {
        CGRect rect = [UIScreen mainScreen].bounds;
        CGFloat width  = MIN(CGRectGetWidth(rect), CGRectGetHeight(rect));
        CGFloat height = MAX(CGRectGetWidth(rect), CGRectGetHeight(rect));
        pageSize = CGSizeMake(width, height);
    }
    
    return pageSize;
}

@end
