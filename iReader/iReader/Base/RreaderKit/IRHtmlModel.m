//
//  IRHtmlModel.m
//  iReader
//
//  Created by zzyong on 2018/7/25.
//  Copyright © 2018年 zouzhiyong. All rights reserved.
//

#import "IRHtmlModel.h"

@implementation IRHtmlModel

+ (instancetype)modelWithHtmlString:(NSString *)htmlString
{
    IRHtmlModel *htmlModel = nil;
    
    NSRange bodyBegin = [htmlString rangeOfString:@"<body>"];
    NSRange bodyEnd = [htmlString rangeOfString:@"</body>"];
    
    if (bodyBegin.location == NSNotFound || bodyEnd.location == NSNotFound) {
        return htmlModel;
    }
    
    NSUInteger bodyLocation = bodyBegin.location + bodyBegin.length;
    NSString *htmlBody = [htmlString substringWithRange:NSMakeRange(bodyLocation, bodyEnd.location - bodyLocation)];
    
    NSCharacterSet *stopCharacters = [NSCharacterSet characterSetWithCharactersInString:[NSString stringWithFormat:@"< \t\n\r%C%C%C%C", 0x0085, 0x000C, 0x2028, 0x2029]];
    NSCharacterSet *newLineAndWhitespaceCharacters = [NSCharacterSet characterSetWithCharactersInString:[NSString stringWithFormat:@" \t\n\r%C%C%C%C", 0x0085, 0x000C, 0x2028, 0x2029]];
    NSCharacterSet *tagNameCharacters = [NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"];
    
    // Scan and find all tags
    NSMutableArray<NSDictionary *> *contents = [[NSMutableArray alloc] init];
    NSMutableString *result = [[NSMutableString alloc] initWithCapacity:htmlBody.length];
    NSScanner *scanner = [[NSScanner alloc] initWithString:htmlBody];
    [scanner setCharactersToBeSkipped:nil];
    [scanner setCaseSensitive:YES];
    NSString *str = nil, *tagName = nil, *linkString = nil;
    BOOL dontReplaceTagWithSpace = NO;
    
    while (![scanner isAtEnd]) {
        
        BOOL needResetResult = NO;
        // Scan up to the start of a tag or whitespace
        if ([scanner scanUpToCharactersFromSet:stopCharacters intoString:&str]) {
            [result appendString:str];
            str = nil;
        }
        
        // Check if we've stopped at a tag/comment or whitespace
        if ([scanner scanString:@"<" intoString:NULL]) {
            // comment
            if ([scanner scanString:@"!--" intoString:NULL]) {
                [scanner scanUpToString:@"-->" intoString:NULL];
                [scanner scanString:@"-->" intoString:NULL];
                
            } else {
                
                // Tag - remove and replace with space unless it's
                if ([scanner scanString:@"/p" intoString:NULL]) {
                    if (result.length) {
                        [result appendString:@"\n"];
                        [contents addObject:@{@"p" : [result copy]}];
                        needResetResult = YES;
                    }
                }
                
                // <a class="link" href="http://www.epubbooks.com" target="_top">www.epubbooks.com</a>
                if ([scanner scanString:@"a" intoString:NULL]) {
                    [scanner scanUpToString:@"href" intoString:NULL];
                    [scanner scanString:@"href" intoString:NULL];
                    [scanner scanString:@"=" intoString:NULL];
                    [scanner scanString:@"\'" intoString:NULL];
                    [scanner scanString:@"\"" intoString:NULL];
                    
                    [scanner scanUpToCharactersFromSet:[NSCharacterSet characterSetWithCharactersInString:@"\"\'"] intoString:&linkString];
                }
                
                if ([scanner scanString:@"/a" intoString:NULL]) {
                    if (result.length) {
                        [contents addObject:@{@"a" : @{@"href" : linkString ?: @"", @"content" : [result copy]}}];
                        linkString = nil;
                        needResetResult = YES;
                    }
                }
                
                if ([scanner scanString:@"/h1" intoString:NULL]) {
                    if (result.length) {
                        [result appendString:@"\n"];
                        [contents addObject:@{@"h1" : [result copy]}];
                        needResetResult = YES;
                    }
                } else if ([scanner scanString:@"/h2" intoString:NULL]) {
                    if (result.length) {
                        [result appendString:@"\n"];
                        [contents addObject:@{@"h2" : [result copy]}];
                        needResetResult = YES;
                    }
                    
                } else if ([scanner scanString:@"/h3" intoString:NULL]) {
                    if (result.length) {
                        [result appendString:@"\n"];
                        [contents addObject:@{@"h3" : [result copy]}];
                        needResetResult = YES;
                    }
                } else if ([scanner scanString:@"/h" intoString:NULL]) {
                    if (result.length) {
                        [result appendString:@"\n"];
                        [contents addObject:@{@"h" : [result copy]}];
                        needResetResult = YES;
                    }
                }
                
                if ([scanner scanString:@"img" intoString:NULL]) {
                    [scanner scanUpToString:@"src" intoString:NULL];
                    [scanner scanString:@"src" intoString:NULL];
                    [scanner scanString:@"=" intoString:NULL];
                    [scanner scanString:@"\'" intoString:NULL];
                    [scanner scanString:@"\"" intoString:NULL];
                    NSString *imgString = nil;
                    if ([scanner scanUpToCharactersFromSet:[NSCharacterSet characterSetWithCharactersInString:@"\"\'"] intoString:&imgString]) {
                        if (imgString.length) {
                            [contents addObject:@{@"img" : [imgString copy]}];
                        }
                    }
                }
                
                if (needResetResult) {
                    [result setString:@""];
                }
                
                // a closing inline tag then dont replace with a space
                if ([scanner scanString:@"/" intoString:NULL]) {
                    
                    // Closing tag - replace with space unless it's inline
                    tagName = nil; dontReplaceTagWithSpace = NO;
                    if ([scanner scanCharactersFromSet:tagNameCharacters intoString:&tagName]) {
                        tagName = [tagName lowercaseString];
                        dontReplaceTagWithSpace = ([tagName isEqualToString:@"a"] ||
                                                   [tagName isEqualToString:@"b"] ||
                                                   [tagName isEqualToString:@"i"] ||
                                                   [tagName isEqualToString:@"q"] ||
                                                   [tagName isEqualToString:@"span"] ||
                                                   [tagName isEqualToString:@"em"] ||
                                                   [tagName isEqualToString:@"strong"] ||
                                                   [tagName isEqualToString:@"cite"] ||
                                                   [tagName isEqualToString:@"abbr"] ||
                                                   [tagName isEqualToString:@"acronym"] ||
                                                   [tagName isEqualToString:@"label"]);
                    }
                    
                    // Replace tag with string unless it was an inline
                    if (!dontReplaceTagWithSpace && result.length > 0 && ![scanner isAtEnd]) {
                        [result appendString:@" "];
                    }
                }
                
                // Scan past tag
                [scanner scanUpToString:@">" intoString:NULL];
                [scanner scanString:@">" intoString:NULL];
            }
        } else {
            // Stopped at whitespace - replace all whitespace and newlines with a space
            if ([scanner scanCharactersFromSet:newLineAndWhitespaceCharacters intoString:NULL]) {
                if (result.length > 0 && ![scanner isAtEnd]) {
                    [result appendString:@" "]; // Dont append space to beginning or end of result
                }
            }
        }
    }
    
    if (contents.count) {
        htmlModel = [[IRHtmlModel alloc] init];
        htmlModel.contents = contents;
    }
    
    return htmlModel;
}

@end
