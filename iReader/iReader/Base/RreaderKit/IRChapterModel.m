//
//  IRChapterModel.m
//  iReader
//
//  Created by zzyong on 2018/7/25.
//  Copyright © 2018年 zouzhiyong. All rights reserved.
//

#import "IRChapterModel.h"
#import "IRPageModel.h"
#import "NSString+Extension.h"
#import "IRReaderConfig.h"
#import "IRTocRefrence.h"
#import "IRResource.h"
#import <NSAttributedString+HTML.h>
#import <DTCoreTextLayouter.h>
#import <DTCoreTextConstants.h>
#import <DTCoreTextParagraphStyle.h>
#import <DTCoreTextLayoutLine.h>

@implementation IRChapterModel

+ (instancetype)modelWithTocRefrence:(IRTocRefrence *)tocRefrence chapterIndex:(NSUInteger)chapterIndex
{
    IRChapterModel *model = [[self alloc] init];
    NSURL *baseUrl = [[NSURL alloc] initFileURLWithPath:tocRefrence.resource.fullHref];
    NSData *htmlData = [NSData dataWithContentsOfURL:baseUrl];

    NSDictionary *options = @{
                              DTDefaultFontFamily : @"Times New Roman",
                              DTDefaultLinkColor  : @"purple",
                              DTDefaultFontSize   : @15,
                              NSBaseURLDocumentOption : baseUrl,
                              DTMaxImageSize      : [NSValue valueWithCGSize:[IR_READER_CONFIG pageSize]]
                            };
    
    NSMutableAttributedString *htmlString = [[[NSAttributedString alloc] initWithHTMLData:htmlData options:options documentAttributes:nil] mutableCopy];
//    NSMutableParagraphStyle *customStyle = [[NSMutableParagraphStyle alloc] init];
//    customStyle.lineSpacing = 5;
//    customStyle.paragraphSpacing = 20;
//    customStyle.lineHeightMultiple = 2;
//    customStyle.alignment = NSTextAlignmentJustified;
    [htmlString addAttribute:NSParagraphStyleAttributeName
                       value:[self customParagraphStyleWithFirstLineHeadIndent:YES]
                       range:NSMakeRange(0, htmlString.length)];
    
    DTCoreTextLayouter *textLayout = [[DTCoreTextLayouter alloc] initWithAttributedString:htmlString];
    CGRect rect = CGRectMake(0, 0, [IR_READER_CONFIG pageSize].width, [IR_READER_CONFIG pageSize].height);
    DTCoreTextLayoutFrame *layoutFrame = [textLayout layoutFrameWithRect:rect range:NSMakeRange(0, htmlString.length)];
    
    [layoutFrame.lines enumerateObjectsUsingBlock:^(DTCoreTextLayoutLine  *_Nonnull line, NSUInteger idx, BOOL * _Nonnull stop) {
        if (line.attachments.count) {
            [htmlString addAttribute:NSParagraphStyleAttributeName
                               value:[self customParagraphStyleWithFirstLineHeadIndent:NO]
                               range:line.stringRange];
        } else if (line.paragraphStyle) {
            
        }
        IRDebugLog(@"%@ range: %@", line, NSStringFromRange(line.stringRange));
    }];
    
    
    NSRange visibleRange = layoutFrame.visibleStringRange;
    CGFloat pageOffset = visibleRange.location + visibleRange.length;
    NSUInteger pageCount = 1;
    NSMutableArray *pages = [[NSMutableArray alloc] init];
    
    while (pageOffset <= htmlString.length && pageOffset != 0) {
        
        IRPageModel *pageModel = [[IRPageModel alloc] init];
        pageModel.content = [htmlString attributedSubstringFromRange:visibleRange];
        pageModel.pageIndex = pageCount - 1;
        pageModel.chapterIndex = chapterIndex;
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

+ (NSMutableParagraphStyle *)customParagraphStyleWithFirstLineHeadIndent:(BOOL)need
{
    NSMutableParagraphStyle *customStyle = [[NSMutableParagraphStyle alloc] init];
    customStyle.lineSpacing = 5;
    customStyle.paragraphSpacing = 20;
    customStyle.lineHeightMultiple = 2;
    customStyle.alignment = NSTextAlignmentJustified;
    customStyle.firstLineHeadIndent = need ? [UIFont systemFontOfSize:15].pointSize * 2 : 0;
    
    return customStyle;
}

@end
