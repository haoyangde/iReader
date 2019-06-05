//
//  IRRouterContext.m
//  iReader
//
//  Created by zzyong on 2019/6/5.
//  Copyright © 2019 zouzhiyong. All rights reserved.
//

#import "IRRouterContext.h"

@implementation IRRouterContext

+ (instancetype)openContextWithUserInfo:(NSDictionary *)userInfo
                     fromViewController:(UIViewController *)vc
                         transitionType:(IRViewControllerTransitionType)type
                               animated:(BOOL)animated
{
    IRRouterContext *context = [[self alloc] init];
    
    context.fromViewController = vc;
    context.userInfo = userInfo;
    context.transitionType = type;
    context.transitionAnimated = animated;
    
    return context;
}

@end
