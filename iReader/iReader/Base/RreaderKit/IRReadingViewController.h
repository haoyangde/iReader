//
//  IRReadingViewController.h
//  iReader
//
//  Created by zzyong on 2018/8/17.
//  Copyright © 2018年 zouzhiyong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IRPageModel;

@interface IRReadingViewController : UIViewController

@property (nonatomic, strong) IRPageModel *pageModel;

- (void)showChapterLoadingHUD;
- (void)dismissChapterLoadingHUD;

@end
