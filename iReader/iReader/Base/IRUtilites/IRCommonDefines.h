//
//  IRCommonDefines.h
//  iReader
//
//  Created by zzyong on 2018/7/9.
//  Copyright © 2018年 zouzhiyong. All rights reserved.
//

#ifndef IRCommonDefines_h
#define IRCommonDefines_h

#pragma mark - SystemVersion

#define IsOverThanOrEqualToiOS7      ([[[UIDevice currentDevice] systemVersion] intValue] >= 7)
#define IsOverThanOrEqualToiOS8      ([[[UIDevice currentDevice] systemVersion] intValue] >= 8)
#define IsOverThanOrEqualToiOS9      ([[[UIDevice currentDevice] systemVersion] intValue] >= 9)
#define IsOverThanOrEqualToiOS10     ([[[UIDevice currentDevice] systemVersion] intValue] >= 10)
#define IsOverThanOrEqualToiOS11     ([[[UIDevice currentDevice] systemVersion] intValue] >= 11)

#pragma mark - Custom Debug Log

#ifdef DEBUG
#define IRDebugLog(...) NSLog(__VA_ARGS__)
#else
#define IRDebugLog(...)
#endif

#pragma mark -

#endif /* IRCommonDefines_h */
