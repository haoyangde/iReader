//
//  CCAspect.m
//  CCAspect
//
//  Created by zzyong on 2018/10/18.
//  Copyright © 2018 zzyong. All rights reserved.
//

#import "Aspects.h"
#import "CCAspect.h"
#import <objc/runtime.h>
#import "CCAspectModel.h"
#import "CCAspectMessage.h"
#import "CCAspectArgument.h"
#import "CCAspectInstance.h"
#import "CCAspect+CustomInvokeInstead.h"

#define CCAspectBaseLogInfo(_aspectInfo) [NSString stringWithFormat:@"[%@ %@]", NSStringFromClass([_aspectInfo.instance class]), [NSStringFromSelector(_aspectInfo.originalInvocation.selector) substringFromIndex:9]]

#ifdef DEBUG
    #define CCAspectLog(...) do { IRDebugLog(__VA_ARGS__); }while(0)
#else
    #define CCAspectLog(...)
#endif

/// Aspect Class List
static NSArray<NSString *> *CCAspectClassDefineList;
/// Super Alias Selector List
static NSMutableDictionary *CCSuperAliasSelectorList = nil;
/// Original method return value key
static NSString * const kAspectOriginalMethodReturnValueKey = @"kAspectOriginalMethodReturnValueKey";

@implementation CCAspect

+ (void)updateAspectClassDefineList:(NSArray<NSString *> *)classList
{
    CCAspectClassDefineList = classList;
}

+ (void)hookMethodWithAspectDictionary:(NSDictionary *)aspectDictionary
{
    [self hookMethodWithAspectModel:[CCAspectModel modelWithAspectDictionary:aspectDictionary]];
}

+ (void)hookMethodWithAspectModel:(CCAspectModel *)aspectModel
{
    if (!aspectModel) {
        NSAssert(0, @"[CCAspect] aspect model is nil");
        return;
    }
    
    if (CCAspectHookUnknown == aspectModel.hookType) {
        CCAspectLog(@"[CCAspect] hook type is unknown");
        NSAssert(NO, @"");
        return;
    }
    
    Class targetCls = NSClassFromString(aspectModel.className);
    if (targetCls == nil) {
        CCAspectLog(@"[CCAspect] Target class:[%@] is nil", aspectModel.className);
        NSAssert(NO, @"");
        return;
    }
    
    SEL targetSel = NSSelectorFromString(aspectModel.selName);
    if (targetSel == nil) {
        CCAspectLog(@"[CCAspect] Target selector:[%@] is nil", aspectModel.selName);
        NSAssert(NO, @"");
        return;
    }
    
    // Class method
    if ([targetCls respondsToSelector:targetSel]) {
        targetCls = objc_getMetaClass([aspectModel.className UTF8String]);
    }
    
    NSError *aspectError = nil;
    __weak typeof(self) weakSelf = self;
    [targetCls aspect_hookSelector:targetSel withOptions:AspectPositionInstead usingBlock:^(id<AspectInfoProtocol> aspectInfo) {
        [weakSelf handleHookSelectorWithAspectInfo:aspectInfo aspectModel:aspectModel];
    } error:&aspectError];
    
    if (aspectError) {
        CCAspectLog(@"[CCAspect] %@ %@ Hook error:%@", aspectModel.className, aspectModel.selName, aspectError);
        NSAssert(NO, @"");
    }
}

#pragma mark - Private

+ (void)handleHookSelectorWithAspectInfo:(id<AspectInfoProtocol>)aspectInfo aspectModel:(CCAspectModel *)aspectModel
{
    switch (aspectModel.hookType) {
        case CCAspectHookNullImp: {

            CCAspectLog(@"%@", [NSString stringWithFormat:@"%@ replace to empty IMP", CCAspectBaseLogInfo(aspectInfo)]);
        }
            break;
        case CCAspectHookCustomInvokeAfter:
        case CCAspectHookCustomInvokeBefore:
        case CCAspectHookCustomInvokeInstead: {
            
            [self handleAspectCustomInvokeWithAspectInfo:aspectInfo aspectModel:aspectModel];
        }
            break;
            
        default:
            CCAspectLog(@"[CCAspect] Aspect hook type is unknown");
            break;
    }
}

