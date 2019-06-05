//
//  CCAspectModel.m
//  CCAspect
//
//  Created by zzyong on 2018/10/18.
//  Copyright © 2018 zzyong. All rights reserved.
//

#import "CCAspectModel.h"
#import "CCAspectArgument.h"
#import "CCAspectMessage.h"

@implementation CCAspectModel

+ (nullable instancetype)modelWithAspectDictionary:(NSDictionary *)aspectDictionary
{
    CCAspectModel *aspectModel = nil;
    do {
        if (![aspectDictionary isKindOfClass:[NSDictionary class]]) {
            NSAssert(0, @"[CCAspectModel] aspectDictionary class must be NSDictionary");
            break;
        }
        
        NSString *className = [aspectDictionary objectForKey:@"className"];
        NSString *selName = [aspectDictionary objectForKey:@"selName"];
        if (!className || !selName || ![className isKindOfClass:[NSString class]] || ![selName isKindOfClass:[NSString class]]) {
            break;
        }
        
        aspectModel = [[CCAspectModel alloc] init];
        aspectModel.className = className;
        aspectModel.selName = selName;
        aspectModel.hookType = [[aspectDictionary objectForKey:@"hookType"] unsignedIntegerValue];
        aspectModel.parameterNames = [aspectDictionary objectForKey:@"parameterNames"];
        
        NSArray<NSDictionary *> *customInvokeMessages = [aspectDictionary objectForKey:@"customInvokeMessages"];
        if ([customInvokeMessages isKindOfClass:[NSArray class]] && customInvokeMessages.count > 0) {
            NSMutableArray<CCAspectMessage *> *messages = [NSMutableArray arrayWithCapacity:customInvokeMessages.count];
            
            [customInvokeMessages enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                CCAspectMessage *message = [CCAspectMessage modelWithMessageDictionary:obj];
                if (message) {
                    [messages addObject:message];
                }
            }];
            
            aspectModel.customInvokeMessages = messages;
        }
        
        
    } while (0);
    
    return aspectModel;
}

@end
