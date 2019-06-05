//
//  CCAspect.h
//  CCAspect
//
//  Created by zzyong on 2018/10/18.
//  Copyright © 2018 zzyong. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CCAspectModel;

NS_ASSUME_NONNULL_BEGIN

@interface CCAspect : NSObject

+ (void)updateAspectClassDefineList:(NSArray<NSString *> *)classList;

+ (void)hookMethodWithAspectDictionary:(NSDictionary *)aspectDictionary;

@end

NS_ASSUME_NONNULL_END
