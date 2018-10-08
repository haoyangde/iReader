//
//  IRPagingTypeSelectViewController.h
//  iReader
//
//  Created by zzyong on 2018/10/8.
//  Copyright © 2018年 zouzhiyong. All rights reserved.
//

#import "IRBaseViewController.h"

typedef void (^IRPagingTypeSelectHandler)(IRPageTransitionStyle transitionStyle);

@interface IRPagingTypeSelectViewController : IRBaseViewController

@property (nonatomic, strong) IRPagingTypeSelectHandler selectHandler;

@end
