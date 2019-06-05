//
//  IRTextSettingCell.m
//  iReader
//
//  Created by zzyong on 2018/9/29.
//  Copyright © 2018年 zouzhiyong. All rights reserved.
//

#import "IRTextSettingCell.h"
#import "IRSettingModel.h"
#import <Masonry.h>

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
    
    [self.rightTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-10);
        make.width.mas_lessThanOrEqualTo(SCREEN_MIN_WIDTH * 0.4);
    }];
}

#pragma mark - Public

- (void)setSettingModel:(IRSettingModel *)settingModel
{
    [super setSettingModel:settingModel];
    
    self.titleLabel.text = settingModel.title;
    self.rightTextLabel.text = settingModel.rightText;
    
    [self setNeedsLayout];
}

@end
