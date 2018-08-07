//
//  IRReaderNavigationView.m
//  iReader
//
//  Created by zzyong on 2018/8/6.
//  Copyright © 2018年 zouzhiyong. All rights reserved.
//

#import "IRReaderNavigationView.h"
#import <Masonry.h>

@interface IRReaderNavigationView ()

@property (nonatomic, strong) UIView *customContentView;
@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, strong) UIButton *fontBtn;
@property (nonatomic, strong) UIButton *shareBtn;
@property (nonatomic, strong) UIButton *chapterListBtn;

@end

@implementation IRReaderNavigationView

@dynamic delegate;

- (instancetype)init
{
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        self.translucent = YES;
        [self setupSubviews];
    }
    
    return self;
}

#pragma mark - Actions

- (void)onCloseButtonClicked
{
    if (self.actionDelegate && [self.actionDelegate respondsToSelector:@selector(readerNavigationViewDidClickCloseButton:)]) {
        [self.actionDelegate readerNavigationViewDidClickCloseButton:self];
    }
}

- (void)onShareButtonClicked
{
    
}

- (void)onChapterListClicked
{
    if (self.actionDelegate && [self.actionDelegate respondsToSelector:@selector(readerNavigationViewDidClickChapterListButton:)]) {
        [self.actionDelegate readerNavigationViewDidClickChapterListButton:self];
    }
}

#pragma mark - Private

- (void)setupSubviews
{
    self.customContentView = [[UIView alloc] init];
    [self addSubview:self.customContentView];
    [self.customContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    self.closeBtn = [self commonButtonWithImageName:@"navbar_close" action:@selector(onCloseButtonClicked)];
    [self.customContentView addSubview:self.closeBtn];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(17);
        make.left.equalTo(self).offset(15);
        make.centerY.equalTo(self);
    }];
    
    self.shareBtn = [self commonButtonWithImageName:@"navbar_share" action:@selector(onShareButtonClicked)];
    [self.customContentView addSubview:self.shareBtn];
    [self.shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(17);
        make.height.mas_equalTo(23);
        make.right.equalTo(self).offset(-15);
        make.centerY.equalTo(self);
    }];
    
    self.chapterListBtn = [self commonButtonWithImageName:@"navbar_chapter_list" action:@selector(onChapterListClicked)];
    [self.customContentView addSubview:self.chapterListBtn];
    [self.chapterListBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(22);
        make.height.mas_equalTo(14);
        make.right.equalTo(self.shareBtn.mas_left).offset(-25);
        make.centerY.equalTo(self);
    }];
}

- (UIButton *)commonButtonWithImageName:(NSString *)imageName action:(SEL)action
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    return btn;
}

#pragma mark - Public

- (void)shouldHideAllCustomViews:(BOOL)hidden
{
    self.customContentView.hidden = hidden;
}

@end
