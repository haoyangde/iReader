//
//  IRDebugViewController.m
//  iReader
//
//  Created by zzyong on 2018/10/1.
//  Copyright © 2018年 zouzhiyong. All rights reserved.
//

#import "IRDebugViewController.h"
#import "IRSwitchSettingCell.h"
#import "IRSettingModel.h"
#import "IRDebugConst.h"
#ifdef DEBUG
#import "AppDelegate+Debug.h"
#endif
#import "DTCoreTextLayoutFrame.h"

typedef NS_ENUM(NSUInteger, IRSwitchSettingCellModleId) {
    IRSwitchSettingCellModleIdFlex    = 0,
    IRSwitchSettingCellModleIdDTDebug = 1
};

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
    
    if (model.modelId == IRSwitchSettingCellModleIdDTDebug) {
        [self onDTDebugCellValueChanged:cell.switchView.isOn];
    } else if (model.modelId == IRSwitchSettingCellModleIdFlex) {
        [self onFlexCellValueChanged:cell.switchView.isOn];
    }
}

- (void)onFlexCellValueChanged:(BOOL)value
{
    [[IRCacheManager sharedInstance] asyncSetObject:@(!value) forKey:kFlexDebugDisableCacheKey];
    
#ifdef DEBUG
    [[(AppDelegate *)[UIApplication sharedApplication].delegate flexWindow] setHidden:!value];
#endif
    
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
    IRSettingModel *flex = [[IRSettingModel alloc] init];
    flex.title = @"FLEX";
    flex.modelId = IRSwitchSettingCellModleIdFlex;
    flex.cellType = IRSettingCellTypeSwitch;
    flex.isSwitchOn = ![[[IRCacheManager sharedInstance] objectForKey:kFlexDebugDisableCacheKey] boolValue];
    
    IRSettingModel *dtDebug = [[IRSettingModel alloc] init];
    dtDebug.title = @"DTCoreText Debug";
    dtDebug.modelId = IRSwitchSettingCellModleIdDTDebug;
    dtDebug.cellType = IRSettingCellTypeSwitch;
    dtDebug.isSwitchOn = [[[IRCacheManager sharedInstance] objectForKey:kDTCoreTextDebugEnableCacheKey] boolValue];
    
    self.debugInfos = @[flex, dtDebug];
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
