//
//  IRReaderSettingView.m
//  iReader
//
//  Created by zzyong on 2018/8/23.
//  Copyright © 2018年 zouzhiyong. All rights reserved.
//

#import "IRReaderSettingView.h"
#import <Masonry.h>

@interface IRReaderSettingView () <UIGestureRecognizerDelegate>

@property (nonatomic ,strong) UIView *menuView;
@property (nonatomic, assign) CGFloat menuViewHeight;
@property (nonatomic, assign) CGFloat safeAreaInsetBottom;

@property (nonatomic ,strong) UIView *bottomToolView;
@property (nonatomic ,strong) UIButton *verticalBtn;
@property (nonatomic ,strong) UIButton *horizontalBtn;

@end

@implementation IRReaderSettingView

- (instancetype)init
{
    if (self = [super init]) {
        self.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.35];
        
        if (@available(iOS 11.0, *)) {
            self.safeAreaInsetBottom = self.safeAreaInsets.bottom;
        }
        self.menuViewHeight = 200 + self.safeAreaInsetBottom;
        [self setupSubviews];
        [self setupGestures];
    }
    
    return self;
}

#pragma mark - Gesture

- (void)setupGestures
{
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onSingleTap:)];
    singleTap.numberOfTapsRequired = 1;
    singleTap.delegate = self;
    [self addGestureRecognizer:singleTap];
}

- (void)onSingleTap:(UIGestureRecognizer *)recognizer
{
    if ([self.delegate respondsToSelector:@selector(readerSettingViewWillDisappear:)]) {
        [self.delegate readerSettingViewWillDisappear:self];
    }
    
    IR_WEAK_SELF
    [self dismissWithAnimated:YES completion:^{
        [weakSelf removeFromSuperview];
    }];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (CGRectContainsPoint(self.menuView.frame, [gestureRecognizer locationInView:self])) {
        return NO;
    }
    
    return YES;
}

#pragma mark - Actions

- (void)onVerticalButtonClicked:(UIButton *)btn
{
    if (btn.isSelected) {
        return;
    }
    
    btn.selected = YES;
    self.horizontalBtn.selected = NO;
    
    if ([self.delegate respondsToSelector:@selector(readerSettingViewDidClickVerticalButton:)]) {
        [self.delegate readerSettingViewDidClickVerticalButton:self];
    }
}

- (void)onHorizontalButtonClicked:(UIButton *)btn
{
    if (btn.isSelected) {
        return;
    }
    
    btn.selected = YES;
    self.verticalBtn.selected = NO;
    
    if ([self.delegate respondsToSelector:@selector(readerSettingViewDidClickHorizontalButton:)]) {
        [self.delegate readerSettingViewDidClickHorizontalButton:self];
    }
}

#pragma mark - Private

- (void)setupSubviews
{
    self.menuView = [[UIView alloc] init];
    self.menuView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.menuView];
    
    self.bottomToolView = [[UIView alloc] init];
    [self.menuView addSubview:self.bottomToolView];
    [self.bottomToolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(50);
        make.width.equalTo(self.menuView);
        make.bottom.equalTo(self.menuView).offset(-self.safeAreaInsetBottom);
    }];
    
    UIView *bottomTopLine = [[UIView alloc] init];
    bottomTopLine.backgroundColor = [UIColor ir_separatorLineColor];
    [self.bottomToolView addSubview:bottomTopLine];
    [bottomTopLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0.5);
        make.top.right.left.equalTo(self.bottomToolView);
    }];
    
    UIView *bottomMiddleLine = [[UIView alloc] init];
    bottomMiddleLine.backgroundColor = [UIColor ir_separatorLineColor];
    [self.bottomToolView addSubview:bottomMiddleLine];
    [bottomMiddleLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(0.5);
        make.center.equalTo(self.bottomToolView);
    }];
    
    self.horizontalBtn = [self buttonWithTitle:@" 横向" imageName:@"icon-menu-horizontal" sel:@selector(onHorizontalButtonClicked:)];
    [self.bottomToolView addSubview:self.horizontalBtn];
    [self.horizontalBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self.bottomToolView);
        make.right.equalTo(self.bottomToolView.mas_centerX);
    }];
    
    self.verticalBtn = [self buttonWithTitle:@" 竖向" imageName:@"icon-menu-vertical" sel:@selector(onVerticalButtonClicked:)];
    [self.bottomToolView addSubview:self.verticalBtn];
    [self.verticalBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(self.bottomToolView);
        make.left.equalTo(self.bottomToolView.mas_centerX);
    }];
    
    if (ReaderPageNavigationOrientationHorizontal == IR_READER_CONFIG.readerPageNavigationOrientation) {
        self.horizontalBtn.selected = YES;
    } else {
        self.verticalBtn.selected = YES;
    }
}

- (UIButton *)buttonWithTitle:(NSString *)title imageName:(NSString *)imageName sel:(SEL)sel
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.selected = NO;
    [btn setTitle:title forState:UIControlStateNormal];
    btn.tintColor = IR_READER_CONFIG.appThemeColor;
    [btn setImage:[[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [btn setImage:[[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateSelected];
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    [btn setTitleColor:[UIColor colorWithWhite:0.4 alpha:1] forState:UIControlStateNormal];
    [btn setTitleColor:IR_READER_CONFIG.appThemeColor forState:UIControlStateSelected];
    [btn addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}

#pragma mark - Public

+ (instancetype)readerSettingView
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
    
    if (animated) {
        self.alpha = 0;
        self.menuView.frame = CGRectMake(0, self.height, self.width, _menuViewHeight);
        [UIView animateWithDuration:0.25 animations:^{
            self.alpha = 1;
            self.menuView.frame = CGRectMake(0, self.height - _menuViewHeight, self.width, _menuViewHeight);
        }];
    } else {
        self.menuView.frame = CGRectMake(0, self.height - _menuViewHeight, self.width, _menuViewHeight);
    }
}

- (void)dismissWithAnimated:(BOOL)animated completion:(void(^)(void))completion
{
    if (animated) {
        self.menuView.frame = CGRectMake(0, self.height - _menuViewHeight, self.width, _menuViewHeight);
        self.alpha = 1;
        [UIView animateWithDuration:0.25 animations:^{
            self.menuView.frame = CGRectMake(0, self.height, self.width, _menuViewHeight);
            self.alpha = 0;
        } completion:^(BOOL finished) {
            if (completion) {
                completion();
            }
            self.alpha = 1;
        }];
    } else {
        self.menuView.hidden = YES;
    }
}

@end
