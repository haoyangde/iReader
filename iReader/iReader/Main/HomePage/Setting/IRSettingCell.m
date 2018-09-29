//
//  IRSettingCell.m
//  iReader
//
//  Created by zzyong on 2018/9/28.
//  Copyright © 2018年 zouzhiyong. All rights reserved.
//

#import "IRSettingCell.h"

@interface IRSettingCell ()

@property (nonatomic, strong) UIImageView *arrowView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UISwitch *switchView;

@end

@implementation IRSettingCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupSubviews];
    }
    
    return self;
}

- (void)setupSubviews
{
    
}

@end
