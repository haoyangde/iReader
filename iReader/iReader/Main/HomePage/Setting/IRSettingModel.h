//
//  IRSettingModel.h
//  iReader
//
//  Created by zzyong on 2018/9/28.
//  Copyright © 2018年 zouzhiyong. All rights reserved.
//

#import "IRObject.h"

typedef void(^IRSettingCellClickedHandler)(void);

typedef NS_ENUM(NSUInteger, IRSettingCellType) {
    IRSettingCellTypeArrow,
    IRSettingCellTypeSwitch,
    IRSettingCellTypeText
};

NS_ASSUME_NONNULL_BEGIN

@interface IRSettingModel : IRObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *detailText;
@property (nonatomic, assign) IRSettingCellType cellType;
@property (nonatomic, strong) IRSettingCellClickedHandler clickedHandler;

@end

NS_ASSUME_NONNULL_END
