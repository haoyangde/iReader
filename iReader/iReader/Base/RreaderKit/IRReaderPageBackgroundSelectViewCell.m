//
//  IRReaderPageBackgroundSelectViewCell.m
//  iReader
//
//  Created by zzyong on 2018/8/28.
//  Copyright © 2018年 zouzhiyong. All rights reserved.
//

#import "IRReaderPageBackgroundSelectViewCell.h"

@interface IRReaderPageBackgroundSelectViewCell ()

@end

@implementation IRReaderPageBackgroundSelectViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
    }
    
    return self;
}

@end
