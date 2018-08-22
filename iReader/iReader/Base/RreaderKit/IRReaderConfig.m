//
//  IRReaderConfig.m
//  iReader
//
//  Created by zzyong on 2018/7/27.
//  Copyright © 2018年 zouzhiyong. All rights reserved.
//

#import "IRReaderConfig.h"

@interface IRReaderConfig ()


@end

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

- (instancetype)init
{
    if (self = [super init]) {
        [self commonInit];
    }
    
    return self;
}

#pragma mark - Privte

- (void)commonInit
{
    CGFloat top = [IRUIUtilites isIPhoneX] ? 40 : 20;
    CGFloat bottom = [IRUIUtilites isIPhoneX] ? 30 : 20;
    _pageInsets = UIEdgeInsetsMake(top, 20, bottom, 20);
    
    _verticalInset = _pageInsets.top + _pageInsets.bottom;
    _horizontalInset = _pageInsets.left + _pageInsets.right;
    _pageSize = CGSizeMake([IRUIUtilites UIScreenMinWidth] - _horizontalInset, [IRUIUtilites UIScreenMaxHeight] - _verticalInset);
    _textFontSize = 15;
}

#pragma mark - Public


@end
