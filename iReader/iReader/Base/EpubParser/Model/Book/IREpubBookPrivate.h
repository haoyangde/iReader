//
//  IREpubBookPrivate.h
//  iReader
//
//  Created by zzyong on 2018/7/10.
//  Copyright © 2018年 zouzhiyong. All rights reserved.
//

#ifndef IREpubBookPrivate_h
#define IREpubBookPrivate_h

#import "IREpubBook.h"
#import "IRContainer.h"
#import "IROpfMetadata.h"
#import "IRResource.h"
#import "IROpfManifest.h"
#import "IRTocRefrence.h"

@interface IREpubBook ()

@property (nonatomic, strong) IRContainer *container;
@property (nonatomic, strong) IROpfMetadata *opfMetadata;
@property (nonatomic, strong) IROpfManifest *opfManifest;

@end

#endif /* IREpubBookPrivate_h */
