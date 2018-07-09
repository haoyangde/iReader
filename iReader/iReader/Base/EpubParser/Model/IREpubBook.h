//
//  IREpubBook.h
//  iReader
//
//  Created by zzyong on 2018/7/9.
//  Copyright © 2018年 zouzhiyong. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IRAuthor, IRMetadata, IRContainer;

@interface IREpubBook : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) IRContainer *container;
@property (nonatomic, strong) IRAuthor *author;
@property (nonatomic, strong) IRMetadata *metadata;

@end
