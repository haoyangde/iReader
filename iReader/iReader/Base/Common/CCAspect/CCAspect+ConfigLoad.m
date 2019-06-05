//
//  CCAspect+ConfigLoad.m
//  iReader
//
//  Created by zzyong on 2019/6/5.
//  Copyright © 2019 zouzhiyong. All rights reserved.
//

#import "CCAspect+ConfigLoad.h"

@implementation CCAspect (ConfigLoad)

#ifdef DEBUG

//[self hookMethodWithAspectDictionary:[self aspectAndOperator]];
//return;
+ (NSDictionary *)aspectAndOperator
{
    return @{
             @"selName": @"andOperatorTest",
             @"hookType": @5,
             @"className": @"CCAspectDebugViewController",
             @"customInvokeMessages" : @[
                     @{
                         @"message":@"self.nilString",
                         @"localInstanceKey" : @"nilString"
                         },
                     @{
                         @"message":@"self.nilString2",
                         @"localInstanceKey" : @"nilString2"
                         },
                     @{
                         @"invokeCondition": @{@"condition":@"nilString==nil",@"operator":@"==",@"conditionKey":@"nilString_c"}
                         },
                     @{
                         @"invokeCondition": @{@"condition":@"nilString2==nil",@"operator":@"==",@"conditionKey":@"nilString2_c"}
                         },
                     @{
                         @"message":@"self.printAndOperator",
                         @"invokeCondition": @{@"condition":@"nilString_c&&nilString2_c",@"operator":@"&&"}
                         }
                     ]
             };
}

+ (NSDictionary *)aspetClassNilArgument
{
    return @{
             @"className" : @"CCAspectDebugViewController",
             @"selName" : @"classNilArgument:",
             @"parameterNames" : @[@"nilStr"],
             @"hookType" : @3,
             @"customInvokeMessages" : @[
                     @{
                         @"message" : @"self.classTestString",
                         @"localInstanceKey" : @"classTestString"
                         },
                     @{
                         @"message" : @"nilStr=1:classTestString",
                         @"messageType" : @2
                         }]
             };
}

+ (NSDictionary *)aspetInstanceNilArgument
{
    return @{
             @"className" : @"CCAspectDebugViewController",
             @"selName" : @"nilArgument:",
             @"parameterNames" : @[@"nilStr"],
             @"hookType" : @3,
             @"customInvokeMessages" : @[
                     @{
                         @"message" : @"return",
                         @"messageType":@1,
                         @"invokeCondition": @{@"condition":@"nilStr==nil",@"operator":@"=="}
                         }]
             };
}

#endif

@end
