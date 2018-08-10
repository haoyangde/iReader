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

- (CGFloat)textFontSize
{
    return 15;
}

- (CGSize)pageSize
{
    static CGSize pageSize;
    
    if (!(pageSize.width && pageSize.height)) {
        
        CGFloat edgeInset = [IRUIUtilites isIPhoneX] ? 70 : 20;
        CGFloat width  = [IRUIUtilites UIScreenMinWidth] - 20;
        CGFloat height = [IRUIUtilites UIScreenMaxHeight] - edgeInset;
        pageSize = CGSizeMake(width, height);
    }
    
    return pageSize;
}

@end
