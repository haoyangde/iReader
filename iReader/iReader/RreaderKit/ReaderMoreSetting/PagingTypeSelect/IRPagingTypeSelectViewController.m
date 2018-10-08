//
//  IRPagingTypeSelectViewController.m
//  iReader
//
//  Created by zzyong on 2018/10/8.
//  Copyright © 2018年 zouzhiyong. All rights reserved.
//

#import "IRPagingTypeSelectViewController.h"
#import "IRSettingModel.h"
#import "IRSettingSectionModel.h"
#import "IRPagingTypeSelectCell.h"

@interface IRPagingTypeSelectViewController ()
<
UICollectionViewDelegateFlowLayout,
UICollectionViewDataSource
>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray<IRSettingModel *> *settingInfos;

@end

@implementation IRPagingTypeSelectViewController

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

- (void)dealloc
{
    self.collectionView.delegate = nil;
    self.collectionView.dataSource = nil;
}

#pragma mark - UICollectionView

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.settingInfos.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    IRSettingSectionModel *sectionModel = [self.settingInfos safeObjectAtIndex:section];
    return sectionModel.items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    IRSettingSectionModel *sectionModel = [self.settingInfos safeObjectAtIndex:indexPath.section];
    IRSettingModel *settingModel = [sectionModel.items safeObjectAtIndex:indexPath.row];
    if (settingModel.cellType == IRSettingCellTypeDefault) {
        IRPagingTypeSelectCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"IRPagingTypeSelectCell" forIndexPath:indexPath];
        cell.settingModel = settingModel;
        return cell;
    } else {
        return  [collectionView dequeueReusableCellWithReuseIdentifier:@"defaultCell" forIndexPath:indexPath];
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
        header.backgroundColor = [UIColor colorWithWhite:0.9 alpha:0.5];
        return header;
    } else {
        return [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer" forIndexPath:indexPath];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(collectionView.width, 44);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(collectionView.width, 20);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    IRSettingSectionModel *sectionModel = [self.settingInfos safeObjectAtIndex:indexPath.section];
    IRSettingModel *settingModel = [sectionModel.items safeObjectAtIndex:indexPath.row];
    if (settingModel.clickedHandler) {
        settingModel.clickedHandler();
    }
}

#pragma mark - DataSource

- (void)setupSettingInfos
{
    __weak typeof(self) weakSelf = self;
    
    IRSettingSectionModel *commonSection = [[IRSettingSectionModel alloc] init];
    IRSettingModel *scroll = [[IRSettingModel alloc] init];
    scroll.title = @"简约";
    scroll.isSelected = (IR_READER_CONFIG.transitionStyle == IRPageTransitionStyleScroll);
    scroll.clickedHandler = ^{
        [weakSelf onScrollTypeCellClicked];
    };
    
    IRSettingModel *paging = [[IRSettingModel alloc] init];
    paging.title = @"仿真";
    paging.isSelected = (IR_READER_CONFIG.transitionStyle == IRPageTransitionStylePageCurl);
    paging.clickedHandler = ^{
        [weakSelf onPageCurlTypeCellClicked];
    };
    
    commonSection.items = @[paging, scroll];
    self.settingInfos = @[commonSection];
}

- (void)onScrollTypeCellClicked
{
    if (self.selectHandler) {
        self.selectHandler(IRPageTransitionStyleScroll);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onPageCurlTypeCellClicked
{
    if (self.selectHandler) {
        self.selectHandler(IRPageTransitionStylePageCurl);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Private

- (void)commonInit
{
    self.title = @"翻页方式";
    [self setupSettingInfos];
    [self setupLeftBackBarButton];
    [self setupCollectionView];
}

- (void)setupCollectionView
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds
                                                          collectionViewLayout:flowLayout];
    collectionView.dataSource = self;
    collectionView.delegate   = self;
    collectionView.backgroundColor      = [UIColor whiteColor];
    collectionView.showsVerticalScrollIndicator = NO;
    
    [collectionView registerClass:[IRPagingTypeSelectCell class] forCellWithReuseIdentifier:@"IRPagingTypeSelectCell"];
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"defaultCell"];
    [collectionView registerClass:[UICollectionReusableView class]
       forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
              withReuseIdentifier:@"header"];
    [collectionView registerClass:[UICollectionReusableView class]
       forSupplementaryViewOfKind:UICollectionElementKindSectionFooter
              withReuseIdentifier:@"footer"];
    
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
}

@end
