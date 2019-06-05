//
//  IRRouter.h
//  iReader
//
//  Created by zzyong on 2018/1/22.
//  Copyright © 2018年 zouzhiyong. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UIViewController, IRRouterContext;

//URL register key
extern NSString * const IRRouterUserInfo;
extern NSString * const IRRouterHandlerCompletion;

//RouterInfo -> [IRRouterUserInfo, IRRouterResulthandle]
typedef void (^IRRouterHandler)(NSDictionary *routerInfo);

//IRRouterResulthandle
typedef void (^IRRouterResultHandler)(Class target, NSArray *initInfos);

@interface IRRouter : NSObject

+ (instancetype)defaultRouter;

//Register Target
+ (void)registerRoutersWithPlistName:(NSString *)name;
+ (void)registerTargetStr:(NSString *)targetStr toHandler:(IRRouterHandler)handler;

- (void)unregisterTargetStr:(NSString *)targetStr;

//Open URL
+ (BOOL)openURLString:(NSString *)urlStr context:(IRRouterContext *)context;


@end
