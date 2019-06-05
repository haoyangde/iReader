//
//  CCAspectTypes.h
//  CCAspect
//
//  Created by zzyong on 2018/10/29.
//  Copyright © 2018 zzyong. All rights reserved.
//

#ifndef CCAspectTypes_h
#define CCAspectTypes_h

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, CCArgumentType) {
    
    CCArgumentTypeUnknown           = 0,
    CCArgumentTypeObject            = 1, // id
    CCArgumentTypeClass             = 2,
    CCArgumentTypeBool              = 3,
    CCArgumentTypeLong              = 4, // NSInteger
    CCArgumentTypeUnsignedLong      = 5, // NSUInteger
    CCArgumentTypeShort             = 6,
    CCArgumentTypeUnsignedShort     = 7,
    CCArgumentTypeLongLong          = 8,
    CCArgumentTypeUnsignedLongLong  = 9,
    CCArgumentTypeFloat             = 10,
    CCArgumentTypeDouble            = 11, // CGFolat
    CCArgumentTypeInt               = 12,
    CCArgumentTypeUnsignedInt       = 13,
    CCArgumentTypeSEL               = 14,
    CCArgumentTypeCGSize            = 15,
    CCArgumentTypeCGPoint           = 16,
    CCArgumentTypeCGRect            = 17,
    CCArgumentTypeUIEdgeInsets      = 18
};

typedef NS_ENUM(NSUInteger, CCAspectHookType) {
    
    CCAspectHookUnknown              = 0, // Unknown
    CCAspectHookNullImp              = 1, // Instead with empty IMP
    CCAspectHookReturnModify         = 2, // Return value modify
    CCAspectHookCustomInvokeBefore   = 3, // Custom code invoke before original
    CCAspectHookCustomInvokeAfter    = 4, // Custom code invoke after original
    CCAspectHookCustomInvokeInstead  = 5  // Custom code invoke instead original
};

typedef NS_ENUM(NSUInteger, CCAspectMessageType) {
    
    CCAspectMessageTypeDefault       = 0, // 常规调用
    CCAspectMessageTypeReturn        = 1, // 返回语句
    CCAspectMessageTypeAssign        = 2  // 赋值语句
};

#endif /* CCAspectTypes_h */
