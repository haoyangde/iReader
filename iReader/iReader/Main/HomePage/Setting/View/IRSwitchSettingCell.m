//
//  IRSwitchSettingCell.m
//  iReader
//
//  Created by zzyong on 2018/9/29.
//  Copyright © 2018年 zouzhiyong. All rights reserved.
//

#import "IRSwitchSettingCell.h"
#import "IRSettingModel.h"
#import <Masonry.h>

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
    
    [self.switchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-10);
    }];
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
    [super setSettingModel:settingModel];
    
    self.titleLabel.text = settingModel.title;
    self.switchView.on = settingModel.isSwitchOn;
    
    [self setNeedsLayout];
}

@end
