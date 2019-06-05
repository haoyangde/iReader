//
//  IRSettingViewController.m
//  iReader
//
//  Created by zzyong on 2018/9/28.
//  Copyright © 2018年 zouzhiyong. All rights reserved.
//

#ifdef DEBUG
#import "IRDebugViewController.h"
#endif

#import "IRSettingViewController.h"
#import "IRSettingModel.h"
#import "IRSwitchSettingCell.h"
#import "IRArrowSettingCell.h"
#import "IRSettingSectionModel.h"
#import "IRTextSettingCell.h"

@interface IRSettingViewController ()
<
UICollectionViewDelegateFlowLayout,
UICollectionViewDataSource,
IRSwitchSettingCellDelegate
>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray<IRSettingSectionModel *> *settingInfos;

@end

@implementation IRSettingViewController

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

#pragma mark - IRSwitchSettingCellDelegate

- (void)settingCellDidClickSwitchButton:(IRSwitchSettingCell *)cell
{
    
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
    if (settingModel.cellType == IRSettingCellTypeSwitch) {
        IRSwitchSettingCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"IRSwitchSettingCell" forIndexPath:indexPath];
        cell.delegate = self;
        cell.settingModel = settingModel;
        return cell;
    } else if (settingModel.cellType == IRSettingCellTypeArrow) {
        IRArrowSettingCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"IRArrowSettingCell" forIndexPath:indexPath];
        cell.settingModel = settingModel;
        return cell;
    } else if (settingModel.cellType == IRSettingCellTypeText) {
        IRTextSettingCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"IRTextSettingCell" forIndexPath:indexPath];
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
    NSMutableArray *tempSettingInfos = [NSMutableArray array];
    __weak typeof(self) weakSelf = self;
    
    IRSettingSectionModel *commonSection = [[IRSettingSectionModel alloc] init];
    IRSettingModel *mark = [[IRSettingModel alloc] init];
    mark.title = @"去评分";
    mark.cellType = IRSettingCellTypeArrow;
    mark.clickedHandler = ^{
        [weakSelf onMarkCellClicked];
    };
    
    IRSettingModel *about = [[IRSettingModel alloc] init];
    about.title = @"关于";
    about.cellType = IRSettingCellTypeArrow;
    about.clickedHandler = ^{
        [weakSelf onAboutCellClicked];
    };
    
    IRSettingModel *cache = [[IRSettingModel alloc] init];
    cache.title = @"清除缓存";
    cache.rightText = @"0M";
    cache.cellType = IRSettingCellTypeText;
    cache.clickedHandler = ^{
        
    };
    
    commonSection.items = @[mark, about, cache];
    [tempSettingInfos addObject:commonSection];
    
#ifdef DEBUG
    IRSettingModel *debug = [[IRSettingModel alloc] init];
    debug.title = @"开发实验室";
    debug.cellType = IRSettingCellTypeArrow;
    debug.clickedHandler = ^{
        [weakSelf onDebugCellClicked];
    };
    IRSettingSectionModel *debugSection = [[IRSettingSectionModel alloc] init];
    debugSection.items = @[debug];
    [tempSettingInfos addObject:debugSection];
#endif
    
    self.settingInfos = [tempSettingInfos copy];
}

- (void)onMarkCellClicked
{
    
}

- (void)onAboutCellClicked
{
    
}

#pragma mark - Private

- (void)commonInit
{
    self.title = @"设置";
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
    collectionView.alwaysBounceVertical = YES;
    collectionView.showsVerticalScrollIndicator = NO;
    
    [collectionView registerClass:[IRTextSettingCell class] forCellWithReuseIdentifier:@"IRTextSettingCell"];
    [collectionView registerClass:[IRArrowSettingCell class] forCellWithReuseIdentifier:@"IRArrowSettingCell"];
    [collectionView registerClass:[IRSwitchSettingCell class] forCellWithReuseIdentifier:@"IRSwitchSettingCell"];
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

#pragma mark - DEBUG

#ifdef DEBUG

- (void)onDebugCellClicked
{
    IRDebugViewController *debugVc = [[IRDebugViewController alloc] init];
    [self.navigationController pushViewController:debugVc animated:YES];
}

#endif

@end
