//
//  CCAspectInstance.h
//  CC-iPhone
//
//  Created by zzyong on 2019/5/10.
//  Copyright © 2019 netease. All rights reserved.
//

#import "CCAspectTypes.h"

NS_ASSUME_NONNULL_BEGIN

@interface CCAspectInstance : NSObject

@property (nonatomic, strong, nullable) id value;
@property (nonatomic, assign) CCArgumentType type;

@end

NS_ASSUME_NONNULL_END
