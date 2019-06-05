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
    IRSettingCellTypeDefault,
    IRSettingCellTypeArrow,
    IRSettingCellTypeSwitch,
    IRSettingCellTypeText
};

NS_ASSUME_NONNULL_BEGIN

@interface IRSettingModel : IRObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *rightText;
@property (nonatomic, assign) IRSettingCellType cellType;
@property (nonatomic, strong) NSString *settingKind;
@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, strong) IRSettingCellClickedHandler clickedHandler;

// Switch
@property (nonatomic, assign) BOOL isSwitchOn;

@end

NS_ASSUME_NONNULL_END
