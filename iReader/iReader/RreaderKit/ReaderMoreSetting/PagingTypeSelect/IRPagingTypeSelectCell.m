//
//  IRPagingTypeSelectCell.m
//  iReader
//
//  Created by zzyong on 2018/10/8.
//  Copyright © 2018年 zouzhiyong. All rights reserved.
//

#import "IRPagingTypeSelectCell.h"
#import "IRSettingModel.h"

@interface IRPagingTypeSelectCell ()

@property (nonatomic, strong) UIImageView *bgSelectIconView;

@end

@implementation IRPagingTypeSelectCell

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.bgSelectIconView.frame = CGRectMake((self.width - 24), (self.height - 8) * 0.5, 14, 8);
}

- (void)setSelected:(BOOL)selected
{
    if (selected) {
        [self addBgSelectIconViewIfNeeded];
    }
    
    self.bgSelectIconView.hidden = !selected;
}

- (void)addBgSelectIconViewIfNeeded
{
    if (self.bgSelectIconView) {
        return;
    }
    
    self.bgSelectIconView = [[UIImageView alloc] init];
    self.bgSelectIconView.contentMode = UIViewContentModeCenter;
    self.bgSelectIconView.image = [UIImage imageNamed:@"reader_setting_bg_select"];
    [self addSubview:self.bgSelectIconView];
}

- (void)setSettingModel:(IRSettingModel *)settingModel
{
    [super setSettingModel:settingModel];
    
    self.titleLabel.text = settingModel.title;
    self.selected = settingModel.isSelected;
    
    [self setNeedsLayout];
}

@end
