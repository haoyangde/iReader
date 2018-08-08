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
#import <YYText.h>
#import "NSString+Extension.h"
#import "IRReaderConfig.h"

@implementation IRChapterModel

+ (instancetype)modelWithHtmlModel:(IRHtmlModel *)htmlMode
{
    IRChapterModel *model = [[self alloc] init];
    
    __block CGFloat textHeight = 0;
    __block NSUInteger pages = 0;
    __block NSMutableArray *contents = [[NSMutableArray alloc] init];
    __block NSMutableAttributedString *pageContent = [[NSMutableAttributedString alloc] init];
    __block NSMutableAttributedString *nextPageContent = nil;
    
    [htmlMode.contents enumerateObjectsUsingBlock:^(NSDictionary<NSString *,NSObject *> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSObject * _Nonnull obj, BOOL * _Nonnull stop) {
            
            YYTextLayout *layout = nil;
            NSAttributedString *contentAtt = nil;
            if ([key isEqualToString:@"p"]) {
                contentAtt = [(NSString *)obj attributedStringWithFontSize:[IR_READER_CONFIG commonFontSize]];
            }
            else if ([key isEqualToString:@"h"]) {
                contentAtt = [(NSString *)obj attributedStringWithBoldFontSize:[IR_READER_CONFIG commonFontSize] textAlignment:NSTextAlignmentCenter];
            }
            else if ([key isEqualToString:@"h1"]) {
                contentAtt = [(NSString *)obj attributedStringWithBoldFontSize:[IR_READER_CONFIG H1FontSize] textAlignment:NSTextAlignmentCenter];
            }
            else if ([key isEqualToString:@"h2"]) {
                contentAtt = [(NSString *)obj attributedStringWithBoldFontSize:[IR_READER_CONFIG H2FontSize] textAlignment:NSTextAlignmentCenter];
            }
            else if ([key isEqualToString:@"h3"]) {
                contentAtt = [(NSString *)obj attributedStringWithBoldFontSize:[IR_READER_CONFIG H3FontSize] textAlignment:NSTextAlignmentCenter];
            }
            else if ([key isEqualToString:@"img"]) {
                
            }
            else if ([key isEqualToString:@"a"]) {
                
            }
            
            BOOL shouldAddPage = NO;
            if (contentAtt.string.length) {
                layout = [YYTextLayout layoutWithContainerSize:[IR_READER_CONFIG pageSize] text:contentAtt];
                textHeight += layout.textBoundingSize.height;
                
                if (textHeight > [IR_READER_CONFIG pageSize].height) {
                    CGFloat offset = textHeight - [IR_READER_CONFIG pageSize].height + 3;
                    NSArray<YYTextLine *> *lines = layout.lines;
                    YYTextLine *line = lines.firstObject;
                    NSUInteger visibleRows = (int)(offset / (line.height + 3));
                    YYTextLine *maxLine = [lines objectAtIndex:visibleRows];
                    NSAttributedString *subAtt = [contentAtt attributedSubstringFromRange:NSMakeRange(0, maxLine.range.location + maxLine.range.length)];
                    [pageContent appendAttributedString:subAtt];
                    nextPageContent = [[contentAtt attributedSubstringFromRange:NSMakeRange(maxLine.range.location, contentAtt.string.length - subAtt.string.length)] mutableCopy];
                    shouldAddPage = YES;
                } else {
                    [pageContent appendAttributedString:contentAtt];
                    textHeight += 10;
                    if (textHeight >= [IR_READER_CONFIG pageSize].height) {
                        shouldAddPage = YES;
                        nextPageContent = [[NSMutableAttributedString alloc] init];
                    }
                }
            }
            
            if (idx == htmlMode.contents.count - 1) {
                shouldAddPage = YES;
            }
            
            if (shouldAddPage) {
                textHeight = 0;
                pages++;
                IRPageModel *page = [IRPageModel modelWithContent:pageContent];
                [contents addObject:page];
                pageContent = nextPageContent;
                nextPageContent = nil;
            }
        }];
    }];
    
    model.pages = pages;
    model.contents = contents;
    
    return model;
}

@end