+ (void)setArgumentValue:(CCAspectArgument *)aspectArgument invocation:(NSInvocation *)invocation
{
    if (aspectArgument.index >= invocation.methodSignature.numberOfArguments) {
        CCAspectLog(@"%@", [NSString stringWithFormat:@"[CCAspect] Argument index(%zd) is out of bounds [0, %zd)", aspectArgument.index, invocation.methodSignature.numberOfArguments]);
        NSAssert(NO, @"");
        return;
    }
    
    // index 0 is self, index 1 is SEL by default
    if (aspectArgument.index < 2) {
        NSAssert(NO, @"");
        return;
    }
    
    if (aspectArgument.type == CCArgumentTypeUnknown) {
        CCAspectLog(@"%@", @"[CCAspect] Argument type is CCArgumentTypeUnknown");
        NSAssert(NO, @"");
        return;
    }
    
    if (aspectArgument.type == CCArgumentTypeObject) {
        
        id value = aspectArgument.value;
        [invocation setArgument:&value atIndex:aspectArgument.index];
        
    } else if (aspectArgument.type == CCArgumentTypeClass) {
        
        Class value = aspectArgument.value;
        [invocation setArgument:&value atIndex:aspectArgument.index];
        
    } else if (aspectArgument.type == CCArgumentTypeSEL) {
        
        SEL value = NSSelectorFromString(aspectArgument.value);
        [invocation setArgument:&value atIndex:aspectArgument.index];
        
    } else if (aspectArgument.type == CCArgumentTypeCGRect) {
        
        CGRect value = [aspectArgument.value CGRectValue];
        [invocation setArgument:&value atIndex:aspectArgument.index];
        
    } else if (aspectArgument.type == CCArgumentTypeUIEdgeInsets) {
        
        UIEdgeInsets value = [aspectArgument.value UIEdgeInsetsValue];
        [invocation setArgument:&value atIndex:aspectArgument.index];
        
    } else if (aspectArgument.type == CCArgumentTypeCGPoint) {
        
        CGPoint value = [aspectArgument.value CGPointValue];
        [invocation setArgument:&value atIndex:aspectArgument.index];
        
    } else if (aspectArgument.type == CCArgumentTypeCGSize) {
        
        CGSize value = [aspectArgument.value CGSizeValue];
        [invocation setArgument:&value atIndex:aspectArgument.index];
        
    } else if (aspectArgument.type == CCArgumentTypeInt) {
        
        int value = [aspectArgument.value intValue];
        [invocation setArgument:&value atIndex:aspectArgument.index];
        
    } else if (aspectArgument.type == CCArgumentTypeUnsignedInt) {
        
        unsigned int value = [aspectArgument.value unsignedIntValue];
        [invocation setArgument:&value atIndex:aspectArgument.index];
        
    } else if (aspectArgument.type == CCArgumentTypeShort) {
        
        short value = [aspectArgument.value shortValue];
        [invocation setArgument:&value atIndex:aspectArgument.index];
        
    } else if (aspectArgument.type == CCArgumentTypeUnsignedShort) {
        
        unsigned short value = [aspectArgument.value unsignedShortValue];
        [invocation setArgument:&value atIndex:aspectArgument.index];
        
    } else if (aspectArgument.type == CCArgumentTypeLong) {
        
        long value = [aspectArgument.value longValue];
        [invocation setArgument:&value atIndex:aspectArgument.index];
        
    } else if (aspectArgument.type == CCArgumentTypeUnsignedLong) {
        
        unsigned long value = [aspectArgument.value unsignedLongValue];
        [invocation setArgument:&value atIndex:aspectArgument.index];
        
    } else if (aspectArgument.type == CCArgumentTypeLongLong) {
        
        long long value = [aspectArgument.value longLongValue];
        [invocation setArgument:&value atIndex:aspectArgument.index];
        
    } else if (aspectArgument.type == CCArgumentTypeUnsignedLongLong) {
        
        unsigned long long value = [aspectArgument.value unsignedLongLongValue];
        [invocation setArgument:&value atIndex:aspectArgument.index];
        
    } else if (aspectArgument.type == CCArgumentTypeFloat) {
        
        float value = [aspectArgument.value floatValue];
        [invocation setArgument:&value atIndex:aspectArgument.index];
        
    } else if (aspectArgument.type == CCArgumentTypeDouble) {
        
        double value = [aspectArgument.value doubleValue];
        [invocation setArgument:&value atIndex:aspectArgument.index];
        
    } else if (aspectArgument.type == CCArgumentTypeBool) {
        
        BOOL value = [aspectArgument.value boolValue];
        [invocation setArgument:&value atIndex:aspectArgument.index];
        
    } else {
        CCAspectLog(@"%@", [NSString stringWithFormat:@"[CCAspect] Argument type:[%zd] is unknown", aspectArgument.type]);
    }
}

