//
//  IRPageViewController.h
//  iReader
//
//  Created by zzyong on 2018/8/17.
//  Copyright © 2018年 zouzhiyong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IRPageViewController;

@protocol IRPageViewControllerDelegate <NSObject>

@optional
- (void)pageViewController:(IRPageViewController *)pageViewController didScrollingToNextPage:(BOOL)isNext;

@end

@interface IRPageViewController : UIPageViewController

@property (nonatomic, weak) id<IRPageViewControllerDelegate> irDelegate;

@property (nonatomic, assign) BOOL currentVcDidFinishDisplaying;

@end
