//
//  IRCommonCell.m
//  iReader
//
//  Created by zzyong on 2019/6/6.
//  Copyright © 2019 zouzhiyong. All rights reserved.
//

#import "IRCommonCell.h"
#import "IRCommonCellModel.h"

@interface IRCommonCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *bottomLine;

@end

@implementation IRCommonCell

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
    self.bottomLine.backgroundColor = IR_SEPARATOR_COLOR;
    [self.contentView addSubview:self.bottomLine];
}

@end
