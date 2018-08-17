//
//  IRPageViewController.m
//  iReader
//
//  Created by zzyong on 2018/8/17.
//  Copyright © 2018年 zouzhiyong. All rights reserved.
//

#import "IRPageViewController.h"

@interface IRPageViewController () <UIGestureRecognizerDelegate>

@end

@implementation IRPageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.currentVcDidFinishDisplaying = YES;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    IRDebugLog(@"");
    return self.currentVcDidFinishDisplaying;
}

@end
