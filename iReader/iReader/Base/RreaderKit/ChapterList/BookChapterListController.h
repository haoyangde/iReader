//
//  BookChapterListController.h
//  iReader
//
//  Created by zzyong on 2018/7/13.
//  Copyright © 2018年 zouzhiyong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IRTocRefrence;

@interface BookChapterListController : UIViewController

@property (nonatomic, strong) NSArray<IRTocRefrence *> *chapterList;

@end