+ (nullable CCAspectArgument *)getArgumentWithInvocation:(NSInvocation *)invocation atIndex:(NSUInteger)index shouldSetValue:(BOOL)shouldSetValue
{
    index += CCAspectMethodDefaultArgumentsCount;
    
    if (index >= invocation.methodSignature.numberOfArguments) {
        CCAspectLog(@"%@", [NSString stringWithFormat:@"[CCAspect] Argument index(%zd) is out of bounds [0, %zd)", index, invocation.methodSignature.numberOfArguments]);
        NSAssert(NO, @"");
        return nil;
    }
    
    CCAspectArgument *aspectArgument = [[CCAspectArgument alloc] init];
    aspectArgument.index = index;
    
    const char *argType = [invocation.methodSignature getArgumentTypeAtIndex:index];
    
    if (strcmp(argType, @encode(id)) == 0) {
        
        if (shouldSetValue) {
            __unsafe_unretained id argumentValue = nil;
            [invocation getArgument:&argumentValue atIndex:index];
            aspectArgument.value = argumentValue;
        }
        aspectArgument.type = CCArgumentTypeObject;
        
    } else if (strcmp(argType, @encode(long)) == 0) {
        
        if (shouldSetValue) {
            long argumentValue = 0;
            [invocation getArgument:&argumentValue atIndex:index];
            aspectArgument.value = @(argumentValue);
        }
        aspectArgument.type = CCArgumentTypeLong;
        
    } else if (strcmp(argType, @encode(unsigned long)) == 0) {
        
        if (shouldSetValue) {
            unsigned long argumentValue = 0;
            [invocation getArgument:&argumentValue atIndex:index];
            aspectArgument.value = @(argumentValue);
        }
        aspectArgument.type = CCArgumentTypeUnsignedLong;
        
    } else if (strcmp(argType, @encode(long long)) == 0) {
        
        if (shouldSetValue) {
            long long argumentValue = 0;
            [invocation getArgument:&argumentValue atIndex:index];
            aspectArgument.value = @(argumentValue);
        }
        aspectArgument.type = CCArgumentTypeLongLong;
        
    } else if (strcmp(argType, @encode(unsigned long long)) == 0) {
        
        if (shouldSetValue) {
            unsigned long long argumentValue = 0;
            [invocation getArgument:&argumentValue atIndex:index];
            aspectArgument.value = @(argumentValue);
        }
        aspectArgument.type = CCArgumentTypeUnsignedLongLong;
        
    } else if (strcmp(argType, @encode(int)) == 0) {
        
        if (shouldSetValue) {
            int argumentValue = 0;
            [invocation getArgument:&argumentValue atIndex:index];
            aspectArgument.value = @(argumentValue);
        }
        aspectArgument.type = CCArgumentTypeInt;
        
    } else if (strcmp(argType, @encode(unsigned int)) == 0) {
        
        if (shouldSetValue) {
            unsigned int argumentValue = 0;
            [invocation getArgument:&argumentValue atIndex:index];
            aspectArgument.value = @(argumentValue);
        }
        aspectArgument.type = CCArgumentTypeUnsignedInt;
        
    } else if (strcmp(argType, @encode(short)) == 0) {
        
        if (shouldSetValue) {
            short argumentValue = 0;
            [invocation getArgument:&argumentValue atIndex:index];
            aspectArgument.value = @(argumentValue);
        }
        aspectArgument.type = CCArgumentTypeShort;
        
    } else if (strcmp(argType, @encode(unsigned short)) == 0) {
        
        if (shouldSetValue) {
            unsigned short argumentValue = 0;
            [invocation getArgument:&argumentValue atIndex:index];
            aspectArgument.value = @(argumentValue);
        }
        aspectArgument.type = CCArgumentTypeUnsignedShort;
        
    } else if (strcmp(argType, @encode(float)) == 0) {
        
        if (shouldSetValue) {
            float argumentValue = 0;
            [invocation getArgument:&argumentValue atIndex:index];
            aspectArgument.value = @(argumentValue);
        }
        aspectArgument.type = CCArgumentTypeFloat;
        
    } else if (strcmp(argType, @encode(BOOL)) == 0) {
        
        if (shouldSetValue) {
            BOOL argumentValue = 0;
            [invocation getArgument:&argumentValue atIndex:index];
            aspectArgument.value = @(argumentValue);
        }
        aspectArgument.type = CCArgumentTypeBool;
        
    } else if (strcmp(argType, @encode(double)) == 0) {
        
        if (shouldSetValue) {
            double argumentValue = 0;
            [invocation getArgument:&argumentValue atIndex:index];
            aspectArgument.value = @(argumentValue);
        }
        aspectArgument.type = CCArgumentTypeDouble;
        
    } else if (strcmp(argType, @encode(CGRect)) == 0) {
        
        if (shouldSetValue) {
            CGRect argumentValue;
            [invocation getArgument:&argumentValue atIndex:index];
            aspectArgument.value = [NSValue valueWithCGRect:argumentValue];
        }
        aspectArgument.type = CCArgumentTypeCGRect;
        
    } else if (strcmp(argType, @encode(UIEdgeInsets)) == 0) {
        
        if (shouldSetValue) {
            UIEdgeInsets argumentValue;
            [invocation getArgument:&argumentValue atIndex:index];
            aspectArgument.value = [NSValue valueWithUIEdgeInsets:argumentValue];
        }
        aspectArgument.type = CCArgumentTypeUIEdgeInsets;
        
    } else if (strcmp(argType, @encode(CGSize)) == 0) {
        
        if (shouldSetValue) {
            CGSize argumentValue;
            [invocation getArgument:&argumentValue atIndex:index];
            aspectArgument.value = [NSValue valueWithCGSize:argumentValue];
        }
        aspectArgument.type = CCArgumentTypeCGSize;
        
    } else if (strcmp(argType, @encode(CGPoint)) == 0) {
        
        if (shouldSetValue) {
            CGPoint argumentValue;
            [invocation getArgument:&argumentValue atIndex:index];
            aspectArgument.value = [NSValue valueWithCGPoint:argumentValue];
        }
        aspectArgument.type = CCArgumentTypeCGPoint;
        
    } else if (strcmp(argType, @encode(SEL)) == 0) {
        
        if (shouldSetValue) {
            SEL argumentValue;
            [invocation getArgument:&argumentValue atIndex:index];
            aspectArgument.value = NSStringFromSelector(argumentValue);
        }
        aspectArgument.type = CCArgumentTypeSEL;
        
    } else if (strcmp(argType, @encode(Class)) == 0) {
        
        if (shouldSetValue) {
            Class argumentValue;
            [invocation getArgument:&argumentValue atIndex:index];
            aspectArgument.value = argumentValue;
        }
        aspectArgument.type = CCArgumentTypeClass;
        
    } else {
        aspectArgument.type = CCArgumentTypeUnknown;
    }
    
    return aspectArgument;
}

+ (CCAspectInstance *)invokeMethodWithTarget:(id)target
                                     selName:(NSString *)selName
                               isClassMethod:(BOOL)isClassMethod
                                   arguments:(NSArray<CCAspectArgument *> *)arguments
{
    CCAspectInstance *instance = [[CCAspectInstance alloc] init];;
    if (!selName) {
        return instance;
    }
    
    SEL selector = sel_registerName([selName UTF8String]);
    
    NSMethodSignature *signature = nil;
    
    if (isClassMethod) {
        
        signature = [[target class] methodSignatureForSelector:selector];
    } else {
        
        signature = [[target class] instanceMethodSignatureForSelector:selector];
    }
    
    if (!signature) {
        CCAspectLog(@"[CCAspect] Target:[%@] method signature must not be nil. selName:%@", target, selName);
        return instance;
    }
    
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    invocation.target = target;
    invocation.selector = selector;
    
    for (CCAspectArgument *argument in arguments) {
        [self setArgumentValue:argument invocation:invocation];
    }
    
    [invocation invoke];
    
    const char *methodReturnType = signature.methodReturnType;
    if (strcmp(methodReturnType, @encode(id)) == 0) {
        
        if ([selName isEqualToString:@"alloc"])  {
            
            instance.value = [[target class] alloc];
            
        } else if ([selName isEqualToString:@"new"]) {
            
            instance.value = [[target class] new];
            
        } else if ([selName isEqualToString:@"copy"]) {
            
            instance.value = [target copy];
            
        } else if ([selName isEqualToString:@"mutableCopy"]) {
            
            instance.value = [target mutableCopy];
            
        } else {
            void *result;
            [invocation getReturnValue:&result];
            instance.value = (__bridge id)result;
        }
        instance.type = CCArgumentTypeObject;
        
    } else if (strcmp(methodReturnType, @encode(BOOL)) == 0) {
        
        BOOL result = NO;
        [invocation getReturnValue:&result];
        instance.value = @(result);
        instance.type = CCArgumentTypeBool;
        
    } else if (strcmp(methodReturnType, @encode(int)) == 0) {
        
        int result = 0;
        [invocation getReturnValue:&result];
        instance.value = @(result);
        instance.type = CCArgumentTypeInt;
        
    } else if (strcmp(methodReturnType, @encode(long)) == 0) {
        
        NSInteger result = 0;
        [invocation getReturnValue:&result];
        instance.value = @(result);
        instance.type = CCArgumentTypeLong;
        
    } else if (strcmp(methodReturnType, @encode(unsigned long)) == 0) {
        
        NSUInteger result = 0;
        [invocation getReturnValue:&result];
        instance.value = @(result);
        instance.type = CCArgumentTypeUnsignedLong;
        
    } else if (strcmp(methodReturnType, @encode(double)) == 0) {
        
        CGFloat result = 0;
        [invocation getReturnValue:&result];
        instance.value = @(result);
        instance.type = CCArgumentTypeDouble;
        
    } else if (strcmp(methodReturnType, @encode(CGSize)) == 0) {
        
        CGSize result;
        [invocation getReturnValue:&result];
        instance.value = [NSValue valueWithCGSize:result];
        instance.type = CCArgumentTypeCGSize;
        
    } else if (strcmp(methodReturnType, @encode(CGPoint)) == 0) {
        
        CGPoint result;
        [invocation getReturnValue:&result];
        instance.value = [NSValue valueWithCGPoint:result];
        instance.type = CCArgumentTypeCGPoint;
        
    } else if (strcmp(methodReturnType, @encode(CGRect)) == 0) {
        
        CGRect result;
        [invocation getReturnValue:&result];
        instance.value = [NSValue valueWithCGRect:result];
        instance.type = CCArgumentTypeCGRect;
    } else if (strcmp(methodReturnType, @encode(UIEdgeInsets)) == 0) {
        
        UIEdgeInsets result;
        [invocation getReturnValue:&result];
        instance.value = [NSValue valueWithUIEdgeInsets:result];
        instance.type = CCArgumentTypeUIEdgeInsets;
    } else if (strcmp(methodReturnType, @encode(Class)) == 0) {
        
        Class result;
        [invocation getReturnValue:&result];
        instance.value = result;
        instance.type = CCArgumentTypeClass;
    }
    
    invocation.target = nil;
    
    return instance;
}

