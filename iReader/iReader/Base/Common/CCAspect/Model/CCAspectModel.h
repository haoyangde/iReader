//
//  CCAspectModel.h
//  CCAspect
//
//  Created by zzyong on 2018/10/18.
//  Copyright © 2018 zzyong. All rights reserved.
//

#import "CCAspectTypes.h"

@class CCAspectMessage;

NS_ASSUME_NONNULL_BEGIN

@interface CCAspectModel : NSObject

@property (nonatomic, strong) NSString *className;
@property (nonatomic, strong) NSString *selName;
/// 必须按照方法参数顺序
@property (nonatomic, strong, nullable) NSArray<NSString *> *parameterNames;
@property (nonatomic, assign) CCAspectHookType hookType;

@property (nonatomic, strong, nullable) NSArray<CCAspectMessage *> *customInvokeMessages;

+ (nullable instancetype)modelWithAspectDictionary:(NSDictionary *)aspectDictionary;

@end

NS_ASSUME_NONNULL_END
