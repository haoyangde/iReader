//
//  CCAspectArgument.h
//  CCAspect
//
//  Created by zzyong on 2018/10/18.
//  Copyright © 2018 zzyong. All rights reserved.
//

#import "CCAspectTypes.h"

/// Argument 0 is self, argument 1 is SEL
extern NSUInteger const CCAspectMethodDefaultArgumentsCount;

NS_ASSUME_NONNULL_BEGIN

@interface CCAspectArgument : NSObject

@property (nonatomic, assign) NSUInteger index;
@property (nonatomic, assign) CCArgumentType type;
@property (nonatomic, strong, nullable) id value;

+ (instancetype)modelWithArgumentDictionary:(NSDictionary *)argumentDic;

@end

NS_ASSUME_NONNULL_END
