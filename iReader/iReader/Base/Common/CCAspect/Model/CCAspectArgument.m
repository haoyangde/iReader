//
//  CCAspectArgument.m
//  CCAspect
//
//  Created by zzyong on 2018/10/18.
//  Copyright © 2018 zzyong. All rights reserved.
//

NSUInteger const CCAspectMethodDefaultArgumentsCount = 2;

#import "CCAspectArgument.h"

@implementation CCAspectArgument

+ (instancetype)modelWithArgumentDictionary:(NSDictionary *)argumentDic
{
    CCAspectArgument *aspectArgument = [[CCAspectArgument alloc] init];
    
    aspectArgument.index = [[argumentDic objectForKey:@"index"] unsignedIntegerValue] + CCAspectMethodDefaultArgumentsCount;
    aspectArgument.type = [[argumentDic objectForKey:@"type"] unsignedIntegerValue];
    
    if (aspectArgument.type == CCArgumentTypeUnknown) {
        IRDebugLog(@"%@", @"[CCAspectArgument] Argument type is CCArgumentTypeUnknown");
        return aspectArgument;
    }
    
     if (aspectArgument.type == CCArgumentTypeClass) {
        
        aspectArgument.value = NSClassFromString([argumentDic objectForKey:@"value"]);
        
    } else if (aspectArgument.type == CCArgumentTypeCGRect) {
        
        NSArray *rectComponents = [[argumentDic objectForKey:@"value"] componentsSeparatedByString:@","];
        if (rectComponents.count == 4) {
            CGRect value = CGRectMake([rectComponents[0] doubleValue], [rectComponents[1] doubleValue], [rectComponents[2] doubleValue], [rectComponents[3] doubleValue]);
            aspectArgument.value = [NSValue valueWithCGRect:value];
        } else {
            IRDebugLog(@"[CCAspect] CGRect value:[%@] type is error", [argumentDic objectForKey:@"value"]);
        }
        
    } else if (aspectArgument.type == CCArgumentTypeCGPoint) {
        
        NSArray *pointComponents = [[argumentDic objectForKey:@"value"] componentsSeparatedByString:@","];
        if (pointComponents.count == 2) {
            CGPoint value = CGPointMake([pointComponents[0] doubleValue], [pointComponents[1] doubleValue]);
            aspectArgument.value = [NSValue valueWithCGPoint:value];
        } else {
            IRDebugLog(@"[CCAspect] CGPoint value:[%@] type is error", [argumentDic objectForKey:@"value"]);
        }
        
    } else if (aspectArgument.type == CCArgumentTypeCGSize) {
        
        NSArray *sizeComponents = [[argumentDic objectForKey:@"value"] componentsSeparatedByString:@","];
        if (sizeComponents.count == 2) {
            CGSize value = CGSizeMake([sizeComponents[0] doubleValue], [sizeComponents[1] doubleValue]);
            aspectArgument.value = [NSValue valueWithCGSize:value];
        } else {
            IRDebugLog(@"[CCAspect] CGSize value:[%@] type is error", [argumentDic objectForKey:@"value"]);
        }
        
    } else if (aspectArgument.type == CCArgumentTypeUIEdgeInsets) {
        
        NSArray *insetsComponents = [[argumentDic objectForKey:@"value"] componentsSeparatedByString:@","];
        if (insetsComponents.count == 4) {
            UIEdgeInsets insets = UIEdgeInsetsMake([insetsComponents[0] doubleValue], [insetsComponents[1] doubleValue], [insetsComponents[2] doubleValue], [insetsComponents[3] doubleValue]);
            aspectArgument.value = [NSValue valueWithUIEdgeInsets:insets];
        } else {
            IRDebugLog(@"[CCAspect] UIEdgeInsets value:[%@] type is error", [argumentDic objectForKey:@"value"]);
        }
        
    } else {
        aspectArgument.value = [argumentDic objectForKey:@"value"];
    }
    
    return aspectArgument;
}


@end
