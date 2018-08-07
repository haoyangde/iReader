//
//  IRReaderCenterController.m
//  iReader
//
//  Created by zzyong on 2018/8/6.
//  Copyright © 2018年 zouzhiyong. All rights reserved.
//

#import "IRReaderCenterController.h"
#import "BookChapterListController.h"

// view
#import "IRChapterViewCell.h"
#import "IRReaderNavigationView.h"

// model
#import "IRTocRefrence.h"
#import "IREpubBook.h"
#import "IRChapterModel.h"
#import "IRResource.h"
#import "IRHtmlModel.h"

// other
#import "AppDelegate.h"

@interface IRReaderCenterController ()
<
UICollectionViewDelegateFlowLayout,
UICollectionViewDataSource,
IRReaderNavigationViewDelegate
>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray<IRChapterModel *> *chapters;
@property (nonatomic, assign) BOOL shouldHideStatusBar;
@property (nonatomic, strong) IRReaderNavigationView *readerNavigationView;
@property (nonatomic, strong) UINavigationBar *orilNavigationBar;
@property (nonatomic, assign) BOOL hadHideStatusBarOnce;

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
    
    self.collectionView.frame = self.view.bounds;
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
    [self setupCollectionView];
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

- (void)setupCollectionView
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.scrollDirection =  UICollectionViewScrollDirectionHorizontal;
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds
                                                          collectionViewLayout:flowLayout];
    collectionView.dataSource = self;
    collectionView.delegate   = self;
    collectionView.pagingEnabled = YES;
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.alwaysBounceHorizontal = YES;
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.showsHorizontalScrollIndicator = NO;
    
    if (@available(iOS 11.0, *)) {
        collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    [collectionView registerClass:[IRChapterViewCell class] forCellWithReuseIdentifier:@"IRChapterViewCell"];
    
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
}

- (IRReaderNavigationView *)readerNavigationView
{
    if (_readerNavigationView == nil) {
        _readerNavigationView = [[IRReaderNavigationView alloc] init];
        _readerNavigationView.actionDelegate = self;
    }
    
    return _readerNavigationView;
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

#pragma mark - UICollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.chapters.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    IRChapterViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"IRChapterViewCell" forIndexPath:indexPath];
    cell.chapterModel = [self.chapters safeObjectAtIndex:indexPath.row];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return collectionView.size;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - Public

- (void)setBook:(IREpubBook *)book
{
    _book = book;
    
    __block NSMutableArray *tempChapters = [NSMutableArray arrayWithCapacity:book.tableOfContents.count];
    [book.tableOfContents enumerateObjectsUsingBlock:^(IRTocRefrence * _Nonnull toc, NSUInteger idx, BOOL * _Nonnull stop) {
        NSError *error = nil;
        NSString *chapterHtmlStr = [NSString stringWithContentsOfFile:toc.resource.fullHref
                                                    encoding:NSUTF8StringEncoding
                                                       error:&error];
        if (error) {
            IRDebugLog(@"[ReaderPageViewCell] Read chapter resource failed, error: %@", error);
            return;
        }
        
        IRChapterModel *chapterModel = [IRChapterModel modelWithHtmlModel:[IRHtmlModel modelWithHtmlString:chapterHtmlStr]];
        [tempChapters addObject:chapterModel];
    }];
    
    self.chapters = tempChapters;
    [self.collectionView reloadData];
}

@end
