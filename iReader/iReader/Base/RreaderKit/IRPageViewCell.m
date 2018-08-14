//
//  IRPageViewCell.m
//  iReader
//
//  Created by zzyong on 2018/8/6.
//  Copyright © 2018年 zouzhiyong. All rights reserved.
//

#import "IRPageViewCell.h"
#import "IRPageModel.h"
#import <DTCoreText/DTAttributedTextView.h>

@interface IRPageViewCell ()

@property (nonatomic, strong) DTAttributedTextView *textView;

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
    
    CGFloat textViewY = [IRUIUtilites isIPhoneX] ? 40 : 10;
    CGFloat bottomInset = [IRUIUtilites isIPhoneX] ? 30 : 10;
    self.textView.frame = CGRectMake(10, textViewY, self.contentView.width - 20, self.contentView.height - bottomInset - textViewY);
}

- (void)setupSubviews
{
    self.textView = [[DTAttributedTextView alloc] init];
    [self.contentView addSubview:self.textView];
}

- (void)setPageModel:(IRPageModel *)pageModel
{
    _pageModel = pageModel;
    
    self.textView.attributedString = pageModel.content;
    
    [self setNeedsLayout];
}

@end
