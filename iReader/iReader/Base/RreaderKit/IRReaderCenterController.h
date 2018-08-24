//
//  IRReaderCenterController.h
//  iReader
//
//  Created by zzyong on 2018/8/6.
//  Copyright © 2018年 zouzhiyong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IREpubBook;

@interface IRReaderCenterController : UIViewController

- (instancetype)initWithBook:(IREpubBook *)book;

- (void)selectChapterAtIndex:(NSUInteger)chapterIndex;
- (void)selectChapterAtIndex:(NSUInteger)chapterIndex pageAtIndex:(NSUInteger)pageInadex;

@end
