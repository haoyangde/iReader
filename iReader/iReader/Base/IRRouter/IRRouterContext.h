//
//  IRRouterContext.h
//  iReader
//
//  Created by zzyong on 2019/6/5.
//  Copyright © 2019 zouzhiyong. All rights reserved.
//

#import <Foundation/Foundation.h>

//kContextTransitionType
typedef NS_ENUM(NSUInteger, IRViewControllerTransitionType) {
    IRViewControllerTransitionPush,
    IRViewControllerTransitionPresent
};

NS_ASSUME_NONNULL_BEGIN

@interface IRRouterContext : NSObject

@property (nonatomic, strong) NSDictionary *userInfo;
@property (nonatomic, strong) UIViewController *fromViewController;
@property (nonatomic, assign) IRViewControllerTransitionType transitionType;
@property (nonatomic, assign) BOOL transitionAnimated;

+ (instancetype)openContextWithUserInfo:(NSDictionary *)userInfo
                     fromViewController:(UIViewController *)vc
                         transitionType:(IRViewControllerTransitionType)type
                               animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
