//
//  IRSettingCell.m
//  iReader
//
//  Created by zzyong on 2018/9/28.
//  Copyright © 2018年 zouzhiyong. All rights reserved.
//

#import "IRSettingCell.h"
#import "IRSettingModel.h"

@interface IRSettingCell ()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation IRSettingCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupSubviews];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
}

#pragma mark - Private

- (void)setupSubviews
{
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = [UIColor ir_colorWithHexString:@"#333333"];
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:titleLabel];
    self.titleLabel = titleLabel;
}

@end
