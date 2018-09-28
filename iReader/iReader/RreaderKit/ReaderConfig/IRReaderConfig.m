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

@property (nonatomic, strong) NSDictionary *bgColorToTextColor;
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
    CGFloat top = IS_IPHONEX_SERIES ? 40 : 20;
    CGFloat bottom = IS_IPHONEX_SERIES ? 30 : 20;
    _pageInsets = UIEdgeInsetsMake(top, 20, bottom, 20);
    _isNightMode = [[NSUserDefaults standardUserDefaults] boolForKey:kReaderNightMode];
    _nightModeBgColor = [UIColor hx_colorWithHexString:@"#1E1E1E"];
    _nightModeTextColor = [UIColor hx_colorWithHexString:@"#767676"];
    _defaultBgColor = [UIColor whiteColor];
    _defaultTextColor = [UIColor blackColor];
    _readerBgImg = [[IRCacheManager sharedInstance] objectForKey:kReaderBgImg];
    _readerPageNavigationOrientation = [[NSUserDefaults standardUserDefaults] integerForKey:kReaderPageNavigationOrientation];
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
    
    [self setupReaderBgSelectColors];
}

- (void)setupReaderBgSelectColors
{
 // bg color
    
    // #BFAF8D 191,175,141
    // #E3E5F1 227,229,242
    // #CCE9C8 204,233,200
    // #F2E2E8 242,226,232
    
 // text color
    
    // #783441 120,52,65
    // #445446 68,84,70
    // #5A4531 90,69,49
    // #313D55 49,61,85
    
    self.readerBgSelectColors = @[
                                  _defaultBgColor,
                                  [UIColor hx_colorWithHexString:@"#BFAF8D"],
                                  [UIColor hx_colorWithHexString:@"#E3E5F1"],
                                  [UIColor hx_colorWithHexString:@"#CCE9C8"],
                                  [UIColor hx_colorWithHexString:@"#F2E2E8"]
                                  ];
    
    self.bgColorToTextColor = @{
                                _defaultBgColor : _defaultTextColor,
                                [UIColor hx_colorWithHexString:@"#BFAF8D"] : [UIColor hx_colorWithHexString:@"#5A4531"],
                                [UIColor hx_colorWithHexString:@"#E3E5F1"] : [UIColor hx_colorWithHexString:@"#313D55"],
                                [UIColor hx_colorWithHexString:@"#CCE9C8"] : [UIColor hx_colorWithHexString:@"#445446"],
                                [UIColor hx_colorWithHexString:@"#F2E2E8"] : [UIColor hx_colorWithHexString:@"#783441"]
                                };
}

#pragma mark - Public

- (UIColor *)readerTextColorWithBgColor:(UIColor *)bgColor
{
    return [self.bgColorToTextColor safeObjectForKey:bgColor];
}

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
    [[IRCacheManager sharedInstance] asyncSetObject:readerBgColor forKey:kReaderBgColor];
}

- (UIColor *)readerBgColor
{
    if (self.isNightMode) {
        return _nightModeBgColor;
    } else {
        if (!_readerBgColor) {
            _readerBgColor = [[IRCacheManager sharedInstance] objectForKey:kReaderBgColor];
            __block BOOL isColorExist = NO;
            [self.readerBgSelectColors enumerateObjectsUsingBlock:^(UIColor * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (CGColorEqualToColor(_readerBgColor.CGColor, obj.CGColor)) {
                    isColorExist = YES;
                }
            }];
            
            if (!isColorExist) {
                [[IRCacheManager sharedInstance] asyncRemoveObjectForKey:kReaderBgColor];
                _readerBgColor = self.defaultBgColor;
                _readerTextColor = self.defaultTextColor;
            }
        }
        
        _readerBgSelectColor = _readerBgColor ?: _defaultBgColor;
        return _readerBgSelectColor;
    }
}

- (UIColor *)readerTextColor
{
    if (self.isNightMode) {
        return _nightModeTextColor;
    } else {
        if (!_readerTextColor) {
            _readerTextColor = [[IRCacheManager sharedInstance] objectForKey:kReaderTextColor];
        }
        return _readerTextColor ?: _defaultTextColor;
    }
}

- (void)setReaderBgImg:(UIImage *)readerBgImg
{
    _readerBgImg = readerBgImg;
    
    if (readerBgImg) {
        [[IRCacheManager sharedInstance] asyncSetObject:readerBgImg forKey:kReaderBgImg];
    } else {
        [[IRCacheManager sharedInstance] asyncRemoveObjectForKey:kReaderBgImg];
    }
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