+ (id)aspectInstanceValueWithType:(CCArgumentType)type contentString:(NSString *)contentString localVariables:(NSMutableDictionary<NSString *, CCAspectInstance *> *)localVariables
{
    id instance = nil;
    
    if (type == CCArgumentTypeUnknown) {
        return instance;
    }
    
    if (type == CCArgumentTypeObject) {
        
        instance = [[localVariables objectForKey:contentString] value];
        if (instance == nil) {
            instance = contentString;
        }
    } else if (type == CCArgumentTypeClass) {
        
        instance = NSClassFromString(contentString);
        
    } else if (type == CCArgumentTypeSEL) {
        
        instance = contentString;
        
    } else if (type == CCArgumentTypeCGRect) {
        
        NSArray *rectComponents = [contentString componentsSeparatedByString:@","];
        if (rectComponents.count == 4) {
            CGRect rect = CGRectMake([rectComponents[0] doubleValue], [rectComponents[1] doubleValue], [rectComponents[2] doubleValue], [rectComponents[3] doubleValue]);
            instance = [NSValue valueWithCGRect:rect];
        } else {
            instance = [NSValue valueWithCGRect:CGRectZero];
        }
        
    } else if (type == CCArgumentTypeUIEdgeInsets) {
        
        NSArray *insetsComponents = [contentString componentsSeparatedByString:@","];
        if (insetsComponents.count == 4) {
            UIEdgeInsets insets = UIEdgeInsetsMake([insetsComponents[0] doubleValue], [insetsComponents[1] doubleValue], [insetsComponents[2] doubleValue], [insetsComponents[3] doubleValue]);
            instance = [NSValue valueWithUIEdgeInsets:insets];
        } else {
            instance = [NSValue valueWithUIEdgeInsets:UIEdgeInsetsZero];
        }
        
    } else if (type == CCArgumentTypeCGSize) {
        
        NSArray *sizeComponents = [contentString componentsSeparatedByString:@","];
        if (sizeComponents.count == 2) {
            CGSize size = CGSizeMake([sizeComponents[0] doubleValue], [sizeComponents[1] doubleValue]);
            instance = [NSValue valueWithCGSize:size];
        } else {
            instance = [NSValue valueWithCGSize:CGSizeZero];
        }
        
    } else if (type == CCArgumentTypeCGPoint) {
        
        NSArray *pointComponents = [contentString componentsSeparatedByString:@","];
        if (pointComponents.count == 2) {
            CGPoint point = CGPointMake([pointComponents[0] doubleValue], [pointComponents[1] doubleValue]);
            instance = [NSValue valueWithCGPoint:point];
        } else {
            instance = [NSValue valueWithCGPoint:CGPointZero];
        }
    } else if (type == CCArgumentTypeInt) {
        
        instance = @([contentString intValue]);
        
    } else if (type == CCArgumentTypeLong) {
        
        instance = @([contentString integerValue]);
        
    } else if (type == CCArgumentTypeUnsignedLong) {
        
        instance = @([contentString doubleValue]);
        
    } else if (type == CCArgumentTypeLongLong) {
        
        instance = @([contentString longLongValue]);
        
    } else if (type == CCArgumentTypeFloat) {
        
        instance = @([contentString floatValue]);
        
    } else if (type == CCArgumentTypeDouble) {
        
        instance = @([contentString doubleValue]);
        
    } else if (type == CCArgumentTypeBool) {
        
        instance = @([contentString boolValue]);
        
    } else {
        CCAspectLog(@"%@", [NSString stringWithFormat:@"[CCAspect] Argument type:[%zd] is unsupport", type]);
    }
    
    return instance;
}

#pragma mark - CCAspectHookCustomInvoke

