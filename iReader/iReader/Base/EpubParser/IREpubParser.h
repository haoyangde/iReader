//
//  IREpubParser.h
//  iReader
//
//  Created by zouzhiyong on 2018/3/15.
//  Copyright © 2018年 zouzhiyong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IREpubBook;

typedef void(^ReadEpubCompletion)(IREpubBook *book, NSError *error);

@interface IREpubParser : NSObject

+ (instancetype)sharedInstance;

- (void)asyncReadEpubWithEpubName:(NSString *)epubPath completion:(ReadEpubCompletion)completion;

@end

/**
 Epub 文件结构
     <1> Mimetype 文件：文件格式
     <2> META-INF 目录：
         作用：用于存放容器信息
         内容：
             1. 基本文件：container.xml
             2. 可选：manifest.xml(文件列表)、metadata.xml(元数据)、signatures.xml(数字签名)、encryption.xml(加密)、rights.xml(权限管理)
     <3> OPS 目录：
         1. 存放OPF文档、CSS文档、NCX 文档、资源文件（images等）。中文电子书则还包含 TTF文档
         2. content.opf 文件和 toc.ncx 文件为必需。其他可选
 */
