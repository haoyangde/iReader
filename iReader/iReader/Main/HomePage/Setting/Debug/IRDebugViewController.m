//
//  IRDebugViewController.m
//  iReader
//
//  Created by zzyong on 2018/10/1.
//  Copyright © 2018年 zouzhiyong. All rights reserved.
//

#ifdef DEBUG

#import "IRDebugViewController.h"
#import "IRSwitchSettingCell.h"
#import "IRSettingModel.h"
#import "IRDebugConst.h"
#import "AppDelegate+Debug.h"
#import "DTCoreTextLayoutFrame.h"
#import "CCAspectDebugViewController.h"
#import "IRArrowSettingCell.h"

@interface IRDebugViewController ()
<
UICollectionViewDelegateFlowLayout,
UICollectionViewDataSource,
IRSwitchSettingCellDelegate
>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray<IRSettingModel *> *debugInfos;

@end

@implementation IRDebugViewController

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
    IRSettingModel *model = cell.settingModel;
    
    if ([model.settingKind isEqualToString:@"DTCoreText"]) {
        [self onDTDebugCellValueChanged:cell.switchView.isOn];
    } else if ([model.settingKind isEqualToString:@"flex"]) {
        [self onFlexCellValueChanged:cell.switchView.isOn];
    }
}

- (void)onFlexCellValueChanged:(BOOL)value
{
    [[IRCacheManager sharedInstance] asyncSetObject:@(!value) forKey:kFlexDebugDisableCacheKey];
    
    [[(AppDelegate *)[UIApplication sharedApplication].delegate flexWindow] setHidden:!value];
}

- (void)onDTDebugCellValueChanged:(BOOL)value
{
    [[IRCacheManager sharedInstance] asyncSetObject:@(value) forKey:kDTCoreTextDebugEnableCacheKey];
    
    [DTCoreTextLayoutFrame setShouldDrawDebugFrames:value];
}

#pragma mark - UICollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.debugInfos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    IRSettingModel *settingModel = [self.debugInfos safeObjectAtIndex:indexPath.row];
    if (settingModel.cellType == IRSettingCellTypeSwitch) {
        IRSwitchSettingCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"IRSwitchSettingCell" forIndexPath:indexPath];
        cell.delegate = self;
        cell.settingModel = settingModel;
        return cell;
    } else if (settingModel.cellType == IRSettingCellTypeArrow) {
        IRArrowSettingCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"IRArrowSettingCell" forIndexPath:indexPath];
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
    IRSettingModel *settingModel = [self.debugInfos safeObjectAtIndex:indexPath.row];
    if (settingModel.clickedHandler) {
        settingModel.clickedHandler();
    }
}

#pragma mark - DataSource

- (void)setupDebugInfos
{
    __weak typeof(self) weakSelf = self;
    IRSettingModel *flex = [[IRSettingModel alloc] init];
    flex.title = @"FLEX";
    flex.settingKind = @"flex";
    flex.cellType = IRSettingCellTypeSwitch;
    flex.isSwitchOn = ![[[IRCacheManager sharedInstance] objectForKey:kFlexDebugDisableCacheKey] boolValue];
    
    IRSettingModel *dtDebug = [[IRSettingModel alloc] init];
    dtDebug.title = @"DTCoreText Debug";
    dtDebug.settingKind = @"DTCoreText";
    dtDebug.cellType = IRSettingCellTypeSwitch;
    dtDebug.isSwitchOn = [[[IRCacheManager sharedInstance] objectForKey:kDTCoreTextDebugEnableCacheKey] boolValue];
    
    IRSettingModel *aspectDebug = [[IRSettingModel alloc] init];
    aspectDebug.title = @"CCAspect Debug";
    aspectDebug.cellType = IRSettingCellTypeArrow;
    aspectDebug.clickedHandler = ^{
        [weakSelf.navigationController pushViewController:[[CCAspectDebugViewController alloc] init] animated:YES];
    };
    
    self.debugInfos = @[flex, dtDebug, aspectDebug];
}

#pragma mark - Private

- (void)commonInit
{
    self.title = @"开发实验室";
    [self setupDebugInfos];
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
    
    [collectionView registerClass:[IRSwitchSettingCell class] forCellWithReuseIdentifier:@"IRSwitchSettingCell"];
    [collectionView registerClass:[IRArrowSettingCell class] forCellWithReuseIdentifier:@"IRArrowSettingCell"];
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

#endif