+ (void)handleAspectCustomInvokeWithAspectInfo:(id<AspectInfoProtocol>)aspectInfo aspectModel:(CCAspectModel *)aspectModel
{
    if (aspectModel.hookType == CCAspectHookCustomInvokeAfter) {
        [aspectInfo.originalInvocation invoke];
    }
    
    NSMutableDictionary<NSString *, CCAspectInstance *> *localVariables = [NSMutableDictionary dictionary];
    BOOL shouldReturn = NO;
    BOOL shouldInvoke = YES;
    
    for (CCAspectMessage *message in aspectModel.customInvokeMessages) {
        
        shouldInvoke = YES;
        if (message.invokeCondition != nil) {
            if (message.invokeCondition[@"conditionKey"]) {
                NSNumber *conditionCache = [[localVariables objectForKey:message.invokeCondition[@"conditionKey"]] value];
                if (conditionCache != nil) {
                    shouldInvoke = [conditionCache boolValue];
                } else {
                    shouldInvoke = [self shouldInvokedMessage:message aspectModel:aspectModel localVariables:localVariables aspectInfo:aspectInfo];
                    CCAspectInstance *instanceCondition = [[CCAspectInstance alloc] init];
                    instanceCondition.type = CCArgumentTypeBool;
                    instanceCondition.value = @(shouldInvoke);
                    [localVariables setObject:instanceCondition forKey:message.invokeCondition[@"conditionKey"]];
                }
                
            } else {
                shouldInvoke = [self shouldInvokedMessage:message aspectModel:aspectModel localVariables:localVariables aspectInfo:aspectInfo];
            }
        }
        
        // Only create condition instance
        if (message.message == nil) {
            continue;
        }
        
        if (shouldInvoke) {
            if (message.messageType == CCAspectMessageTypeReturn) {
                
                [self invokeReturnMessage:message aspectModel:aspectModel localVariables:localVariables aspectInfo:aspectInfo];
                shouldReturn = YES;
                CCAspectLog(@"[CCAspect] Message:[%@ %@] has been return success", aspectModel.className, aspectModel.selName);
                break;
                
            } else if (message.messageType == CCAspectMessageTypeAssign) {
                
                [self invokeAssignMessage:message aspectModel:aspectModel localVariables:localVariables aspectInfo:aspectInfo];
                
            } else {
                CCAspectInstance *localInstance = [self invokeCustomMessage:message aspectModel:aspectModel aspectInfo:aspectInfo localVariables:[localVariables copy]];
                if (message.localInstanceKey.length > 0) {
                    if (localInstance && localInstance.type != CCArgumentTypeUnknown) {
                        [localVariables setObject:localInstance forKey:message.localInstanceKey];
                        CCAspectLog(@"[CCAspect] Message:[%@] invoke success", message.message);
                    } else {
                        CCAspectLog(@"[CCAspect] Message:[%@] return value is nil", message.message);
                    }
                } else {
                    CCAspectLog(@"[CCAspect] Message:[%@] invoke success", message.message);
                }
            }
        }
    }
    
    if (shouldReturn == NO && aspectModel.hookType == CCAspectHookCustomInvokeBefore) {
        [aspectInfo.originalInvocation invoke];
        
    } else  if (shouldReturn || aspectModel.hookType == CCAspectHookCustomInvokeInstead) {
        CCAspectInstance *returnInstance = [localVariables objectForKey:kAspectOriginalMethodReturnValueKey];
        if (returnInstance) {
            id target = object_isClass(aspectInfo.originalInvocation.target) ? [CCAspect class] : [[CCAspect alloc] init];
            aspectInfo.originalInvocation.target = target;
            if (returnInstance.type == CCArgumentTypeObject) {
                
                aspectInfo.originalInvocation.selector = @selector(returnObject);
                [aspectInfo.originalInvocation invoke];
                id expectValue = returnInstance.value;
                [aspectInfo.originalInvocation setReturnValue:&expectValue];
                
            } else if (returnInstance.type == CCArgumentTypeCGRect) {
                
                aspectInfo.originalInvocation.selector = @selector(returnRect);
                [aspectInfo.originalInvocation invoke];
                CGRect expectValue = [(NSValue *)returnInstance.value CGRectValue];
                [aspectInfo.originalInvocation setReturnValue:&expectValue];
                
            } else if (returnInstance.type == CCArgumentTypeUIEdgeInsets) {
                
                aspectInfo.originalInvocation.selector = @selector(returnEdgeInsets);
                [aspectInfo.originalInvocation invoke];
                UIEdgeInsets expectValue = [(NSValue *)returnInstance.value UIEdgeInsetsValue];
                [aspectInfo.originalInvocation setReturnValue:&expectValue];
                
            } else if (returnInstance.type == CCArgumentTypeCGSize) {
                
                aspectInfo.originalInvocation.selector = @selector(returnSize);
                [aspectInfo.originalInvocation invoke];
                CGSize expectValue = [(NSValue *)returnInstance.value CGSizeValue];
                [aspectInfo.originalInvocation setReturnValue:&expectValue];
                
            } else if (returnInstance.type == CCArgumentTypeCGPoint) {
                
                aspectInfo.originalInvocation.selector = @selector(returnPoint);
                [aspectInfo.originalInvocation invoke];
                CGPoint expectValue = [(NSValue *)returnInstance.value CGPointValue];
                [aspectInfo.originalInvocation setReturnValue:&expectValue];
                
            } else if (returnInstance.type == CCArgumentTypeLong) {
                
                aspectInfo.originalInvocation.selector = @selector(returnLong);
                [aspectInfo.originalInvocation invoke];
                long expectValue = [(NSNumber *)returnInstance.value longValue];
                [aspectInfo.originalInvocation setReturnValue:&expectValue];
                
            } else if (returnInstance.type == CCArgumentTypeDouble) {
                
                aspectInfo.originalInvocation.selector = @selector(returnDouble);
                [aspectInfo.originalInvocation invoke];
                double expectValue = [(NSNumber *)returnInstance.value doubleValue];
                [aspectInfo.originalInvocation setReturnValue:&expectValue];
                
            } else if (returnInstance.type == CCArgumentTypeUnsignedLong) {
                
                aspectInfo.originalInvocation.selector = @selector(returnUnsignedLong);
                [aspectInfo.originalInvocation invoke];
                unsigned long expectValue = [(NSNumber *)returnInstance.value unsignedLongValue];
                [aspectInfo.originalInvocation setReturnValue:&expectValue];
                
            } else if (returnInstance.type == CCArgumentTypeBool) {
                
                aspectInfo.originalInvocation.selector = @selector(returnBool);
                [aspectInfo.originalInvocation invoke];
                BOOL expectValue = [(NSNumber *)returnInstance.value boolValue];
                [aspectInfo.originalInvocation setReturnValue:&expectValue];
                
            }
            aspectInfo.originalInvocation.target = nil;
            CCAspectLog(@"[CCAspect] [%@ %@] return type:[%zd] value: %@", aspectModel.className, aspectModel.selName, returnInstance.type, returnInstance.value);
        }
    }
}

