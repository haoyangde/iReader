//
//  IRReaderMoreSettingViewController.h
//  iReader
//
//  Created by zzyong on 2018/9/28.
//  Copyright © 2018年 zouzhiyong. All rights reserved.
//

#import "IRBaseViewController.h"

@protocol IRReaderMoreSettingViewControllerDelegate <NSObject>

- (void)readerMoreSettingViewControllerDidChangedTransitionStyle:(IRPageTransitionStyle)transitionStyle;

@end

NS_ASSUME_NONNULL_BEGIN

@interface IRReaderMoreSettingViewController : IRBaseViewController

@property (nonatomic, weak) id<IRReaderMoreSettingViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
