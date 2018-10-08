//
//  MainViewController.m
//  iReader
//
//  Created by zouzhiyong on 2018/3/12.
//  Copyright © 2018年 zouzhiyong. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController () <UITabBarControllerDelegate>


@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self commonInit];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - setter/getter

- (void)setSelectedIndex:(NSUInteger)selectedIndex
{
    [super setSelectedIndex:selectedIndex];
    [self updateNavigationItemsForIndex:selectedIndex];
}

#pragma mark - UITabBarControllerDelegate

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    [self updateNavigationItemsForIndex:[tabBarController.viewControllers indexOfObject:viewController]];
}

#pragma mark - private

- (void)commonInit
{
    self.delegate = self;
    [self setupTabbarItems];
    if (self.selectedIndex != 0) {
        self.selectedIndex = 0;
    }
}

- (void)setupTabbarItems
{
    self.tabBar.tintColor = APP_THEME_COLOR;
    [self.tabBar.items enumerateObjectsUsingBlock:^(UITabBarItem * _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UIImage *normalImg = nil;
        UIImage *selectImg = nil;
        if (idx == IRMainTabIndexHome) {
            normalImg = [UIImage imageNamed:@"tabbar_home_n"];
            selectImg = [[UIImage imageNamed:@"tabbar_home_s"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        } else if (idx == IRMainTabIndexDiscovery) {
            normalImg = [UIImage imageNamed:@"tabbar_discovery_n"];
            selectImg = [[UIImage imageNamed:@"tabbar_discovery_s"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        }
        [item setImage:normalImg];
        [item setSelectedImage:selectImg];
    }];
}

- (void)updateNavigationItemsForIndex:(IRMainTabIndex)index
{
    self.navigationItem.rightBarButtonItem  = nil;
    self.navigationItem.rightBarButtonItems = nil;
    self.navigationItem.leftBarButtonItem   = nil;
    
    switch (index) {
        case IRMainTabIndexHome: {
            self.navigationItem.title = self.selectedViewController.navigationItem.title;
            self.navigationItem.rightBarButtonItem = self.selectedViewController.navigationItem.rightBarButtonItem;
            break;
        }
            
        case IRMainTabIndexDiscovery: {
            self.navigationItem.title = self.selectedViewController.navigationItem.title;
            break;
        }
    }
}

@end
