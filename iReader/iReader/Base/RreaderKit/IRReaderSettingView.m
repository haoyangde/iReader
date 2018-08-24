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

@property (nonatomic ,strong) UIView *pageOrientationView;
@property (nonatomic ,strong) UIButton *verticalBtn;
@property (nonatomic ,strong) UIButton *horizontalBtn;

@property (nonatomic ,strong) UIView *textFontControllView;
@property (nonatomic ,strong) UIButton *fontAddBtn;
@property (nonatomic ,strong) UIButton *fontReduceBtn;
@property (nonatomic ,strong) UISlider *fontSlider;

@end

@implementation IRReaderSettingView

- (instancetype)init
{
    if (self = [super init]) {
        self.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.35];
        
        if (@available(iOS 11.0, *)) {
            self.safeAreaInsetBottom = self.safeAreaInsets.bottom;
        }
        self.menuViewHeight = 225 + self.safeAreaInsetBottom;
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

- (void)onFontReduceButtonClicked:(UIButton *)btn
{
    
}

- (void)onFontAddButtonClicked:(UIButton *)btn
{
    
}

#pragma mark - Private

- (void)setupSubviews
{
    self.menuView = [[UIView alloc] init];
    self.menuView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.menuView];
    
    [self setupPageOrientationView];
    [self setupTextFontControllView];
}

- (void)setupTextFontControllView
{
    self.textFontControllView = [[UIView alloc] init];
    [self.menuView addSubview:self.textFontControllView];
    [self.textFontControllView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(60);
        make.width.equalTo(self.menuView);
        make.bottom.equalTo(self.pageOrientationView.mas_top);
    }];
    
    self.fontReduceBtn = [self buttonWithTitle:nil imageName:@"icon-font-small" sel:@selector(onFontReduceButtonClicked:)];
    [self.textFontControllView addSubview:self.fontReduceBtn];
    [self.fontReduceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.textFontControllView);
        make.width.equalTo(self.textFontControllView.mas_height);
        make.left.equalTo(self.textFontControllView).offset(10);
    }];
    
    self.fontAddBtn = [self buttonWithTitle:nil imageName:@"icon-font-big" sel:@selector(onFontAddButtonClicked:)];
    [self.textFontControllView addSubview:self.fontAddBtn];
    [self.fontAddBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.textFontControllView);
        make.width.equalTo(self.textFontControllView.mas_height);
        make.right.equalTo(self.textFontControllView).offset(-10);
    }];
    
    self.fontSlider = [[UISlider alloc] init];
    self.fontSlider.minimumValue = 12;
    self.fontSlider.maximumValue = 28;
    self.fontSlider.thumbTintColor = IR_READER_CONFIG.appThemeColor;
    [self.textFontControllView addSubview:self.fontSlider];
    [self.fontSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.textFontControllView);
        make.left.equalTo(self.fontReduceBtn.mas_right);
        make.right.equalTo(self.fontAddBtn.mas_left);
    }];
    
    UIView *topLine = [[UIView alloc] init];
    topLine.backgroundColor = [UIColor ir_separatorLineColor];
    [self.textFontControllView addSubview:topLine];
    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0.5);
        make.top.right.left.equalTo(self.textFontControllView);
    }];
}

- (void)setupPageOrientationView
{
    self.pageOrientationView = [[UIView alloc] init];
    [self.menuView addSubview:self.pageOrientationView];
    [self.pageOrientationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(55);
        make.width.equalTo(self.menuView);
        make.bottom.equalTo(self.menuView).offset(-self.safeAreaInsetBottom);
    }];
    
    self.horizontalBtn = [self buttonWithTitle:@" 横向" imageName:@"icon-menu-horizontal" sel:@selector(onHorizontalButtonClicked:)];
    [self.pageOrientationView addSubview:self.horizontalBtn];
    [self.horizontalBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self.pageOrientationView);
        make.right.equalTo(self.pageOrientationView.mas_centerX);
    }];
    
    self.verticalBtn = [self buttonWithTitle:@" 竖向" imageName:@"icon-menu-vertical" sel:@selector(onVerticalButtonClicked:)];
    [self.pageOrientationView addSubview:self.verticalBtn];
    [self.verticalBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(self.pageOrientationView);
        make.left.equalTo(self.pageOrientationView.mas_centerX);
    }];
    
    if (ReaderPageNavigationOrientationHorizontal == IR_READER_CONFIG.readerPageNavigationOrientation) {
        self.horizontalBtn.selected = YES;
    } else {
        self.verticalBtn.selected = YES;
    }
    
    UIView *topLine = [[UIView alloc] init];
    topLine.backgroundColor = [UIColor ir_separatorLineColor];
    [self.pageOrientationView addSubview:topLine];
    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0.5);
        make.top.right.left.equalTo(self.pageOrientationView);
    }];
    
    UIView *middleLine = [[UIView alloc] init];
    middleLine.backgroundColor = [UIColor ir_separatorLineColor];
    [self.pageOrientationView addSubview:middleLine];
    [middleLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(0.5);
        make.center.height.equalTo(self.pageOrientationView);
    }];
}

- (UIButton *)buttonWithTitle:(NSString *)title imageName:(NSString *)imageName sel:(SEL)sel
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.selected = NO;
    [btn setTitle:title forState:UIControlStateNormal];
    btn.tintColor = IR_READER_CONFIG.appThemeColor;
    if (imageName) {
        [btn setImage:[[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
             forState:UIControlStateNormal];
        [btn setImage:[[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]
             forState:UIControlStateSelected];
        [btn setImage:[[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]
             forState:UIControlStateHighlighted];
    }
    
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
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
