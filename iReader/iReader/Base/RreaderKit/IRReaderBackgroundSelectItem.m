//
//  IRReaderBackgroundSelectItem.m
//  iReader
//
//  Created by zzyong on 2018/8/28.
//  Copyright © 2018年 zouzhiyong. All rights reserved.
//

#import "IRReaderBackgroundSelectItem.h"

@interface IRReaderBackgroundSelectItem ()

@property (nonatomic, strong) UIImageView *bgSelectIconView;

@end

@implementation IRReaderBackgroundSelectItem

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.layer.cornerRadius = 5;
        self.layer.borderColor = [UIColor colorWithWhite:0.9 alpha:1].CGColor;
        self.layer.borderWidth = 1;
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.bgSelectIconView.frame = CGRectMake((self.width - 14) * 0.5, (self.height - 8) * 0.5, 14, 8);
}

- (void)setSelected:(BOOL)selected
{
    if (selected) {
        [self addBgSelectIconViewIfNeeded];
    }
    
    self.layer.borderColor = selected ? IR_READER_CONFIG.appThemeColor.CGColor : [UIColor grayColor].CGColor;
    self.layer.borderWidth = selected ? 2 : 1;
    self.bgSelectIconView.hidden = !selected;
}

- (void)addBgSelectIconViewIfNeeded
{
    if (self.bgSelectIconView) {
        return;
    }
    
    self.bgSelectIconView = [[UIImageView alloc] init];
    self.bgSelectIconView.contentMode = UIViewContentModeCenter;
    self.bgSelectIconView.image = [UIImage imageNamed:@"icon_bg_select"];
    [self addSubview:self.bgSelectIconView];
}

@end
