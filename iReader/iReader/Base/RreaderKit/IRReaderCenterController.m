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
#import "IRReaderSettingMenuView.h"

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
IRReaderNavigationViewDelegate,
UIScrollViewDelegate
>

@property (nonatomic, strong) dispatch_queue_t chapter_parse_serial_queue;
@property (nonatomic, strong) IREpubBook *book;
@property (nonatomic, strong) IRPageViewController *pageViewController;
@property (nonatomic, assign) NSUInteger chapterCount;
@property (nonatomic, assign) NSUInteger activityIndicatorViewTag;
@property (nonatomic, strong) NSMutableArray<IRChapterModel *> *chapters;
@property (nonatomic, assign) BOOL shouldHideStatusBar;
@property (nonatomic, strong) IRReaderNavigationView *readerNavigationView;
@property (nonatomic, strong) UINavigationBar *orilNavigationBar;
@property (nonatomic, assign) BOOL hideStatusBarAtFirstAppear;
@property (nonatomic, strong) NSMutableArray<IRReadingViewController *> *childViewControllersCache;
@property (nonatomic, assign) BOOL reloadDataIfNeeded;
@property (nonatomic, assign) CGPoint scrollBeginOffset;
@property (nonatomic, assign) BOOL isScrollToNext;
@property (nonatomic, strong) IRPageModel *currentPage;
@property (nonatomic, strong) IRPageModel *nextPage;
@property (nonatomic, strong) UIView *chapterLoadingHUD;

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
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (!self.hideStatusBarAtFirstAppear) {
        self.hideStatusBarAtFirstAppear = YES;
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

#pragma mark - Setter/Getter

- (NSMutableArray<IRChapterModel *> *)chapters
{
    if (!_chapters) {
        _chapters = [[NSMutableArray alloc] initWithCapacity:self.chapterCount];
    }
    
    return _chapters;
}

- (void)setReloadDataIfNeeded:(BOOL)reloadDataIfNeeded
{
    _reloadDataIfNeeded = reloadDataIfNeeded;
    
    if (reloadDataIfNeeded) {
        [self showChapterLoadingHUD];
    } else {
        [self dismissChapterLoadingHUD];
    }
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
    
    if (!self.shouldHideStatusBar) {
        IRReaderSettingMenuView *menuView = [IRReaderSettingMenuView readerSettingMenuView];
        [menuView showInView:self.view animated:YES];
    }
}

#pragma mark - Private

- (void)commonInit
{
    self.activityIndicatorViewTag = 999;
    self.chapter_parse_serial_queue = dispatch_queue_create("ir_chapter_parse_serial_queue", DISPATCH_QUEUE_SERIAL);
    self.shouldHideStatusBar = NO;
    self.hideStatusBarAtFirstAppear = NO;
    self.childViewControllersCache = [[NSMutableArray alloc] init];
    self.chapterCount = self.book.flatTableOfContents.count;
    IR_WEAK_SELF
    dispatch_async(self.chapter_parse_serial_queue, ^{
        [weakSelf parseTocRefrenceToChapterModelWithTocRefrences:weakSelf.book.flatTableOfContents];
    });
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
    IRPageViewController *pageViewController = [[IRPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    pageViewController.delegate = self;
    pageViewController.dataSource = self;
    if (pageViewController.scrollView) {
        pageViewController.scrollView.delegate = self;
    }
    [self addChildViewController:pageViewController];
    [pageViewController didMoveToParentViewController:self];
    [self.view addSubview:pageViewController.view];
    self.currentPage = self.chapters.firstObject.pages.firstObject;
    if (!self.currentPage) {
        self.reloadDataIfNeeded = YES;
    }
    IRDebugLog(@"Current chapter index: %zd page index: %zd", self.currentPage.chapterIndex, self.currentPage.pageIndex);
    IRReadingViewController *readVc = [self readingViewControllerWithPageModel:self.currentPage creatIfNoExist:YES];
    [pageViewController setViewControllers:@[readVc]
                                 direction:UIPageViewControllerNavigationDirectionForward
                                  animated:YES
                                completion:nil];
    self.pageViewController = pageViewController;
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
    
    IRDebugLog(@"Next readingViewController: %@", readVc);
    return readVc;
}

- (void)parseTocRefrenceToChapterModelWithTocRefrences:(NSArray<IRTocRefrence *> *)tocRefrences
{
    [tocRefrences enumerateObjectsUsingBlock:^(IRTocRefrence * _Nonnull toc, NSUInteger idx, BOOL * _Nonnull stop) {
        IRChapterModel *chapterModel = [IRChapterModel modelWithTocRefrence:toc chapterIndex:idx];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self parseChapterCompletedWithChater:chapterModel];
        });
    }];
}

