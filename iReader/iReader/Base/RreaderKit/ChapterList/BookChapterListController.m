//
//  BookChapterListController.m
//  iReader
//
//  Created by zzyong on 2018/7/13.
//  Copyright © 2018年 zouzhiyong. All rights reserved.
//

#import "BookChapterListCell.h"
#import "BookChapterListController.h"
#import "IREpubHeaders.h"

@interface BookChapterListController () <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation BookChapterListController

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

#pragma mark - Private

- (void)commonInit
{
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupCollectionView];
}

- (void)setupCollectionView
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds
                                                          collectionViewLayout:flowLayout];
    collectionView.dataSource = self;
    collectionView.delegate   = self;
    collectionView.pagingEnabled = YES;
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.alwaysBounceVertical = YES;
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.showsHorizontalScrollIndicator = NO;
    
    if (@available(iOS 11.0, *)) {
        collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    [collectionView registerClass:[BookChapterListCell class] forCellWithReuseIdentifier:@"BookChapterListCell"];
    
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
}

#pragma mark - UICollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.chapterList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BookChapterListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BookChapterListCell" forIndexPath:indexPath];
    cell.chapter = [self.chapterList objectAtIndex:indexPath.row];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    IRTocRefrence *chapter = [self.chapterList objectAtIndex:indexPath.row];
    CGSize titleSize = [chapter.title sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:kChapterListCellFontSize]}];
    CGFloat cellHeight = ceil(titleSize.height) * ceil(titleSize.width / (collectionView.width - 20));
    return CGSizeMake(collectionView.width - 20, cellHeight + 20);
}
                                                       
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 10, 0, 10);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
