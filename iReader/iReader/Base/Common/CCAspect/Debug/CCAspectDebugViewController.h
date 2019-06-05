//
//  CCAspectDebugViewController.h
//  CC-iPhone
//
//  Created by zzyong on 2019/5/13.
//  Copyright © 2019 netease. All rights reserved.
//

#ifdef DEBUG

#import "IRBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface CCAspectDebugViewController : IRBaseViewController

@end

NS_ASSUME_NONNULL_END

#endif

/*
 
示例1：@{@"name":@"空异常测试", @"sel":@"nilArgument:"},
配置1：
 {
     "selName": "nilArgument:",
     "hookType": 3,
     "className": "CCAspectDebugViewController",
     "parameterNames": ["nilStr"],
     "customInvokeMessages" : [
         {
             "message" : "return",
             "messageType":1,
             "invokeCondition": {"condition":"nilStr==nil","operator":"=="}
         }
     ],
     "ApplySystemVersions": [
         "*"
     ]
 }
 
示例2：@{@"name":@"更改返回值CGRect", @"sel":@"cellRect"},
配置2：
 {
     "selName": "cellRect",
     "hookType": 5,
     "className": "CCAspectDebugViewController",
     "customInvokeMessages" : [
         {
             "message" : "return=17:1,1,1,1",
             "messageType":1
         }
     ],
     "ApplySystemVersions": [
         "*"
     ]
 }
 
示例3：@{@"name":@"更改返回值CGFloat", @"sel":@"cellHeight"},
配置3：
 {
     "selName": "cellHeight",
     "hookType": 5,
     "className": "CCAspectDebugViewController",
     "customInvokeMessages" : [
         {
             "message" : "return=11:66.66",
             "messageType":1
         }
     ],
     "ApplySystemVersions": [
         "*"
     ]
 }
 
示例4：@{@"name":@"更改返回值CGColor", @"sel":@"cellColor"},
配置4：
 {
     "selName": "cellColor",
     "hookType": 5,
     "className": "CCAspectDebugViewController",
     "customInvokeMessages" : [
         {
             "message" : "UIColor.redColor",
             "localInstanceKey" : "redColor"
         },
         {
             "message" : "return=1:redColor",
             "messageType":1
         }
     ],
     "ApplySystemVersions": [
         "*"
     ]
 }
 
示例5：@{@"name":@"更改条件返回值CGColor", @"sel":@"cellColorWithCondition"},
配置5：
 {
     "selName": "cellColorWithCondition",
     "hookType": 5,
     "className": "CCAspectDebugViewController",
     "customInvokeMessages" : [
         {
             "message" : "self.nilString",
             "localInstanceKey" : "nilString"
         },
         {
             "message" : "UIColor.orangeColor",
             "localInstanceKey" : "orangeColor",
             "invokeCondition": {"condition":"nilString!=nil","operator":"!="}
         },
         {
             "message" : "return=1:orangeColor",
             "messageType":1,
             "invokeCondition": {"condition":"nilString==nil","operator":"=="}
         },
         {
             "message" : "UIColor.greenColor",
             "localInstanceKey" : "greenColor"
         },
         {
             "message" : "return=1:greenColor",
             "messageType":1
         }
     ],
     "ApplySystemVersions": [
         "*"
     ]
 }
 
示例6：@{@"name":@"更改崩溃方法返回值CGColor", @"sel":@"cellColorWithException"},
配置6：
 {
     "selName": "cellColorWithException",
     "hookType": 3,
     "className": "CCAspectDebugViewController",
     "customInvokeMessages" : [
         {
             "message" : "self.nilNumber",
             "localInstanceKey" : "nilNumber"
         },
         {
             "message" : "UIColor.blueColor",
             "localInstanceKey" : "blueColor"
         },
         {
             "message" : "return=1:blueColor",
             "messageType":1,
             "invokeCondition": {"condition":"nilNumber==nil","operator":"=="}
         }
     ]
 }
 
示例7：@{@"name":@"数组越界测试", @"sel":@"outOfBounceException"},
配置7：
 {
     "selName": "outOfBounceException:",
     "hookType": 3,
     "parameters": ["index"],
     "className": "CCAspectDebugViewController",
     "customInvokeMessages" : [
         {
             "message" : "self.testInfoList",
             "localInstanceKey" : "infoListCount"
         },
         {
             "message" : "return",
             "messageType":1,
             "invokeCondition": {"condition":"index>=infoListCount","operator":">="}
         }
     ]
 }
 
 示例8：@{@"name":@"赋值语句测试", @"sel":@"cellTitle"}
 配置8：
 {
     "selName": "cellTitle:",
     "hookType": 3,
     "parameterNames": ["title"],
     "className": "CCAspectDebugViewController",
     "customInvokeMessages" : [
         {
             "message" : "title=1:666",
             "messageType":2
         }
     ]
 }
 
 示例8：父类方法调用测试：viewWillDisappear:
 配置8：
 {
     "selName": "viewWillDisappear:",
     "hookType": 5,
     "className": "CCAspectDebugViewController",
     "parameterNames": ["animated"],
     "customInvokeMessages" : [
     {
         "message" : "super.viewWillDisappear:",
         "parameters" : {
             "viewWillDisappear:" : [
                 {
                     "index" : 0,
                     "value" : "animated",
                     "type"  : 3
                 }
             ]
         }
     }
     ]
 },
 
 
 示例9：@{@"name":@"&& 运算符测试", @"sel":@"andOperatorTest"}
 配置8：
 {
     "selName": "andOperatorTest",
     "hookType": 5,
     "className": "CCAspectDebugViewController",
     "customInvokeMessages" : [
         {
             "message":"self.nilString",
             "localInstanceKey" : "nilString"
         },
         {
             "message":"self.nilString2",
             "localInstanceKey" : "nilString2"
         },
         {
             "invokeCondition": {"condition":"nilString==nil","operator":"==","conditionKey":"nilString_c"}
         },
         {
             "invokeCondition": {"condition":"nilString2==nil","operator":"==","conditionKey":"nilString2_c"}
         },
         {
             "message":"self.printAndOperator",
             "invokeCondition": {"condition":"nilString_c&&nilString2_c","operator":"&&"}
         }
     ]
 },
 */
