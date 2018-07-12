//
//  ReaderWebView.m
//  iReader
//
//  Created by zzyong on 2018/7/11.
//  Copyright © 2018年 zouzhiyong. All rights reserved.
//

#import "ReaderWebView.h"

@implementation ReaderWebView

- (instancetype)init
{
    if (self = [super init]) {
        self.scrollView.showsVerticalScrollIndicator = NO;
        self.scrollView.showsHorizontalScrollIndicator = NO;
    }
    
    return self;
}

@end
