//
//  CCAspectMessage.m
//  CC-iPhone
//
//  Created by zzyong on 2019/5/5.
//  Copyright © 2019 netease. All rights reserved.
//

#import "CCAspectMessage.h"

@implementation CCAspectMessage

+ (nullable instancetype)modelWithMessageDictionary:(NSDictionary *)messageDic
{
    if ([messageDic isKindOfClass:[NSDictionary class]]) {
        CCAspectMessage *message = [[CCAspectMessage alloc] init];
        message.message = [messageDic objectForKey:@"message"];
        message.parameters = [messageDic objectForKey:@"parameters"];
        if (message.parameters.count > 0) {
            message.aspectArgumentParameters = [NSMutableDictionary dictionaryWithCapacity:message.parameters.count];
        }
        message.messageType = [[messageDic objectForKey:@"messageType"] unsignedIntegerValue];
        message.invokeCondition = [messageDic objectForKey:@"invokeCondition"];
        message.localInstanceKey = [messageDic objectForKey:@"localInstanceKey"];
        return message;
    } else {
        return nil;
    }
}

@end
