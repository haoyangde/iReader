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

#import <NSAttributedString+HTML.h>
#import <DTCoreTextLayouter.h>
#import <DTCoreTextConstants.h>
#import <DTCoreTextParagraphStyle.h>

@implementation IRChapterModel

+ (instancetype)modelWithHtmlModel:(IRHtmlModel *)htmlMode
{
    return nil;
}

+ (instancetype)modelWithTocRefrence:(IRTocRefrence *)tocRefrence
{
    IRChapterModel *model = [[self alloc] init];
    NSURL *baseUrl = [[NSURL alloc] initFileURLWithPath:tocRefrence.resource.fullHref];
    NSData *htmlData = [NSData dataWithContentsOfURL:baseUrl];
    DTCoreTextParagraphStyle *paragraph = [DTCoreTextParagraphStyle defaultParagraphStyle];
    paragraph.headIndent = 30;
    paragraph.paragraphSpacing = 80;
    paragraph.firstLineHeadIndent = 30;

    NSDictionary *options = @{
                              DTProcessCustomHTMLAttributes : @(YES),
                              DTCustomAttributesAttribute : paragraph,
//                              DTDefaultFontFamily : @"Times New Roman",
//                              DTDefaultLinkColor  : @"purple",
//                              NSTextSizeMultiplierDocumentOption : @1.0,
//                              DTDefaultFontSize   : @15,
//                              DTDefaultLineHeightMultiplier : @2,
//                              DTDefaultTextAlignment : @(NSTextAlignmentJustified),
                              NSBaseURLDocumentOption : baseUrl,
//                              DTDefaultHeadIndent : @0,
//                              DTMaxImageSize      : [NSValue valueWithCGSize:[IR_READER_CONFIG pageSize]]
                            };
    
    NSAttributedString *htmlString = [[NSAttributedString alloc] initWithHTMLData:htmlData options:options documentAttributes:nil];
    
    DTCoreTextLayouter *textLayout = [[DTCoreTextLayouter alloc] initWithAttributedString:htmlString];
    CGRect rect = CGRectMake(0, 0, [IR_READER_CONFIG pageSize].width, [IR_READER_CONFIG pageSize].height);
    DTCoreTextLayoutFrame *layoutFrame = [textLayout layoutFrameWithRect:rect range:NSMakeRange(0, htmlString.length)];
    NSRange visibleRange = layoutFrame.visibleStringRange;
    CGFloat pageOffset = visibleRange.location + visibleRange.length;
    NSUInteger pageCount = 1;
    NSMutableArray *pages = [[NSMutableArray alloc] init];
    
    while (pageOffset <= htmlString.length && pageOffset != 0) {
        
        IRPageModel *pageModel = [[IRPageModel alloc] init];
        pageModel.content = [htmlString attributedSubstringFromRange:visibleRange];
        pageModel.pageIndex = pageCount - 1;
        layoutFrame = [textLayout layoutFrameWithRect:rect range:NSMakeRange(pageOffset, htmlString.length - pageOffset)];
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
