//
//  ReaderPageViewCell.m
//  iReader
//
//  Created by zzyong on 2018/7/12.
//  Copyright © 2018年 zouzhiyong. All rights reserved.
//

#import "ReaderPageViewCell.h"
#import "ReaderWebView.h"
#import "IREpubHeaders.h"

@interface ReaderPageViewCell ()

@property (nonatomic, strong) ReaderWebView *readerWebView;
@property (nonatomic, strong) NSString *chapterHtmlStr;

@end

@implementation ReaderPageViewCell

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
    
    _readerWebView.frame = self.contentView.bounds;
}

- (void)setupSubviews
{
    _readerWebView = [[ReaderWebView alloc] init];
    _readerWebView.scrollView.pagingEnabled = YES;
    _readerWebView.dataDetectorTypes = UIDataDetectorTypeLink;
    _readerWebView.scrollView.alwaysBounceHorizontal = NO;
    _readerWebView.scrollView.alwaysBounceVertical   = NO;
    _readerWebView.paginationMode = UIWebPaginationModeLeftToRight;
    _readerWebView.paginationBreakingMode = UIWebPaginationBreakingModePage;
    [self.contentView addSubview:_readerWebView];
}

- (void)setChapter:(IRTocRefrence *)chapter
{
    if (chapter.resource.itemId == _chapter.resource.itemId) {
        return;
    }
    
    _chapter = chapter;
    
    NSError *error = nil;
    _chapterHtmlStr = [NSString stringWithContentsOfFile:chapter.resource.fullHref
                                                encoding:NSUTF8StringEncoding
                                                   error:&error];
    if (error) {
        IRDebugLog(@"[ReaderPageViewCell] Read chapter resource failed, error: %@", error);
        return;
    }
    
    NSString *base = [chapter.resource.fullHref stringByDeletingLastPathComponent];
    [self.readerWebView loadHTMLString:_chapterHtmlStr baseURL:[NSURL URLWithString:base]];
}

@end
