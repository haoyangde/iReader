//
//  IRSwitchSettingCell.h
//  iReader
//
//  Created by zzyong on 2018/9/29.
//  Copyright © 2018年 zouzhiyong. All rights reserved.
//

#import "IRSettingCell.h"

@class IRSwitchSettingCell;

@protocol IRSwitchSettingCellDelegate <NSObject>

- (void)settingCellDidClickSwitchButton:(IRSwitchSettingCell *)cell;

@end

NS_ASSUME_NONNULL_BEGIN

@interface IRSwitchSettingCell : IRSettingCell

@property (nonatomic, strong, readonly) UISwitch *switchView;
@property (nonatomic, weak) id<IRSwitchSettingCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
