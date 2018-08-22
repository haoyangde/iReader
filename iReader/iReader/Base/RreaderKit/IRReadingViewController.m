//
//  IRReadingViewController.m
//  iReader
//
//  Created by zzyong on 2018/8/17.
//  Copyright © 2018年 zouzhiyong. All rights reserved.
//

#import "IRReadingViewController.h"
#import <DTAttributedLabel.h>
#import "IRPageModel.h"

@interface IRReadingViewController ()

@property (nonatomic, strong) DTAttributedLabel *pageLabel;

@end

@implementation IRReadingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupSubviews];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.pageLabel.frame = self.view.bounds;
}

#pragma mark - Private

- (void)setupSubviews
{
    self.pageLabel = [[DTAttributedLabel alloc] init];
    self.pageLabel.edgeInsets = IR_READER_CONFIG.pageInsets;
    self.pageLabel.numberOfLines = 0;
    [self.view addSubview:self.pageLabel];
}

- (void)setPageModel:(IRPageModel *)pageModel
{
    _pageModel = pageModel;
    
    self.pageLabel.attributedString = pageModel.content;
}

@end
