//
//  IRChapterModel.m
//  iReader
//
//  Created by zzyong on 2018/7/25.
//  Copyright © 2018年 zouzhiyong. All rights reserved.
//

#import "IRChapterModel.h"
#import "IRHtmlModel.h"
#import "IRPageModel.h"
#import "NSString+Extension.h"
#import "IRReaderConfig.h"
#import "IRTocRefrence.h"
#import "IRResource.h"

#import <DTCoreText/NSAttributedString+HTML.h>
#import <DTCoreText/DTCoreTextLayouter.h>
#import <DTCoreText/DTCoreTextConstants.h>

@implementation IRChapterModel

+ (instancetype)modelWithHtmlModel:(IRHtmlModel *)htmlMode
{
    return nil;
}

+ (instancetype)modelWithTocRefrence:(IRTocRefrence *)tocRefrence
{
    IRChapterModel *model = [[self alloc] init];
    NSData *htmlData = [NSData dataWithContentsOfFile:tocRefrence.resource.fullHref];
    NSDictionary *options = @{
                              DTDefaultFontFamily : @"Times New Roman",
                              DTDefaultLinkColor  : @"purple",
                              NSTextSizeMultiplierDocumentOption : @1.0,
                              DTDefaultFontSize   : @14,
                              DTDefaultLineHeightMultiplier : @2,
                              DTDefaultTextAlignment : @0,
                              DTDefaultHeadIndent : @0,
//                              NSBaseURLDocumentOption : tocRefrence.resource.fullHref,
                              DTMaxImageSize      : [NSValue valueWithCGSize:[IR_READER_CONFIG pageSize]]
                            };
    
    
    NSAttributedString *chapter = [[NSAttributedString alloc] initWithHTMLData:htmlData options:options documentAttributes:nil];
    DTCoreTextLayouter *textLayout = [[DTCoreTextLayouter alloc] initWithAttributedString:chapter];
    CGRect rect = CGRectMake(0, 0, [IR_READER_CONFIG pageSize].width, [IR_READER_CONFIG pageSize].height);
    DTCoreTextLayoutFrame *layoutFrame = [textLayout layoutFrameWithRect:rect range:NSMakeRange(0, chapter.length)];
    NSRange visibleRange = layoutFrame.visibleStringRange;
    CGFloat pageOffset = visibleRange.location + visibleRange.length;
    NSUInteger pageCount = 1;
    NSMutableArray *pages = [[NSMutableArray alloc] init];
    
    while (pageOffset <= chapter.length && pageOffset != 0) {
        IRPageModel *pageModel = [[IRPageModel alloc] init];
        pageModel.content = [chapter attributedSubstringFromRange:visibleRange];
        pageModel.pageIndex = pageCount - 1;
        layoutFrame = [textLayout layoutFrameWithRect:rect range:NSMakeRange(pageOffset, chapter.length - pageOffset)];
        visibleRange = layoutFrame.visibleStringRange;
        if (visibleRange.location == NSNotFound) {
            pageOffset = 0;
        } else {
            pageOffset = visibleRange.location + visibleRange.length;
        }
        
        pageCount++;
        [pages addObject:pageModel];
    }
    
    model.pages = pages;
    model.pageCount = pageCount;
    
    return model;
}

@end
