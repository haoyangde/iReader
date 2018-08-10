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
            
            YYTextLayout *textLayout = nil;
            NSAttributedString *contentAtt = nil;
            if ([key isEqualToString:@"img"]) {
                
            } else if ([key isEqualToString:@"a"]) {
                
            } else {
                NSDictionary *textAttributes = nil;
                if ([key isEqualToString:@"p"]) {
                    textAttributes = [self textAttributesWithAlignment:NSTextAlignmentJustified bold:NO];
                } else {
                    textAttributes = [self textAttributesWithAlignment:NSTextAlignmentCenter bold:YES];
                }
                contentAtt = [[NSAttributedString alloc] initWithString:(NSString *)obj
                                                             attributes:textAttributes];
            }
            
            if (contentAtt.string.length) {
                [pageContent appendAttributedString:contentAtt];
            }
            
            if (idx == htmlMode.contents.count - 1) {
                textLayout = [YYTextLayout layoutWithContainerSize:CGSizeMake([IR_READER_CONFIG pageSize].width, CGFLOAT_MAX) text:pageContent];
                NSUInteger linesOfPage = [textLayout.lines firstObject].height;
            }
            
//            if (shouldAddPage) {
//                textHeight = 0;
//                pages++;
//                IRPageModel *page = [IRPageModel modelWithContent:pageContent];
//                [contents addObject:page];
//                pageContent = nextPageContent;
//                nextPageContent = nil;
//            }
        }];
    }];
    
    model.pages = pages;
    model.contents = contents;
    
    return model;
}

+ (NSDictionary *)textAttributesWithAlignment:(NSTextAlignment)alignment bold:(BOOL)isBlod
{
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineSpacing = 3.0;
    if (alignment != NSTextAlignmentCenter) {
        paragraph.firstLineHeadIndent = 10;
    }
    paragraph.paragraphSpacing = 10;
    paragraph.alignment = alignment;
    
    UIFont *textFont = nil;
    if (isBlod) {
        textFont = [UIFont boldSystemFontOfSize:[IR_READER_CONFIG textFontSize]];
    } else {
        textFont = [UIFont systemFontOfSize:[IR_READER_CONFIG textFontSize]];
    }
    
    return @{
             NSForegroundColorAttributeName : [UIColor blackColor],
             NSFontAttributeName : textFont,
             NSParagraphStyleAttributeName : paragraph
             };
}
@end
