//
//  BookChapterListCell.m
//  iReader
//
//  Created by zzyong on 2018/7/13.
//  Copyright © 2018年 zouzhiyong. All rights reserved.
//

#import "BookChapterListCell.h"
#import "IREpubHeaders.h"

CGFloat const kChapterListCellFontSize = 13;

@interface BookChapterListCell ()

@property (nonatomic, strong) UILabel *chapterLabel;

@end

@implementation BookChapterListCell

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
    
    self.chapterLabel.frame = CGRectMake(10, 0, self.contentView.width - 20, self.contentView.height);
}

- (void)setupSubviews
{
    self.chapterLabel = [[UILabel alloc] init];
    self.chapterLabel.font = [UIFont systemFontOfSize:kChapterListCellFontSize];
    self.chapterLabel.textColor = [UIColor blackColor];
    self.chapterLabel.numberOfLines = 0;
    [self.contentView addSubview:self.chapterLabel];
}

- (void)setChapter:(IRTocRefrence *)chapter
{
    _chapter = chapter;
    
    self.chapterLabel.text = chapter.title;
    
    if (chapter.childen.count) {
        self.contentView.backgroundColor = [UIColor ir_colorWithRed:128 green:167 blue:94];
    } else {
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
    
    [self setNeedsLayout];
}

@end