+ (BOOL)shouldInvokedMessage:(CCAspectMessage *)message
                 aspectModel:(CCAspectModel *)aspectModel
              localVariables:(NSMutableDictionary<NSString *, CCAspectInstance *> *)localVariables
                  aspectInfo:(id<AspectInfoProtocol>)aspectInfo
{
    BOOL shouldInvoke = NO;
    
    do {
        
        NSString *operator = [message.invokeCondition objectForKey:@"operator"];
        
        if (operator == nil) {
            NSString *errorMsg = @"[CCAspect] Invoke condition operator must not be nil";
            CCAspectLog(@"%@", errorMsg);
            NSAssert(NO, errorMsg);
            break;
        }
        
        NSArray *conditionComponents = [message.invokeCondition[@"condition"] componentsSeparatedByString:operator];
        
        if (conditionComponents.count != 2) {
            NSString *errorMsg = [NSString stringWithFormat:@"[CCAspect] Condition:[%@] components which separated by [%@] must equal to 2", message.invokeCondition[@"condition"], operator];
            CCAspectLog(@"%@", errorMsg);
            NSAssert(NO, errorMsg);
            break;
        }
        
        if ([operator isEqualToString:@">"]  ||
            [operator isEqualToString:@">="] ||
            [operator isEqualToString:@"<"]  ||
            [operator isEqualToString:@"<="] ||
            [operator isEqualToString:@"||"] ||
            [operator isEqualToString:@"&&"]) {
            
            NSNumber *target_1 = [[localVariables objectForKey:conditionComponents.firstObject] value];
            if (target_1 == nil) {
                if ([aspectModel.parameterNames containsObject:conditionComponents.firstObject]) {
                    CCAspectArgument *argument = [self getArgumentWithInvocation:aspectInfo.originalInvocation
                                                                         atIndex:[aspectModel.parameterNames indexOfObject:conditionComponents.firstObject]
                                                                  shouldSetValue:YES];
                    target_1 = argument.value;
                } else {
                    target_1 = @([conditionComponents.firstObject doubleValue]);
                }
            }
            
            NSNumber *target_2 = [[localVariables objectForKey:conditionComponents.lastObject] value];
            if (target_2 == nil) {
                if ([aspectModel.parameterNames containsObject:conditionComponents.lastObject]) {
                    CCAspectArgument *argument = [self getArgumentWithInvocation:aspectInfo.originalInvocation
                                                                         atIndex:[aspectModel.parameterNames indexOfObject:conditionComponents.lastObject]
                                                                  shouldSetValue:YES];
                    target_2 = argument.value;
                } else {
                    target_2 = @([conditionComponents.lastObject doubleValue]);
                }
            }
            
            if ([operator isEqualToString:@">"] && NSOrderedDescending == [target_1 compare:target_2]) {
                shouldInvoke = YES;
                break;
            }
            
            if ([operator isEqualToString:@">="] && (NSOrderedDescending == [target_1 compare:target_2] || NSOrderedSame == [target_1 compare:target_2])) {
                shouldInvoke = YES;
                break;
            }
            
            if ([operator isEqualToString:@"<"] && NSOrderedAscending == [target_1 compare:target_2]) {
                shouldInvoke = YES;
                break;
            }
            
            if ([operator isEqualToString:@"<="] &&( NSOrderedAscending == [target_1 compare:target_2] || NSOrderedSame == [target_1 compare:target_2])) {
                shouldInvoke = YES;
                break;
            }
            
            if ([operator isEqualToString:@"||"]) {
                shouldInvoke = target_1.boolValue || target_2.boolValue;
                break;
            }
            
            if ([operator isEqualToString:@"&&"]) {
                shouldInvoke = target_1.boolValue && target_2.boolValue;
                break;
            }
            
        } else if ([operator isEqualToString:@"=="]) {
            
            if ([conditionComponents.lastObject isEqualToString:@"nil"]) {
                
                id target_1 = [[localVariables objectForKey:conditionComponents.firstObject] value];
                
                if (target_1 == nil && [aspectModel.parameterNames containsObject:conditionComponents.firstObject]) {
                    CCAspectArgument *argument = [self getArgumentWithInvocation:aspectInfo.originalInvocation
                                                                         atIndex:[aspectModel.parameterNames indexOfObject:conditionComponents.firstObject]
                                                                  shouldSetValue:YES];
                    target_1 = argument.value;
                }
                
                if (target_1 == nil) {
                    shouldInvoke = YES;
                }
            } else {
                NSNumber *target_1 = [[localVariables objectForKey:conditionComponents.firstObject] value];
                if (target_1 == nil) {
                    if ([aspectModel.parameterNames containsObject:conditionComponents.firstObject]) {
                        CCAspectArgument *argument = [self getArgumentWithInvocation:aspectInfo.originalInvocation
                                                                             atIndex:[aspectModel.parameterNames indexOfObject:conditionComponents.firstObject]
                                                                      shouldSetValue:YES];
                        target_1 = argument.value;
                    } else {
                        target_1 = @([conditionComponents.firstObject doubleValue]);
                    }
                }
                
                NSNumber *target_2 = [[localVariables objectForKey:conditionComponents.lastObject] value];
                if (target_2 == nil) {
                    if ([aspectModel.parameterNames containsObject:conditionComponents.lastObject]) {
                        CCAspectArgument *argument = [self getArgumentWithInvocation:aspectInfo.originalInvocation
                                                                             atIndex:[aspectModel.parameterNames indexOfObject:conditionComponents.lastObject]
                                                                      shouldSetValue:YES];
                        target_2 = argument.value;
                    } else {
                        target_2 = @([conditionComponents.lastObject doubleValue]);
                    }
                }
                
                if (NSOrderedSame == [target_1 compare:target_2]) {
                    shouldInvoke = YES;
                }
            }
            
        } else if ([operator isEqualToString:@"!="]) {
            NSNumber *target_1 = [[localVariables objectForKey:conditionComponents.firstObject] value];
            if (target_1 == nil) {
                if ([aspectModel.parameterNames containsObject:conditionComponents.firstObject]) {
                    CCAspectArgument *argument = [self getArgumentWithInvocation:aspectInfo.originalInvocation
                                                                         atIndex:[aspectModel.parameterNames indexOfObject:conditionComponents.firstObject]
                                                                  shouldSetValue:YES];
                    target_1 = argument.value;
                } else {
                    target_1 = @([conditionComponents.firstObject doubleValue]);
                }
            }
            
            NSNumber *target_2 = [[localVariables objectForKey:conditionComponents.lastObject] value];
            if (target_2 == nil) {
                if ([aspectModel.parameterNames containsObject:conditionComponents.lastObject]) {
                    CCAspectArgument *argument = [self getArgumentWithInvocation:aspectInfo.originalInvocation
                                                                         atIndex:[aspectModel.parameterNames indexOfObject:conditionComponents.lastObject]
                                                                  shouldSetValue:YES];
                    target_2 = argument.value;
                } else {
                    target_2 = @([conditionComponents.lastObject doubleValue]);
                }
            }
            
            if (NSOrderedSame != [target_1 compare:target_2]) {
                shouldInvoke = YES;
            }
        } else {
            NSString *errorMsg = [NSString stringWithFormat:@"[CCAspect] Message:[%@] operator:[%@] type is unknown", message.message, operator];
            CCAspectLog(@"%@", errorMsg);
            NSAssert(NO, errorMsg);
        }
        
    } while (0);
    
    return shouldInvoke;
}

