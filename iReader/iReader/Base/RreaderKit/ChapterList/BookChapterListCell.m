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
    
    self.chapterLabel.frame = self.contentView.bounds;
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
        self.chapterLabel.backgroundColor = [UIColor colorWithRed:118/255 green:150/255 blue:210/255 alpha:1];
    } else {
        self.chapterLabel.backgroundColor = [UIColor whiteColor];
    }
    
    [self setNeedsLayout];
}

@end
