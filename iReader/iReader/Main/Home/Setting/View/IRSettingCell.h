//
//  IRSettingCell.h
//  iReader
//
//  Created by zzyong on 2018/9/28.
//  Copyright © 2018年 zouzhiyong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IRSettingModel;

NS_ASSUME_NONNULL_BEGIN

@interface IRSettingCell : UICollectionViewCell

@property (nonatomic, strong, readonly) UILabel *titleLabel;
@property (nonatomic, strong) IRSettingModel *settingModel;

- (void)setupSubviews;

@end

NS_ASSUME_NONNULL_END
