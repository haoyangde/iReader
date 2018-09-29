//
//  IRTextSettingCell.m
//  iReader
//
//  Created by zzyong on 2018/9/29.
//  Copyright © 2018年 zouzhiyong. All rights reserved.
//

#import "IRTextSettingCell.h"
#import "IRSettingModel.h"

@interface IRTextSettingCell ()

@property (nonatomic, strong) UILabel *rightTextLabel;

@end

@implementation IRTextSettingCell

- (void)setupSubviews
{
    [super setupSubviews];
    
    self.rightTextLabel = [[UILabel alloc] init];
    self.rightTextLabel.textColor = [UIColor ir_colorWithHexString:@"#888888"];
    self.rightTextLabel.font = [UIFont systemFontOfSize:13];
    self.rightTextLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.rightTextLabel];
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
