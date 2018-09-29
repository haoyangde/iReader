//
//  IRSwitchSettingCell.m
//  iReader
//
//  Created by zzyong on 2018/9/29.
//  Copyright © 2018年 zouzhiyong. All rights reserved.
//

#import "IRSwitchSettingCell.h"
#import "IRSettingModel.h"

@interface IRSwitchSettingCell ()

@property (nonatomic, strong) UISwitch *switchView;

@end

@implementation IRSwitchSettingCell

- (void)setupSubviews
{
    [super setupSubviews];
    
    self.switchView = [[UISwitch alloc] init];
    self.switchView.onTintColor = APP_THEME_COLOR;
    [self.switchView addTarget:self action:@selector(onSwitchValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.contentView addSubview:self.switchView];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

#pragma mark - Actions

- (void)onSwitchValueChanged:(UISwitch *)switchView
{
    if ([self.delegate respondsToSelector:@selector(settingCellDidClickSwitchButton:)]) {
        [self.delegate settingCellDidClickSwitchButton:self];
    }
}

#pragma mark - Public

- (void)setSettingModel:(IRSettingModel *)settingModel
{
   
}

@end
