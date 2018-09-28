//
//  IRReadingViewController.h
//  iReader
//
//  Created by zzyong on 2018/8/17.
//  Copyright © 2018年 zouzhiyong. All rights reserved.
//

#import "IRBaseViewController.h"

@class IRPageModel;

@interface IRReadingViewController : IRBaseViewController

@property (nonatomic, strong) IRPageModel *pageModel;

- (void)showChapterLoadingHUD;
- (void)dismissChapterLoadingHUD;

@end