+ (void)invokeAssignMessage:(CCAspectMessage *)message
                aspectModel:(CCAspectModel *)aspectModel
             localVariables:(NSMutableDictionary<NSString *, CCAspectInstance *> *)localVariables
                 aspectInfo:(id<AspectInfoProtocol>)aspectInfo
{
    NSArray *msgComponents = [message.message componentsSeparatedByString:@"="];
    
    if (msgComponents.count != 2) {
        NSString *errorMsg = [NSString stringWithFormat:@"[CCAspect] Message:[%@] components which separated by [=] must equal to 2", message.message];
        CCAspectLog(@"%@", errorMsg);
        NSAssert(NO, errorMsg);
        return;
    }
    
    NSArray *instanceValues = [msgComponents.lastObject componentsSeparatedByString:@":"];
    if (instanceValues.count != 2) {
        NSString *errorMsg = [NSString stringWithFormat:@"[CCAspect] InstanceValue:[%@] components which separated by [:] must equal to 2", msgComponents.lastObject];
        CCAspectLog(@"%@", errorMsg);
        NSAssert(NO, errorMsg);
        return;
    }
    
    if ([aspectModel.parameterNames containsObject:msgComponents.firstObject]) {
        
        NSUInteger argumentIndex = [aspectModel.parameterNames indexOfObject:msgComponents.firstObject]  + CCAspectMethodDefaultArgumentsCount;
        CCAspectArgument *argument = [[CCAspectArgument alloc] init];
        argument.type = [instanceValues.firstObject integerValue];
        argument.index = argumentIndex;
        argument.value = [CCAspect aspectInstanceValueWithType:argument.type contentString:instanceValues.lastObject localVariables:localVariables];
        [CCAspect setArgumentValue:argument invocation:aspectInfo.originalInvocation];
        
    } else {
        
        CCAspectInstance *instance = [localVariables objectForKey:msgComponents.firstObject];
        
        if (instance == nil) {
            instance = [[CCAspectInstance alloc] init];
            instance.type = [instanceValues.firstObject integerValue];
            [localVariables setObject:instance forKey:msgComponents.firstObject];
        }
        
        instance.value = [CCAspect aspectInstanceValueWithType:instance.type contentString:instanceValues.lastObject localVariables:localVariables];
    }
}

+ (void)invokeReturnMessage:(CCAspectMessage *)message
                aspectModel:(CCAspectModel *)aspectModel
             localVariables:(NSMutableDictionary<NSString *, CCAspectInstance *> *)localVariables
                 aspectInfo:(id<AspectInfoProtocol>)aspectInfo
{
    if ([message.message isEqualToString:@"return"]) {
        
    } else if ([message.message hasPrefix:@"return="]) {
        
        NSString *returnValue = [message.message substringFromIndex:7];
        NSArray *returnValues = [returnValue componentsSeparatedByString:@":"];
        if (returnValues.count != 2) {
            NSString *errorMsg = [NSString stringWithFormat:@"[CCAspect] ReturnValue:[%@] components which separated by [:] must equal to 2", returnValue];
            CCAspectLog(@"%@", errorMsg);
            NSAssert(NO, errorMsg);
            return;
        }
        
        CCAspectInstance *instance = [localVariables objectForKey:kAspectOriginalMethodReturnValueKey];
        if (instance == nil) {
            instance = [[CCAspectInstance alloc] init];
            instance.type = [returnValues.firstObject integerValue];
            [localVariables setObject:instance forKey:kAspectOriginalMethodReturnValueKey];
        }
        
        instance.value = [CCAspect aspectInstanceValueWithType:instance.type contentString:returnValues.lastObject localVariables:localVariables];
        
    } else {
        NSString *errorMsg = [NSString stringWithFormat:@"[CCAspect] Return Message:[%@] format is error", message.message];
        CCAspectLog(@"%@", errorMsg);
        NSAssert(NO, errorMsg);
    }
}

