//
//  IRReaderConfig.m
//  iReader
//
//  Created by zzyong on 2018/7/27.
//  Copyright © 2018年 zouzhiyong. All rights reserved.
//

#import "IRReaderConfig.h"

static NSString * const kReaderPageNavigationOrientation = @"kReaderPageNavigationOrientation";
static NSString * const kReaderTextSizeMultiplier = @"kReaderTextSizeMultiplier";
static NSString * const kReaderNightMode = @"kReaderNightMode";

static CGFloat kReaderDefaultTextFontSize = 16;

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
    _isNightMode = [[NSUserDefaults standardUserDefaults] boolForKey:kReaderNightMode];
    _readerPageNavigationOrientation = [[NSUserDefaults standardUserDefaults] integerForKey:kReaderPageNavigationOrientation];
    _appThemeColor = [UIColor ir_colorWithRed:126 green:211 blue:33];
    _verticalInset = _pageInsets.top + _pageInsets.bottom;
    _horizontalInset = _pageInsets.left + _pageInsets.right;
    _pageSize = CGSizeMake([IRUIUtilites UIScreenMinWidth] - _horizontalInset, [IRUIUtilites UIScreenMaxHeight] - _verticalInset);
    _textSizeMultiplier = [[NSUserDefaults standardUserDefaults] doubleForKey:kReaderTextSizeMultiplier] ?: 1;
    _textFontSize =  _textSizeMultiplier * kReaderDefaultTextFontSize;
    _textDefaultFontSize = kReaderDefaultTextFontSize;
    _fontSizeMultipliers = @[@(0.875), @(1), @(1.125), @(1.25), @(1.375), @(1.5), @(1.625), @(1.75)];
    _lineSpacing = 5;
    _paragraphSpacing = 20;
    
    _firstLineHeadIndent = [UIFont systemFontOfSize:_textFontSize].pointSize * 2;
    _pageBackgroundImg = nil;
    _pageBackgroundColor = [UIColor whiteColor];
    _textColor  = [UIColor blackColor];
    _fontFamily = @"Times New Roman";
    _fontName   = @"TimesNewRomanPSMT";
}

#pragma mark - Public

- (void)updateReaderPageNavigationOrientation:(ReaderPageNavigationOrientation)orientation
{
    if (orientation == self.readerPageNavigationOrientation) {
        return;
    }
    
    _readerPageNavigationOrientation = orientation;
    [[NSUserDefaults standardUserDefaults] setInteger:orientation forKey:kReaderPageNavigationOrientation];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setIsNightMode:(BOOL)isNightMode
{
    if (_isNightMode == isNightMode) {
        return;
    }
    
    _isNightMode =isNightMode;
    
    [[NSUserDefaults standardUserDefaults] setBool:isNightMode forKey:kReaderNightMode];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setTextSizeMultiplier:(CGFloat)textSizeMultiplier
{
    if (_textSizeMultiplier == textSizeMultiplier) {
        return;
    }
    
    _textSizeMultiplier = textSizeMultiplier;
    _textFontSize = textSizeMultiplier * kReaderDefaultTextFontSize;
    
    [[NSUserDefaults standardUserDefaults] setDouble:textSizeMultiplier forKey:kReaderTextSizeMultiplier];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
