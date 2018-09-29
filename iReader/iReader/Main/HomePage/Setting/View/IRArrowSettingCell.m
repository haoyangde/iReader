//
//  IRArrowSettingCell.m
//  iReader
//
//  Created by zzyong on 2018/9/29.
//  Copyright © 2018年 zouzhiyong. All rights reserved.
//

#import "IRArrowSettingCell.h"
#import "IRSettingModel.h"

@interface IRArrowSettingCell ()

@property (nonatomic, strong) UIImageView *arrowView;

@end

@implementation IRArrowSettingCell

- (void)setupSubviews
{
    [super setupSubviews];
    
    self.arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_grey_right"]];
    [self.contentView addSubview:self.arrowView];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

#pragma mark - Public

- (void)setSettingModel:(IRSettingModel *)settingModel
{
    
}

@end