- (void)parseChapterCompletedWithChater:(IRChapterModel *)chapter
{
    IRDebugLog(@"Chapter parse successed with index: %zd title: %@", chapter.chapterIndex, chapter.title);
    [self.chapters addObject:chapter];
    if (self.reloadDataIfNeeded) {
        [self reloadDataWithChapter:chapter];
        self.reloadDataIfNeeded = NO;
    }
}

- (void)reloadDataWithChapter:(IRChapterModel *)chapter
{
    IRReadingViewController *currentVc = self.pageViewController.childViewControllers.firstObject;
    currentVc.pageModel = chapter.pages.firstObject;
    self.currentPage = currentVc.pageModel;
    IRDebugLog(@"Current chapter index: %zd page index: %zd", self.currentPage.chapterIndex, self.currentPage.pageIndex);
}

#pragma mark - Loading HUD

- (void)showChapterLoadingHUD
{
    UIActivityIndicatorView *loadingView = nil;
    if (!self.chapterLoadingHUD) {
        self.chapterLoadingHUD = [[UIView alloc] init];
        self.chapterLoadingHUD.backgroundColor = [UIColor clearColor];
        loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        loadingView.hidesWhenStopped = YES;
        loadingView.color = IR_READER_CONFIG.appThemeColor;
        loadingView.tag = self.activityIndicatorViewTag;
        [self.chapterLoadingHUD addSubview:loadingView];
    }
    
    loadingView.frame = self.view.bounds;
    self.chapterLoadingHUD.frame = self.view.bounds;
    [self.view addSubview:self.chapterLoadingHUD];
    [self.view bringSubviewToFront:self.chapterLoadingHUD];
    [loadingView startAnimating];
    
    self.chapterLoadingHUD.alpha = 0;
    [UIView animateWithDuration:0.25 animations:^{
        self.chapterLoadingHUD.alpha = 1;
    }];
}

- (void)dismissChapterLoadingHUD
{
    UIActivityIndicatorView *loadingView = [self.chapterLoadingHUD viewWithTag:self.activityIndicatorViewTag];
    [loadingView stopAnimating];
    [UIView animateWithDuration:0.25 animations:^{
        self.chapterLoadingHUD.alpha = 0;
    } completion:^(BOOL finished) {
        [self.chapterLoadingHUD removeFromSuperview];
        self.chapterLoadingHUD.alpha = 1;
    }];
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

#pragma mark - UIPageViewController ScrollView

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.scrollBeginOffset = scrollView.contentOffset;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (!self.isScrollToNext && scrollView.contentOffset.x > self.scrollBeginOffset.x) {
        self.isScrollToNext = YES;
    } else if (self.isScrollToNext && scrollView.contentOffset.x < self.scrollBeginOffset.x) {
        self.isScrollToNext = NO;
    }
    
    if (!scrollView.isTracking &&
        !self.pageViewController.gestureRecognizerShouldBegin &&
        self.pageViewController.scrollView.userInteractionEnabled) {
        
        self.pageViewController.scrollView.userInteractionEnabled = NO;
    }
}

#pragma mark - UIPageViewController

- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers
{
    self.pageViewController.gestureRecognizerShouldBegin = NO;

    if (UIPageViewControllerTransitionStyleScroll == pageViewController.transitionStyle) {
        
        IRReadingViewController *pending = (IRReadingViewController *)pendingViewControllers.firstObject;
        IRPageModel *nextPage = nil;
        NSUInteger pageIndex  = self.currentPage.pageIndex;
        NSUInteger chapterIndex = self.currentPage.chapterIndex;
        
        if (self.isScrollToNext) {

            IRChapterModel *currentChapter = [self.chapters safeObjectAtIndex:chapterIndex];
            if (pageIndex < currentChapter.pages.count - 1) {
                pageIndex++;
                nextPage = [currentChapter.pages safeObjectAtIndex:pageIndex];
            } else {
                if (chapterIndex < self.chapterCount - 1) {
                    chapterIndex++;
                    if (chapterIndex > self.chapters.count - 1) {
                        self.reloadDataIfNeeded = YES;
                    } else {
                        IRChapterModel *chapter = [self.chapters safeObjectAtIndex:chapterIndex];
                        nextPage = chapter.pages.firstObject;
                    }
                }
            }
        } else {

            IRChapterModel *chapter = nil;
            if (pageIndex > 0) {
                pageIndex--;
                chapter = [self.chapters safeObjectAtIndex:chapterIndex];
                nextPage = [chapter.pages safeObjectAtIndex:pageIndex];
            } else {

                if (chapterIndex > 0) {
                    chapterIndex--;
                    chapter = [self.chapters safeObjectAtIndex:chapterIndex];
                    nextPage = chapter.pages.lastObject;
                }
            }
        }
        
        if (nextPage) {
            self.nextPage = nextPage;
            pending.pageModel = nextPage;
        }
    }
    
    IRDebugLog(@"pageViewController childViewControllers: %@ pendingViewControllers: %@", pageViewController.childViewControllers, pendingViewControllers);
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed
{
    if (!completed) {
        self.reloadDataIfNeeded = NO;
    }
    
    if (completed && previousViewControllers.count) {
         [self cacheReadingViewController:previousViewControllers.firstObject];
    }
    
    if (completed && self.nextPage) {
        self.currentPage = self.nextPage;
    }
    IRDebugLog(@"Current chapter index: %zd page index: %zd", self.currentPage.chapterIndex, self.currentPage.pageIndex);
    
    self.nextPage = nil;
    self.pageViewController.scrollView.userInteractionEnabled = YES;
    self.pageViewController.gestureRecognizerShouldBegin = YES;
    
    IRDebugLog(@"previousViewControllers: %@", previousViewControllers);
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
    
    if (UIPageViewControllerTransitionStylePageCurl == pageViewController.transitionStyle) {
        self.currentPage = beforePage;
    }
    
    IRDebugLog(@"BeforeViewController: %@", viewController);
    return [self readingViewControllerWithPageModel:beforePage creatIfNoExist:YES];
}

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    IRPageModel *afterPage = nil;
    IRReadingViewController *readVc = (IRReadingViewController *)viewController;
    NSUInteger pageIndex = readVc.pageModel.pageIndex;
    NSUInteger chapterIndex = readVc.pageModel.chapterIndex;
    IRChapterModel *currentChapter = [self.chapters safeObjectAtIndex:chapterIndex];
    
    if (pageIndex < currentChapter.pages.count - 1) {
        pageIndex = pageIndex + 1;
        afterPage = [currentChapter.pages safeObjectAtIndex:pageIndex];
    } else {
        if (chapterIndex < self.chapterCount - 1) {
            chapterIndex++;
            if (chapterIndex > self.chapters.count - 1) {
                self.reloadDataIfNeeded = YES;
            } else {
                IRChapterModel *chapter = [self.chapters safeObjectAtIndex:chapterIndex];
                afterPage = chapter.pages.firstObject;
            }
        } else {
            return nil;
        }
    }
    
    if (UIPageViewControllerTransitionStylePageCurl == pageViewController.transitionStyle) {
        self.currentPage = afterPage;
    }
    
    IRDebugLog(@"AfterViewController: %@", viewController);
    return [self readingViewControllerWithPageModel:afterPage creatIfNoExist:YES];
}

#pragma mark - Public

- (instancetype)initWithBook:(IREpubBook *)book
{
    if (self = [super init]) {
        self.book = book;
    }

    return self;
}

@end
