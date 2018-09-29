//
//  UIViewController+IRNavigationBar.m
//  iReader
//
//  Created by zzyong on 2018/9/29.
//  Copyright © 2018年 zouzhiyong. All rights reserved.
//

#import "UIViewController+IRNavigationBar.h"

@implementation UIViewController (IRNavigationBar)

- (void)setupLeftBackBarButton
{
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"arrow_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                             style:UIBarButtonItemStylePlain
                                                            target:self
                                                            action:@selector(onClickedLeftBackItem:)];
    self.navigationItem.leftBarButtonItem = back;
}

- (void)onClickedLeftBackItem:(UIBarButtonItem *)item
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
