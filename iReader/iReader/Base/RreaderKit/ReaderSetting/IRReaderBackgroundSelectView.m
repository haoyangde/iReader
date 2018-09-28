//
//  IRReaderBackgroundSelectView.m
//  iReader
//
//  Created by zzyong on 2018/8/28.
//  Copyright © 2018年 zouzhiyong. All rights reserved.
//

#import "IRReaderBackgroundSelectView.h"
#import "IRReaderBackgroundSelectItem.h"
#import <Masonry.h>

static CGFloat const itemInterSpacing = 15;

@interface IRReaderBackgroundSelectView ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) IRReaderBackgroundSelectItem *currentSelectItem;

@end

@implementation IRReaderBackgroundSelectView

- (instancetype)init
{
    if (self = [super init]) {
        [self setupSubviews];
    }
    
    return self;
}

- (void)onReaderBackgroundSelectItemClicked:(IRReaderBackgroundSelectItem *)item
{
    if (item.tag == self.currentSelectItem.tag) {
        return;
    }
    
    IR_READER_CONFIG.readerBgColor = item.backgroundColor;
    [self.currentSelectItem setSelected:NO];
    [item setSelected:YES];
    self.currentSelectItem = item;
    
    if ([self.delegate respondsToSelector:@selector(readerBackgroundSelectViewDidSelectBackgroundColor:)]) {
        [self.delegate readerBackgroundSelectViewDidSelectBackgroundColor:item.backgroundColor];
    }
}

- (void)setupSubviews
{
    CGFloat itemW = 64;
    CGFloat itemH = 25;
    CGFloat itemY = ([IRReaderBackgroundSelectView viewHeight] - itemH) * 0.5;
    NSUInteger itemCount = IR_READER_CONFIG.readerBgSelectColors.count;
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, [IRUIUtilites UIScreenMinWidth], [IRReaderBackgroundSelectView viewHeight])];
    self.scrollView.scrollsToTop = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.contentSize = CGSizeMake(itemW * itemCount + itemInterSpacing * (itemCount + 1), self.height);
    [self addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    __block BOOL hasSelectColor = NO;
    __block IRReaderBackgroundSelectItem *firstItem = nil;
    [IR_READER_CONFIG.readerBgSelectColors enumerateObjectsUsingBlock:^(UIColor * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        IRReaderBackgroundSelectItem *item = [[IRReaderBackgroundSelectItem alloc] init];
        CGFloat itemX = ((itemW + itemInterSpacing) * idx) + itemInterSpacing;
        item.frame = CGRectMake(itemX, itemY, itemW, itemH);
        if (CGColorEqualToColor(IR_READER_CONFIG.readerBgSelectColor.CGColor, obj.CGColor)) {
            [item setSelected:YES];
            hasSelectColor = YES;
            self.currentSelectItem = item;
        }
        item.backgroundColor = obj;
        [item addTarget:self action:@selector(onReaderBackgroundSelectItemClicked:) forControlEvents:UIControlEventTouchUpInside];
        item.tag = idx;
        [self.scrollView addSubview:item];
        
        if (!idx) {
            firstItem = item;
        }
        
        if (idx == IR_READER_CONFIG.readerBgSelectColors.count - 1 && !hasSelectColor) {
            [firstItem setSelected:YES];
            self.currentSelectItem = firstItem;
        }
    }];
    
    UIView *topLine = [[UIView alloc] init];
    topLine.backgroundColor = [UIColor ir_separatorLineColor];
    [self addSubview:topLine];
    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0.5);
        make.top.right.left.equalTo(self);
    }];
}

- (void)scrollSelectItemToVisible
{
    if (self.currentSelectItem) {
        IRDebugLog(@"[IRReaderBackgroundSelectView] currentSelectItem frame: %@", NSStringFromCGRect(self.currentSelectItem.frame));
        if (CGRectGetMaxX(self.currentSelectItem.frame) > [IRUIUtilites UIScreenMinWidth]) {
            [self.scrollView setContentOffset:CGPointMake((CGRectGetMaxX(self.currentSelectItem.frame) - [IRUIUtilites UIScreenMinWidth] + itemInterSpacing ), 0) animated:NO];
        }
    }
}

+ (CGFloat)viewHeight
{
    return 60;
}

@end
