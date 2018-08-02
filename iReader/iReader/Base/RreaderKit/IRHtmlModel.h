//
//  IRHtmlModel.h
//  iReader
//
//  Created by zzyong on 2018/7/25.
//  Copyright © 2018年 zouzhiyong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IRHtmlModel : NSObject

//例如 @{ @{@"p" : @"p_tag"}, @{@"h1" : @"h1_tag"} }
@property (nonatomic, strong) NSArray<NSDictionary<NSString *, NSObject *> *> *contents;

+ (instancetype)modelWithHtmlString:(NSString *)htmlString;

@end
