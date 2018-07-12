//
//  MyBookCell.m
//  iReader
//
//  Created by zzyong on 2018/7/11.
//  Copyright © 2018年 zouzhiyong. All rights reserved.
//

#import "MyBookCell.h"

@interface MyBookCell ()

@property (nonatomic, strong) UIImageView *coverImageView;

@end

@implementation MyBookCell

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
    
    self.coverImageView.frame = self.contentView.bounds;
}

- (void)setupSubviews
{
    self.coverImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:self.coverImageView];
}

- (void)setCoverImage:(UIImage *)image
{
    self.coverImageView.image = image;
}

@end
