//
//  IRReaderCenterController.m
//  iReader
//
//  Created by zzyong on 2018/8/6.
//  Copyright © 2018年 zouzhiyong. All rights reserved.
//

#import "IRReaderCenterController.h"

// view
#import "IRChapterViewCell.h"
#import "IRReaderNavigationView.h"

// model
#import "IRTocRefrence.h"
#import "IREpubBook.h"

@interface IRReaderCenterController ()
<
UICollectionViewDelegateFlowLayout,
UICollectionViewDataSource,
IRReaderNavigationViewDelegate
>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray<IRTocRefrence *> *chapters;
@property (nonatomic, assign) BOOL shouldHideStatusBar;
@property (nonatomic, strong) IRReaderNavigationView *readerNavigationView;

@end

@implementation IRReaderCenterController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self commonInit];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.collectionView.frame = self.view.bounds;
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
    CGFloat navbarH = 40;
    CGFloat navbarBeginY = self.shouldHideStatusBar ? 60 : -navbarH;
    CGFloat navbarEndY = self.shouldHideStatusBar ? -navbarH : 60;
    self.readerNavigationView.frame = CGRectMake(0, navbarBeginY, self.view.width, navbarH);
    
    [UIView animateWithDuration:0.25 animations:^{
        [self setNeedsStatusBarAppearanceUpdate];
        self.readerNavigationView.y = navbarEndY;
    }];
}

#pragma mark - Private

- (void)commonInit
{
    self.shouldHideStatusBar = YES;
    [self setupCollectionView];
    [self setupGestures];
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
        _readerNavigationView.delegate = self;
        [self.view addSubview:_readerNavigationView];
    }
    
    return _readerNavigationView;
}

#pragma mark - IRReaderNavigationViewDelegate

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
    cell.backgroundColor = IR_RANDOM_COLOR;
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
    
    self.chapters = book.tableOfContents;
    [self.collectionView reloadData];
}

@end
