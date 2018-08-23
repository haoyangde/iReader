//
//  IRReaderSettingMenuView.m
//  iReader
//
//  Created by zzyong on 2018/8/23.
//  Copyright © 2018年 zouzhiyong. All rights reserved.
//

#import "IRReaderSettingMenuView.h"
#import <Masonry.h>

@interface IRReaderSettingMenuView ()

@property (nonatomic ,strong) UIView *menuView;

@end

@implementation IRReaderSettingMenuView

- (instancetype)init
{
    if (self = [super init]) {
        self.backgroundColor = [UIColor clearColor];
        [self setupSubviews];
    }
    
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    IR_WEAK_SELF
    [self dismissWithAnimated:YES completion:^{
        [weakSelf removeFromSuperview];
    }];
}

#pragma mark - Private

- (void)setupSubviews
{
    self.menuView = [[UIView alloc] init];
    self.menuView.backgroundColor = [UIColor grayColor];
    [self addSubview:self.menuView];
}

#pragma mark - Public

+ (instancetype)readerSettingMenuView
{
    return [[self alloc] init];
}

- (void)showInView:(UIView *)targetView animated:(BOOL)animated
{
    if (!targetView) {
        IRDebugLog(@"TargetView is nil");
        return;
    }
    
    self.frame = targetView.bounds;
    [targetView addSubview:self];
    
    self.menuView.frame = CGRectMake(0, self.height, self.width, 300);
    [UIView animateWithDuration:0.25 animations:^{
        self.menuView.frame = CGRectMake(0, self.height - 300, self.width, 300);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)dismissWithAnimated:(BOOL)animated completion:(void(^)(void))completion
{
    self.menuView.frame = CGRectMake(0, self.height - 300, self.width, 300);
    [UIView animateWithDuration:0.25 animations:^{
        self.menuView.frame = CGRectMake(0, self.height, self.width, 300);
    } completion:^(BOOL finished) {
        if (completion) {
            completion();
        }
    }];
}

@end
