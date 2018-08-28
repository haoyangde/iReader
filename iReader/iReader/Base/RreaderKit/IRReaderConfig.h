//
//  IRReaderConfig.h
//  iReader
//
//  Created by zzyong on 2018/7/27.
//  Copyright © 2018年 zouzhiyong. All rights reserved.
//

#import <Foundation/Foundation.h>

#define IR_READER_CONFIG [IRReaderConfig sharedInstance]

typedef NS_ENUM(NSUInteger, ReaderPageNavigationOrientation) {
    ReaderPageNavigationOrientationHorizontal,
    ReaderPageNavigationOrientationVertical
};

@interface IRReaderConfig : NSObject

+ (instancetype)sharedInstance;

@property (nonatomic, assign, readonly) ReaderPageNavigationOrientation readerPageNavigationOrientation;
@property (nonatomic, strong, readonly) UIColor *appThemeColor;
@property (nonatomic, assign, readonly) UIEdgeInsets pageInsets;
@property (nonatomic, assign, readonly) CGFloat verticalInset;
@property (nonatomic, assign, readonly) CGFloat horizontalInset;
/// 阅读页尺寸
@property (nonatomic, assign, readonly) CGSize pageSize;
/// default : 16
@property (nonatomic, assign, readonly) CGFloat textFontSize;
@property (nonatomic, assign, readonly) CGFloat textDefaultFontSize;
@property (nonatomic, strong, readonly) NSArray<NSNumber *> *fontSizeMultipliers;


#pragma mark - Custom

@property (nonatomic, assign) BOOL isNightMode;
@property (nonatomic, strong) NSString *fontFamily;
@property (nonatomic, strong) NSString *fontName;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIColor *pageBackgroundColor;
@property (nonatomic, strong) UIImage *pageBackgroundImg;
/// default 0.875, 缩放比例: [ { 14 : 0.875 }, { 16 : 1 }, { 18 : 1.125 }, { 20 : 1.25 }, { 22 : 1.375 }, { 24 : 1.5 }, { 26 : 1.625 }, { 28 : 1.75 } ]
@property (nonatomic, assign) CGFloat textSizeMultiplier;

/// default 5
@property (nonatomic, assign) CGFloat lineSpacing;
/// default 20
@property (nonatomic, assign) CGFloat paragraphSpacing;
/// default 2 char
@property (nonatomic, assign) CGFloat firstLineHeadIndent;

- (void)updateReaderPageNavigationOrientation:(ReaderPageNavigationOrientation)orientation;

@end
