//
//  IRChapterModel.h
//  iReader
//
//  Created by zzyong on 2018/7/25.
//  Copyright © 2018年 zouzhiyong. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IRHtmlModel, IRPageModel;

@interface IRChapterModel : NSObject

@property (nonatomic, strong) NSArray<IRPageModel *> *contents;
@property (nonatomic, assign) NSUInteger pages;

+ (instancetype)modelWithHtmlModel:(IRHtmlModel *)htmlModel;

@end
