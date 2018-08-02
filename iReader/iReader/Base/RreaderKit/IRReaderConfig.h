//
//  IRReaderConfig.h
//  iReader
//
//  Created by zzyong on 2018/7/27.
//  Copyright © 2018年 zouzhiyong. All rights reserved.
//

#import <Foundation/Foundation.h>

#define IR_READER_CONFIG [IRReaderConfig sharedInstance]

@interface IRReaderConfig : NSObject

+ (instancetype)sharedInstance;

/// 阅读页尺寸
- (CGSize)pageSize;
/// 通用文字大小
- (CGFloat)commonFontSize;
/// h1标签字体大小
- (CGFloat)H1FontSize;
/// h2标签字体大小
- (CGFloat)H2FontSize;
/// h3标签字体大小
- (CGFloat)H3FontSize;

@end
