//
//  IREpubBook.h
//  iReader
//
//  Created by zzyong on 2018/7/9.
//  Copyright © 2018年 zouzhiyong. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IRAuthor;

@interface IREpubBook : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *version;
@property (nonatomic, strong) IRAuthor *author;

@end
