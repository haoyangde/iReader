//
//  IRReaderPageBackgroundSelectView.m
//  iReader
//
//  Created by zzyong on 2018/8/28.
//  Copyright © 2018年 zouzhiyong. All rights reserved.
//

#import "IRReaderPageBackgroundSelectView.h"
#import "IRReaderPageBackgroundSelectViewCell.h"
#import <Masonry.h>

@interface IRReaderPageBackgroundSelectView ()
<
UICollectionViewDelegateFlowLayout,
UICollectionViewDataSource
>

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation IRReaderPageBackgroundSelectView

- (instancetype)init
{
    if (self = [super init]) {
        [self setupSubviews];
    }
    
    return self;
}

- (void)setupSubviews
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.bounds
                                                          collectionViewLayout:flowLayout];
    collectionView.dataSource = self;
    collectionView.delegate   = self;
    collectionView.backgroundColor      = [UIColor whiteColor];
    collectionView.alwaysBounceHorizontal = YES;
    collectionView.showsHorizontalScrollIndicator = NO;
    
    [collectionView registerClass:[IRReaderPageBackgroundSelectViewCell class] forCellWithReuseIdentifier:@"IRReaderPageBackgroundSelectViewCell"];
    
    [self addSubview:collectionView];
    self.collectionView = collectionView;
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    UIView *topLine = [[UIView alloc] init];
    topLine.backgroundColor = [UIColor ir_separatorLineColor];
    [self addSubview:topLine];
    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0.5);
        make.top.right.left.equalTo(self);
    }];
}

#pragma mark - UICollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    IRReaderPageBackgroundSelectViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"IRReaderPageBackgroundSelectViewCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor orangeColor];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(60, 30);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(15, 15, 15, 15);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 15;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
