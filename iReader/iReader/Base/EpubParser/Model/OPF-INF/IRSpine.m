//
//  IRSpine.m
//  iReader
//
//  Created by zzyong on 2018/7/11.
//  Copyright © 2018年 zouzhiyong. All rights reserved.
//

#import "IRSpine.h"

@implementation IRSpine

+ (instancetype)spineWithResource:(IRResource *)resource linear:(BOOL)linear
{
    IRSpine *spine = [[self alloc] init];
    spine.resource = resource;
    spine.linear = linear;
    
    return spine;
}

@end