+ (CCAspectInstance *)invokeCustomMessage:(CCAspectMessage *)message
                              aspectModel:(CCAspectModel *)aspectModel
                               aspectInfo:(id<AspectInfoProtocol>)aspectInfo
                           localVariables:(NSDictionary<NSString *, CCAspectInstance *> *)localVariables;
{
    CCAspectInstance *localInstance = nil;
    
    if (message.message.length == 0) {
        NSString *errorMsg = @"[CCAspect] Message is nil";
        CCAspectLog(@"%@", errorMsg);
        NSAssert(NO, errorMsg);
        return localInstance;
    }
    
    NSArray<NSString *> *messageComponents = [message.message componentsSeparatedByString:@"."];
    
    if (messageComponents.count <= 1) {
        NSString *errorMsg = [NSString stringWithFormat:@"[CCAspect] Message:[%@] is invalid", message.message];
        CCAspectLog(@"%@", errorMsg);
        NSAssert(NO, errorMsg);
        return localInstance;
    }
    
    NSUInteger idx = 0;
    BOOL isClassMethod = NO;
    BOOL isCallSuper = NO;
    id currentTarget = nil;
    
    for (NSString *component in messageComponents) {
        
        if (0 == idx) {
            
            isCallSuper = NO;
            if ([CCAspectClassDefineList containsObject:component]) {
                
                currentTarget = NSClassFromString(component);
                if (currentTarget == nil) {
                    NSString *errorMsg = [NSString stringWithFormat:@"[CCAspect] Message class:[%@] is not exist", component];
                    CCAspectLog(@"%@", errorMsg);
                    NSAssert(NO, errorMsg);
                    break;
                }
                
            } else if ([component isEqualToString:@"self"]) {
                
                currentTarget = aspectInfo.originalInvocation.target;
                
            } else if ([component isEqualToString:@"super"]) {
                
                if (messageComponents.count > 2) {
                    NSString *errorMsg = [NSString stringWithFormat:@"[CCAspect] Message:[%@] super can not contain multiple message invoke", message.message];
                    CCAspectLog(@"%@", errorMsg);
                    NSAssert(NO, errorMsg);
                    break;
                }
                
                SEL superSel = NSSelectorFromString(aspectModel.selName);
                SEL superAliasSel = NSSelectorFromString(cc_superAliasSelString(aspectModel.selName));
                
                if (![aspectInfo.originalInvocation.target respondsToSelector:superAliasSel]) {
                    Class superCls = [aspectInfo.originalInvocation.target superclass];
                    Method superMethod = class_getInstanceMethod(superCls, superSel);
                    IMP superIMP = method_getImplementation(superMethod);
                    Class targetCls = object_isClass(aspectInfo.originalInvocation.target) ? aspectInfo.originalInvocation.target : [aspectInfo.originalInvocation.target class];
                    class_addMethod(targetCls, superAliasSel, superIMP, method_getTypeEncoding(superMethod));
                }
                currentTarget = aspectInfo.originalInvocation.target;
                isCallSuper = YES;
                
            } else if ([localVariables objectForKey:component]) {
                
                currentTarget = [[localVariables objectForKey:component] value];
                
            } else if ([aspectModel.parameterNames containsObject:component]) {
                
                NSUInteger idxOfParamter = [aspectModel.parameterNames indexOfObject:component];
                CCAspectArgument *argument = [self getArgumentWithInvocation:aspectInfo.originalInvocation atIndex:idxOfParamter shouldSetValue:YES];
                
                if (argument == nil || argument.type == CCArgumentTypeUnknown) {
                    NSString *errorMsg = @"[CCAspect] Message parameter is nil";
                    CCAspectLog(@"%@", errorMsg);
                    NSAssert(NO, errorMsg);
                    break;
                }
                
                if (argument.type != CCArgumentTypeObject) {
                    NSString *errorMsg = [NSString stringWithFormat:@"[CCAspect] Message parameter:[%zd] type must be object", argument.type];
                    CCAspectLog(@"%@", errorMsg);
                    NSAssert(NO, errorMsg);
                    break;
                }
                currentTarget = argument.value;
                
            } else {
                
                NSString *errorMsg = [NSString stringWithFormat:@"[CCAspect] CCAspectClassDefineList can not find current class:[%@]", component];
                CCAspectLog(@"%@", errorMsg);
                NSAssert(NO, errorMsg);
                break;
            }
        } else {
            NSMutableArray<CCAspectArgument *> *arguments = [[message.aspectArgumentParameters objectForKey:component] mutableCopy];
            if (arguments.count == 0) {
                NSArray<NSDictionary *> *cureentSelParameters = [message.parameters objectForKey:component];
                if (cureentSelParameters.count > 0) {
                    arguments = [[NSMutableArray alloc] initWithCapacity:cureentSelParameters.count];
                    
                    [cureentSelParameters enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull parameter, NSUInteger idx, BOOL * _Nonnull stop) {
                        
                        CCAspectArgument *argument = nil;
                        CCAspectInstance *localInstance = [localVariables objectForKey:parameter[@"value"]];
                        if (localInstance) {
                            argument = [[CCAspectArgument alloc] init];
                            argument.value = localInstance.value;
                            argument.index = [parameter[@"index"] unsignedIntegerValue] + CCAspectMethodDefaultArgumentsCount;
                            argument.type = [parameter[@"type"] unsignedIntegerValue];
                        } else {
                            if ([aspectModel.parameterNames containsObject:parameter[@"value"]]) {
                                argument = [CCAspect getArgumentWithInvocation:aspectInfo.originalInvocation atIndex:[aspectModel.parameterNames indexOfObject:parameter[@"value"]] shouldSetValue:YES];
                            } else {
                                argument = [CCAspectArgument modelWithArgumentDictionary:parameter];
                            }
                        }
                        [arguments addObject:argument];
                    }];
                    
                    if ([message.aspectArgumentParameters objectForKey:component] == nil) {
                        [message.aspectArgumentParameters setObject:arguments forKey:component];
                    }
                }
            }
            
            isClassMethod = object_isClass(currentTarget) ? YES : NO;
            
            NSString *currentSel = isCallSuper ? cc_superAliasSelString(component) : component;
            localInstance = [self invokeMethodWithTarget:currentTarget selName:currentSel isClassMethod:isClassMethod arguments:arguments];
            currentTarget = localInstance.value;
        }
        
        idx++;
    }
    return localInstance;
}

static NSString * cc_superAliasSelString(NSString *originalSelString) {

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CCSuperAliasSelectorList = [[NSMutableDictionary alloc] init];
    });
    
    NSString *aliasSelString = [CCSuperAliasSelectorList objectForKey:originalSelString];
    if (aliasSelString == nil) {
        aliasSelString = [@"cc_super" stringByAppendingFormat:@"_%@", originalSelString];
        [CCSuperAliasSelectorList setObject:aliasSelString forKey:originalSelString];
    }
    
    return aliasSelString;
}

@end
