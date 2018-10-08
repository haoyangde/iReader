//
//  IRSettingSectionModel.h
//  iReader
//
//  Created by zzyong on 2018/10/1.
//  Copyright © 2018年 zouzhiyong. All rights reserved.
//

#import "IRObject.h"

@class IRSettingModel;

@interface IRSettingSectionModel : IRObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSArray<IRSettingModel *> *items;

@end
