//
//  IRPageViewController.m
//  iReader
//
//  Created by zzyong on 2018/8/17.
//  Copyright © 2018年 zouzhiyong. All rights reserved.
//

#import "IRPageViewController.h"

@interface IRPageViewController ()
<
UIGestureRecognizerDelegate,
UIScrollViewDelegate
>

@property (nonatomic, weak) UIScrollView *irQueuingScrollView;
@property (nonatomic, assign) CGPoint beginOffset;
@property (nonatomic, assign) BOOL scrollNextPage;

@end

@implementation IRPageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.currentVcDidFinishDisplaying = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setScrollViewDelegateForSelf];
    IRDebugLog(@"Gestures: %@", self.gestureRecognizers);
}

#pragma mark - Private

- (void)setScrollViewDelegateForSelf
{
    NSArray<UIView *> *subviews = self.view.subviews;
    for (UIView *subview in subviews) {
        if ([subview isKindOfClass:[UIScrollView class]]) {
            UIScrollView *scrollView = (UIScrollView *)subview;
            scrollView.delegate = self;
            self.irQueuingScrollView = scrollView;
            break;
        }
    }
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    IRDebugLog(@"");
    return self.currentVcDidFinishDisplaying;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.beginOffset = scrollView.contentOffset;
    IRDebugLog(@"%@", NSStringFromCGPoint(scrollView.contentOffset));
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x > self.beginOffset.x) {
        self.scrollNextPage = YES;
    } else if (scrollView.contentOffset.x < self.beginOffset.x){
        self.scrollNextPage = NO;
    } else {
        // Do nothing
    }
    
    if ([self.irDelegate respondsToSelector:@selector(pageViewController:didScrollingToNextPage:)]) {
        [self.irDelegate pageViewController:self didScrollingToNextPage:self.scrollNextPage];
    }
}

@end
