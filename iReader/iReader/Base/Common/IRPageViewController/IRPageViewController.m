//
//  IRPageViewController.m
//  iReader
//
//  Created by zzyong on 2018/8/17.
//  Copyright © 2018年 zouzhiyong. All rights reserved.
//

#import "IRPageViewController.h"

@interface IRPageViewController () <UIGestureRecognizerDelegate>

@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, weak) UITapGestureRecognizer *tapGesture;
@property (nonatomic, weak) UIPanGestureRecognizer *panGesture;

@end

@implementation IRPageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.gestureRecognizerShouldBegin = YES;
}

#pragma mark - Public

- (UITapGestureRecognizer *)tapGesture
{
    if (!_tapGesture && self.gestureRecognizers.count) {
        [self.gestureRecognizers enumerateObjectsUsingBlock:^(__kindof UIGestureRecognizer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[UITapGestureRecognizer class]]) {
                _tapGesture = obj;
                *stop = YES;
            }
        }];
    }
    
    return _tapGesture;
}

- (UIPanGestureRecognizer *)panGesture
{
    if (!_panGesture && self.gestureRecognizers.count) {
        [self.gestureRecognizers enumerateObjectsUsingBlock:^(__kindof UIGestureRecognizer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[UIPanGestureRecognizer class]]) {
                _panGesture = obj;
                *stop = YES;
            }
        }];
    }
    
    return _panGesture;
}

- (UIScrollView *)scrollView
{
    if (!_scrollView && (self.transitionStyle == UIPageViewControllerTransitionStyleScroll)) {
        for (UIView *subview in self.view.subviews) {
            if ([subview isKindOfClass:[UIScrollView class]]) {
                _scrollView = (UIScrollView *)subview;
                break;
            }
        }
    }
    return _scrollView;
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return self.gestureRecognizerShouldBegin;
}

@end
