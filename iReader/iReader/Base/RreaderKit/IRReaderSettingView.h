//
//  IRReaderSettingView.h
//  iReader
//
//  Created by zzyong on 2018/8/23.
//  Copyright © 2018年 zouzhiyong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IRReaderSettingView;

@protocol ReaderSettingViewDeletage <NSObject>

@optional
- (void)readerSettingViewWillDisappear:(IRReaderSettingView *)readerSettingView;
- (void)readerSettingViewDidClickVerticalButton:(IRReaderSettingView *)readerSettingView;
- (void)readerSettingViewDidClickHorizontalButton:(IRReaderSettingView *)readerSettingView;
- (void)readerSettingViewDidChangedTextSizeMultiplier:(CGFloat)textSizeMultiplier;

@end

@interface IRReaderSettingView : UIView

@property (nonatomic, weak) id<ReaderSettingViewDeletage> delegate;

+ (instancetype)readerSettingView;

- (void)showInView:(UIView *)targetView animated:(BOOL)animated;
- (void)dismissWithAnimated:(BOOL)animated;

@end
