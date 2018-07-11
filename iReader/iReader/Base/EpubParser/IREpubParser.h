//
//  IREpubParser.h
//  iReader
//
//  Created by zouzhiyong on 2018/3/15.
//  Copyright © 2018年 zouzhiyong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IREpubBook;

typedef void(^ReadEpubCompletion)(IREpubBook *book, NSError *error);

@interface IREpubParser : NSObject

+ (instancetype)sharedInstance;

- (void)asyncReadEpubWithEpubName:(NSString *)epubName completion:(ReadEpubCompletion)completion;

@end

