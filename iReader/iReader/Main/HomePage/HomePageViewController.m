//
//  HomePageViewController.m
//  iReader
//
//  Created by zzyong on 2018/8/23.
//  Copyright © 2018年 zouzhiyong. All rights reserved.
//

#import "HomePageViewController.h"
#import "IRReaderCenterController.h"

// View
#import "IRBookCell.h"

// Other
#import "IREpubHeaders.h"

@interface HomePageViewController ()
<
UICollectionViewDelegateFlowLayout,
UICollectionViewDataSource
>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray<IREpubBook *> *myBooks;

@end

@implementation HomePageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self commonInit];
}

- (void)commonInit
{
    [self setupCollectionView];
    [self parseBooks];
}

- (void)parseBooks
{
    NSArray *books = @[@"The Silver Chair", @"细说明朝"];
    
    for (NSString *bookName in books) {
        [[IREpubParser sharedInstance] asyncReadEpubWithEpubName:bookName completion:^(IREpubBook *book, NSError *error) {
            if (book) {
                [self.myBooks addObject:book];
            }
            
            if ([books indexOfObject:bookName] == books.count - 1) {
                [self.collectionView reloadData];
            }
        }];
    }
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
    
    [collectionView registerClass:[IRBookCell class] forCellWithReuseIdentifier:@"IRBookCell"];
    
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
}

#pragma mark -

-(NSMutableArray<IREpubBook *> *)myBooks
{
    if (!_myBooks) {
        _myBooks = [[NSMutableArray alloc] init];
    }
    return _myBooks;
}

#pragma mark -

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.myBooks.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    IRBookCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"IRBookCell" forIndexPath:indexPath];
    IREpubBook *book = [self.myBooks objectAtIndex:indexPath.row];
    [cell setCoverImage:[UIImage imageWithContentsOfFile:book.coverImage.fullHref]];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static CGFloat myCellWidth;
    if (!myCellWidth) {
        myCellWidth = (collectionView.width - 65) / 3;
    }
    return CGSizeMake(myCellWidth, myCellWidth * 10 / 8);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 15;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 15;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    IRReaderCenterController *mainVc = [[IRReaderCenterController alloc] initWithBook:[self.myBooks objectAtIndex:indexPath.row]];
    UINavigationController *containerNav = [[UINavigationController alloc] initWithRootViewController:mainVc];
    containerNav.navigationBarHidden = YES;
    containerNav.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:containerNav animated:YES completion:nil];
}


@end
