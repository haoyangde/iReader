//
//  IRReaderSettingMenuView.h
//  iReader
//
//  Created by zzyong on 2018/8/23.
//  Copyright © 2018年 zouzhiyong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IRReaderSettingMenuView : UIView

+ (instancetype)readerSettingMenuView;

- (void)showInView:(UIView *)targetView animated:(BOOL)animated;
- (void)dismissWithAnimated:(BOOL)animated completion:(void(^)(void))completion;

@end
