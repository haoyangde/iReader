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

@property (nonatomic, strong) UIColor *readerCenterBackgroundColor;

/// 阅读页尺寸
- (CGSize)pageSize;
/// 文字大小
- (CGFloat)textFontSize;

@end
