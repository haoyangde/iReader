//
//  UIColor+Extension.m
//  iReader
//
//  Created by zzyong on 2018/7/15.
//  Copyright © 2018年 zouzhiyong. All rights reserved.
//

#import "UIColor+Extension.h"

@implementation UIColor (Extension)

+ (UIColor *)ir_randomColor
{
    return [self ir_colorWithRed:(arc4random() % 255) green:(arc4random() % 255) blue:(arc4random() % 255)];
}

+ (UIColor *)ir_colorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue
{
    return [self ir_colorWithRed:red green:green blue:blue alpha:1];
}

+ (UIColor *)ir_colorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha
{
   return [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:alpha];
}

@end
