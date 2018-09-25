//
//  IRUIUtilites.m
//  iReader
//
//  Created by zzyong on 2018/8/7.
//  Copyright © 2018年 zouzhiyong. All rights reserved.
//

#import "IRUIUtilites.h"

@implementation IRUIUtilites

+ (CGFloat)appStatusBarMaxY
{
    static CGFloat appStatusBarMaxY;
    if (!appStatusBarMaxY) {
        appStatusBarMaxY = CGRectGetMaxY([UIApplication sharedApplication].statusBarFrame);
    }
    
    return appStatusBarMaxY;
}

+ (CGFloat)UIScreenMinWidth
{
    static CGFloat UIScreenMinWidth;
    if (!UIScreenMinWidth) {
        UIScreenMinWidth = MIN([[UIScreen mainScreen] bounds].size.height, [[UIScreen mainScreen] bounds].size.width);
    }
    
    return UIScreenMinWidth;
}

+ (CGFloat)UIScreenMaxHeight
{
    static CGFloat UIScreenMaxHeight;
    if (!UIScreenMaxHeight) {
        UIScreenMaxHeight = MAX([[UIScreen mainScreen] bounds].size.height, [[UIScreen mainScreen] bounds].size.width);
    }
    
    return UIScreenMaxHeight;
}

+ (BOOL)isIPhoneX
{
    return [self UIScreenMaxHeight] >= 812;
}

@end
