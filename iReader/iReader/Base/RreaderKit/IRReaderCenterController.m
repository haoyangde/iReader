//
//  IRReaderCenterController.m
//  iReader
//
//  Created by zzyong on 2018/8/6.
//  Copyright © 2018年 zouzhiyong. All rights reserved.
//

#import "IRReaderCenterController.h"
#import "BookChapterListController.h"
#import "IRPageViewController.h"
#import "IRReadingViewController.h"

// view
#import "IRReaderNavigationView.h"

// model
#import "IRTocRefrence.h"
#import "IREpubBook.h"
#import "IRChapterModel.h"
#import "IRResource.h"
#import "IRPageModel.h"

// other
#import "AppDelegate.h"

@interface IRReaderCenterController ()
<
UIPageViewControllerDataSource,
UIPageViewControllerDelegate,
IRReaderNavigationViewDelegate
>

@property (nonatomic, strong) IRPageViewController *pageViewController;
@property (nonatomic, strong) NSArray<IRChapterModel *> *chapters;
@property (nonatomic, assign) BOOL shouldHideStatusBar;
@property (nonatomic, strong) IRReaderNavigationView *readerNavigationView;
@property (nonatomic, strong) UINavigationBar *orilNavigationBar;
@property (nonatomic, assign) BOOL hadHideStatusBarOnce;
@property (nonatomic, strong) NSMutableArray<IRReadingViewController *> *childViewControllersCache;

@end

@implementation IRReaderCenterController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self commonInit];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.readerNavigationView shouldHideAllCustomViews:NO];
    
    IRPageModel *pageModel = self.chapters.firstObject.pages.firstObject;
    IRReadingViewController *readVc = [self readingViewControllerWithPageModel:pageModel creatIfNoExist:YES];
    [self.pageViewController setViewControllers:@[readVc]
                                      direction:UIPageViewControllerNavigationDirectionForward
                                       animated:YES
                                     completion:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (!self.hadHideStatusBarOnce) {
        self.hadHideStatusBarOnce = YES;
        self.shouldHideStatusBar = YES;
        [self setNeedsStatusBarAppearanceUpdate];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.readerNavigationView shouldHideAllCustomViews:YES];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.pageViewController.view.frame = self.view.bounds;
}

#pragma mark - StatusBarHidden

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

- (BOOL)prefersStatusBarHidden
{
    return self.shouldHideStatusBar;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation
{
    return UIStatusBarAnimationSlide;
}

#pragma mark - Gesture

- (void)setupGestures
{
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onSingleTap:)];
    singleTap.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:singleTap];
}

- (void)onSingleTap:(UIGestureRecognizer *)recognizer
{
    self.shouldHideStatusBar = !self.shouldHideStatusBar;
    [UIView animateWithDuration:0.25 animations:^{
        [self setNeedsStatusBarAppearanceUpdate];
    }];
    [self.navigationController setNavigationBarHidden:self.shouldHideStatusBar animated:YES];
}

#pragma mark - Private

- (void)commonInit
{
    self.shouldHideStatusBar = NO;
    self.hadHideStatusBarOnce = NO;
    [self setupPageViewController];
    [self setupNavigationbar];
    [self setupGestures];
}

- (void)setupNavigationbar
{
    if ([self.navigationController respondsToSelector:@selector(navigationBar)]) {
        [self.navigationController setValue:self.readerNavigationView forKeyPath:@"navigationBar"];
    } else {
        NSAssert(NO, @"UINavigationController does not recognize selector : navigationBar");
    }
}

