//
//  IRReaderConfig.m
//  iReader
//
//  Created by zzyong on 2018/7/27.
//  Copyright © 2018年 zouzhiyong. All rights reserved.
//

#import "IRReaderConfig.h"
#import "HexColors.h"

static NSString * const kReaderNightMode = @"kReaderNightMode";
static NSString * const kReaderBgColor   = @"kReaderBgColor";
static NSString * const kReaderTextColor = @"kReaderTextColor";
static NSString * const kReaderBgImg     = @"kReaderBgImg";
static NSString * const kReaderPageNavigationOrientation = @"kReaderPageNavigationOrientation";
static NSString * const kReaderTextSizeMultiplier        = @"kReaderTextSizeMultiplier";

static CGFloat kReaderDefaultTextFontSize = 16;

@interface IRReaderConfig ()

@property (nonatomic, strong) UIColor *nightModeBgColor;
@property (nonatomic, strong) UIColor *nightModeTextColor;
@property (nonatomic, strong) UIColor *defaultBgColor;
@property (nonatomic, strong) UIColor *defaultTextColor;

@end

@implementation IRReaderConfig {
    UIColor *_readerBgColor;
    UIColor *_readerTextColor;}

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
    _nightModeBgColor = [UIColor hx_colorWithHexString:@"#1E1E1E"];
    _nightModeTextColor = [UIColor hx_colorWithHexString:@"#767676"];
    _defaultBgColor = [UIColor hx_colorWithHexString:@"#F6F6F6"];
    _defaultTextColor = [UIColor hx_colorWithHexString:@"#333333"];
    _readerBgImg = [[IRCacheManager sharedInstance] objectForKey:kReaderBgImg];
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
    _readerBgImg = nil;
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

- (void)setReaderBgColor:(UIColor *)readerBgColor
{
    _readerBgColor = readerBgColor;
    
    [[NSUserDefaults standardUserDefaults] setObject:readerBgColor forKey:kReaderBgColor];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (UIColor *)readerBgColor
{
    if (self.isNightMode) {
        return _nightModeBgColor;
    } else {
        if (!_readerBgColor) {
            _readerBgColor = [[NSUserDefaults standardUserDefaults]objectForKey:kReaderBgColor];
        }
        return _readerBgColor ?: _defaultBgColor;
    }
}

- (void)setReaderTextColor:(UIColor *)readerTextColor
{
    _readerTextColor = readerTextColor;
    
    [[NSUserDefaults standardUserDefaults] setObject:readerTextColor forKey:kReaderTextColor];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (UIColor *)readerTextColor
{
    if (self.isNightMode) {
        return _nightModeTextColor;
    } else {
        if (!_readerTextColor) {
            _readerTextColor = [[NSUserDefaults standardUserDefaults]objectForKey:kReaderTextColor];
        }
        return _readerTextColor ?: _defaultTextColor;
    }
}

- (void)setReaderBgImg:(UIImage *)readerBgImg
{
    _readerBgImg = readerBgImg;
    
    [[IRCacheManager sharedInstance] asyncSetObject:readerBgImg forKey:kReaderBgImg];
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
