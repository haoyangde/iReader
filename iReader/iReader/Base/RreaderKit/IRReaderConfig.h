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
@property (nonatomic, assign, readonly) UIEdgeInsets pageInsets;
@property (nonatomic, assign, readonly) CGFloat verticalInset;
@property (nonatomic, assign, readonly) CGFloat horizontalInset;
/// 阅读页尺寸
@property (nonatomic, assign, readonly) CGSize pageSize;
/// 文字大小 default: 15
@property (nonatomic, assign) CGFloat textFontSize;

@end