- (void)setupPageViewController
{
    IRPageViewController *pageViewController = [[IRPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:@{UIPageViewControllerOptionSpineLocationKey : @(UIPageViewControllerSpineLocationNone)}];
    pageViewController.delegate = self;
    pageViewController.dataSource = self;
    [self addChildViewController:pageViewController];
    [pageViewController didMoveToParentViewController:self];
    [self.view addSubview:pageViewController.view];
    self.pageViewController = pageViewController;
    self.childViewControllersCache = [[NSMutableArray alloc] init];
}

- (IRReaderNavigationView *)readerNavigationView
{
    if (_readerNavigationView == nil) {
        _readerNavigationView = [[IRReaderNavigationView alloc] init];
        _readerNavigationView.actionDelegate = self;
    }
    
    return _readerNavigationView;
}

- (void)cacheReadingViewController:(UIViewController *)readingVc
{
    if ([readingVc isKindOfClass:[IRReadingViewController class]]) {
        [self.childViewControllersCache addObject:(IRReadingViewController *)readingVc];
    }
}

- (IRReadingViewController *)readingViewControllerWithPageModel:(IRPageModel *)pageModel creatIfNoExist:(BOOL)flag
{
    IRReadingViewController *readVc = nil;
    if (self.childViewControllersCache.count) {
        readVc = self.childViewControllersCache.lastObject;
        [self.childViewControllersCache removeLastObject];
    } else {
        if (flag) {
            readVc = [[IRReadingViewController alloc] init];
        }
    }
    
    if (readVc) {
        readVc.view.frame = self.pageViewController.view.bounds;
        readVc.pageModel = pageModel;
    }
    
    return readVc;
}

#pragma mark - IRReaderNavigationViewDelegate

- (void)readerNavigationViewDidClickChapterListButton:(IRReaderNavigationView *)aView
{
    BookChapterListController *chapterVc = [[BookChapterListController alloc] init];
    chapterVc.chapterList = self.book.flatTableOfContents;
    [self.navigationController pushViewController:chapterVc animated:YES];
}

- (void)readerNavigationViewDidClickCloseButton:(IRReaderNavigationView *)aView
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIPageViewController

- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers
{
    self.pageViewController.gestureRecognizerShouldBegin = NO;
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed
{
    if (completed && previousViewControllers.count) {
         [self cacheReadingViewController:previousViewControllers.firstObject];
    }
    
    self.pageViewController.gestureRecognizerShouldBegin = YES;
}

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    IRPageModel *beforePage = nil;
    IRChapterModel *chapter = nil;
    IRReadingViewController *readVc = (IRReadingViewController *)viewController;
    NSUInteger pageIndex = readVc.pageModel.pageIndex;
    NSUInteger chapterIndex = readVc.pageModel.chapterIndex;
    
    if (pageIndex > 0) {
        pageIndex--;
        chapter = [self.chapters safeObjectAtIndex:chapterIndex];
        beforePage = [chapter.pages safeObjectAtIndex:pageIndex];
    } else {
        
        if (chapterIndex > 0) {
            chapterIndex--;
            chapter = [self.chapters safeObjectAtIndex:chapterIndex];
            beforePage = chapter.pages.lastObject;
        } else {
            return nil;
        }
    }
    
    return [self readingViewControllerWithPageModel:beforePage creatIfNoExist:YES];
}

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    IRPageModel *afterPage = nil;
    IRReadingViewController *readVc = (IRReadingViewController *)viewController;
    NSUInteger pageIndex = readVc.pageModel.pageIndex;
    NSUInteger chapterIndex = readVc.pageModel.chapterIndex;
    IRChapterModel *currentChapter = [self.chapters safeObjectAtIndex:chapterIndex];
    
    if (pageIndex < currentChapter.pages.count) {
        if (pageIndex == currentChapter.pages.count - 1) {
            if (chapterIndex < self.chapters.count) {
                if (chapterIndex == self.chapters.count - 1) {
                    return nil;
                } else {
                    chapterIndex++;
                    IRChapterModel *chapter = [self.chapters safeObjectAtIndex:chapterIndex];
                    afterPage = chapter.pages.firstObject;
                }
            }
        } else {
            pageIndex = pageIndex + 1;
            afterPage = [currentChapter.pages safeObjectAtIndex:pageIndex];
        }
    }
    
    return [self readingViewControllerWithPageModel:afterPage creatIfNoExist:YES];
}

#pragma mark - Public

- (void)setBook:(IREpubBook *)book
{
    _book = book;
    
    __block NSMutableArray *tempChapters = [NSMutableArray arrayWithCapacity:book.tableOfContents.count];
    [book.flatTableOfContents enumerateObjectsUsingBlock:^(IRTocRefrence * _Nonnull toc, NSUInteger idx, BOOL * _Nonnull stop) {
        
        IRChapterModel *chapterModel = [IRChapterModel modelWithTocRefrence:toc chapterIndex:idx];
        [tempChapters addObject:chapterModel];
    }];
    
    self.chapters = tempChapters;
}

@end
