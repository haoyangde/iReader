//
//  IRUIUtilites.h
//  iReader
//
//  Created by zzyong on 2018/8/7.
//  Copyright © 2018年 zouzhiyong. All rights reserved.
//

#import <UIKit/UIKit.h>

#define APP_THEME_COLOR [IRUIUtilites appThemeColor]

@interface IRUIUtilites : NSObject

+ (UIColor *)appThemeColor;

+ (CGFloat)appStatusBarMaxY;

+ (CGFloat)UIScreenMinWidth;

+ (CGFloat)UIScreenMaxHeight;

+ (BOOL)isIPhoneX;

@end
