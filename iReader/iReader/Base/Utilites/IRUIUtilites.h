//
//  IRUIUtilites.h
//  iReader
//
//  Created by zzyong on 2018/8/7.
//  Copyright © 2018年 zouzhiyong. All rights reserved.
//

#import <UIKit/UIKit.h>

#define APP_THEME_COLOR    [IRUIUtilites appThemeColor]
#define IS_IPHONEX_SERIES  [IRUIUtilites isIPhoneXSeries]
#define SCREEN_MIN_WIDTH   [IRUIUtilites UIScreenMinWidth]

@interface IRUIUtilites : NSObject

+ (void)commonInit;

+ (UIColor *)appThemeColor;

+ (CGFloat)appStatusBarMaxY;

+ (CGFloat)UIScreenMinWidth;

+ (CGFloat)UIScreenMaxHeight;

+ (BOOL)isIPhoneXSeries;

@end
