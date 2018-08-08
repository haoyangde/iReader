//
//  IRPageViewCell.m
//  iReader
//
//  Created by zzyong on 2018/8/6.
//  Copyright © 2018年 zouzhiyong. All rights reserved.
//

#import "IRPageViewCell.h"
#import "IRPageModel.h"
#import <YYLabel.h>

@interface IRPageViewCell ()

@property (nonatomic, strong) YYLabel *readerPage;

@end

@implementation IRPageViewCell

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
    
    _readerPage.frame = self.contentView.bounds;
}

- (void)setupSubviews
{
    _readerPage = [[YYLabel alloc] init];
    _readerPage.numberOfLines = 0;
    _readerPage.textVerticalAlignment = YYTextVerticalAlignmentTop;
    _readerPage.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.2];
    _readerPage.textAlignment = NSTextAlignmentJustified;
    _readerPage.displaysAsynchronously = YES;
    [self.contentView addSubview:_readerPage];
}

- (void)setPageModel:(IRPageModel *)pageModel
{
    _pageModel = pageModel;
    
    CGFloat top = [IRUIUtilites isIPhoneX] ? 40 : 10;
    CGFloat bottom = [IRUIUtilites isIPhoneX] ? 30 : 10;
    YYTextContainer *container = [YYTextContainer containerWithSize:self.contentView.size
                                                             insets:UIEdgeInsetsMake(top, 10, bottom, 10)];
    YYTextLayout *textLayout = [YYTextLayout layoutWithContainer:container text:pageModel.content];
    _readerPage.textLayout = textLayout;
    
    [self setNeedsLayout];
}

@end
