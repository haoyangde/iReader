//
//  UIColor+Extension.h
//  iReader
//
//  Created by zzyong on 2018/7/15.
//  Copyright © 2018年 zouzhiyong. All rights reserved.
//

#import <UIKit/UIKit.h>

#define IR_RANDOM_COLOR [UIColor ir_randomColor]

@interface UIColor (Extension)

+ (UIColor *)ir_randomColor;

+ (UIColor *)ir_colorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue;

+ (UIColor *)ir_colorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha;

@end
