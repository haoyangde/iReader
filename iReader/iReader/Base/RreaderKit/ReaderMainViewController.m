//
//  ReaderMainViewController.m
//  iReader
//
//  Created by zzyong on 2018/7/11.
//  Copyright © 2018年 zouzhiyong. All rights reserved.
//

#import "ReaderMainViewController.h"
#import "ReaderWebView.h"
#import "IREpubHeaders.h"
@interface ReaderMainViewController ()

//@property (nonatomic, strong) UIWebView *readerWebView;
@property (nonatomic, strong) ReaderWebView *readerWebView;

@end

@implementation ReaderMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    self.readerWebView = [[UIWebView alloc] init];
//    self.readerWebView.scrollView.pagingEnabled = YES;
//    self.readerWebView.scrollView.alwaysBounceVertical = NO;
//    self.readerWebView.paginationMode = UIWebPaginationModeLeftToRight;
//    self.readerWebView.paginationBreakingMode = UIWebPaginationBreakingModePage;
    
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    WKPreferences *preferences = [[WKPreferences alloc] init];
    preferences.minimumFontSize = 25;
    
    config.preferences = preferences;
    self.readerWebView = [[ReaderWebView alloc] initWithFrame:self.view.bounds configuration:config];
    self.readerWebView.scrollView.pagingEnabled = YES;
    self.readerWebView.scrollView.alwaysBounceVertical = NO;
    
    [self.view addSubview:self.readerWebView];
    
    [self.readerWebView loadHTMLString:[NSString stringWithContentsOfFile:self.book.tableOfContents[3].resource.fullHref encoding:NSUTF8StringEncoding error:nil] baseURL:nil];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.readerWebView.frame = self.view.bounds;
}

@end
