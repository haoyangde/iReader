//
//  IRNavigationController.m
//  iReader
//
//  Created by zzyong on 2018/7/13.
//  Copyright © 2018年 zouzhiyong. All rights reserved.
//

#import "IRNavigationController.h"

@interface IRNavigationController ()

@end

@implementation IRNavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationBar.translucent = NO;
    [IRUIUtilites appStatusBarMaxY];
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

@end
