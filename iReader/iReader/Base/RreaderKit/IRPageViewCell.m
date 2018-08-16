//
//  IRPageViewCell.m
//  iReader
//
//  Created by zzyong on 2018/8/6.
//  Copyright © 2018年 zouzhiyong. All rights reserved.
//

#import "IRPageViewCell.h"
#import "IRPageModel.h"
#import <DTAttributedLabel.h>
#import <DTCoreTextLayouter.h>
#import "IRReaderConfig.h"

@interface IRPageViewCell ()

@property (nonatomic, strong) DTAttributedLabel *pageLabel;

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
    
    self.pageLabel.frame = self.contentView.bounds;
}

#pragma mark - Private

- (void)setupSubviews
{
    self.pageLabel = [[DTAttributedLabel alloc] init];
    CGFloat top = [IRUIUtilites isIPhoneX] ? 40 : 10;
    CGFloat bottom = [IRUIUtilites isIPhoneX] ? 30 : 10;
    self.pageLabel.edgeInsets = UIEdgeInsetsMake(top, 10, bottom, 10);
    self.pageLabel.numberOfLines = 0;
    [self.contentView addSubview:self.pageLabel];
}

- (void)setPageModel:(IRPageModel *)pageModel
{
    _pageModel = pageModel;
    
    self.pageLabel.attributedString = pageModel.content;
    
    [self setNeedsLayout];
}

@end
