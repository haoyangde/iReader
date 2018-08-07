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

@end
