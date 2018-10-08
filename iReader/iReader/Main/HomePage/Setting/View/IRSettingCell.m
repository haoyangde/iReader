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
@property (nonatomic, strong) UIView *bottomLine;

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
    
    self.titleLabel.frame = CGRectMake(10, 0, self.width * 0.5, self.height);
    self.bottomLine.frame = CGRectMake(0, self.height - 0.7, self.width, 0.7);
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
    
    self.bottomLine = [[UIView alloc] init];
    self.bottomLine.backgroundColor = [UIColor colorWithWhite:0.9 alpha:0.8];
    [self.contentView addSubview:self.bottomLine];
}

@end
