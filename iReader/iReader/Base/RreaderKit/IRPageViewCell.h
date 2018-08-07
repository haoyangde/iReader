//
//  IRPageViewCell.h
//  iReader
//
//  Created by zzyong on 2018/8/6.
//  Copyright © 2018年 zouzhiyong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IRPageModel;

@interface IRPageViewCell : UICollectionViewCell

@property (nonatomic, strong) IRPageModel *pageModel;

@end
