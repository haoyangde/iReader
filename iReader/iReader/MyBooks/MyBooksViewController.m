//
//  MyBooksViewController.m
//  iReader
//
//  Created by zouzhiyong on 2018/3/12.
//  Copyright © 2018年 zouzhiyong. All rights reserved.
//

#import "MyBooksViewController.h"

#import "IREpubParser.h"

@interface MyBooksViewController ()

@end

@implementation MyBooksViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[IREpubParser sharedInstance] asyncReadEpubWithEpubName:@"每天懂一点好玩心理学" completion:^(IREpubBook *book, NSError *error) {
        
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
