//
//  IREpubBook.h
//  iReader
//
//  Created by zzyong on 2018/7/9.
//  Copyright © 2018年 zouzhiyong. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IRAuthor, IRResource, IRTocRefrence;

@interface IREpubBook : NSObject

/** 书名*/
@property (nonatomic, strong) NSString *name;
/** 版本*/
@property (nonatomic, strong) NSString *version;
/** 作者*/
@property (nonatomic, strong) IRAuthor *author;
/** 封面*/
@property (nonatomic, strong) IRResource *coverImage;
/** 目录*/
@property (nonatomic, strong) NSArray<IRTocRefrence *> *tableOfContents;

@end
