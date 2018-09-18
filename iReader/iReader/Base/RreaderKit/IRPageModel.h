//
//  IRPageModel.h
//  iReader
//
//  Created by zzyong on 2018/7/27.
//  Copyright © 2018年 zouzhiyong. All rights reserved.
//

#import "IRObject.h"

@interface IRPageModel : IRObject

@property (nonatomic, strong) NSAttributedString *content;
@property (nonatomic, assign) NSUInteger pageIndex;
@property (nonatomic, assign) NSUInteger chapterIndex;

+ (instancetype)modelWithContent:(NSAttributedString *)content;

@end
