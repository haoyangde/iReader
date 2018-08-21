//
//  IRChapterModel.h
//  iReader
//
//  Created by zzyong on 2018/7/25.
//  Copyright © 2018年 zouzhiyong. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IRHtmlModel, IRPageModel, IRTocRefrence;

@interface IRChapterModel : NSObject

@property (nonatomic, strong) NSArray<IRPageModel *> *pages;
@property (nonatomic, assign) NSUInteger pageCount;

+ (instancetype)modelWithTocRefrence:(IRTocRefrence *)tocRefrence chapterIndex:(NSUInteger)chapterIndex;

@end
