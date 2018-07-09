//
//  IREpubParser.m
//  iReader
//
//  Created by zouzhiyong on 2018/3/15.
//  Copyright © 2018年 zouzhiyong. All rights reserved.
//

#import "IREpubParser.h"
#import "IREpubBook.h"
#import <ZipArchive.h>
#import "GDataXMLNode.h"
#import "IRContainer.h"
#import "IRMediaType.h"

static NSString *const kContainerXMLAppendPath = @"META-INF/container.xml";

@interface IREpubParser ()

@property (nonatomic, strong) IREpubBook *book;
@property (nonatomic, strong) dispatch_queue_t ir_epub_parser_queue;
@property (nonatomic, strong) NSFileManager *fileManager;

@end

@implementation IREpubParser

+ (instancetype)sharedInstance
{
    static IREpubParser *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (instancetype)init
{
    if (self = [super init]) {
        _ir_epub_parser_queue = dispatch_queue_create("ir_epub_parser_queue", DISPATCH_QUEUE_SERIAL);
        _fileManager = [NSFileManager defaultManager];
    }
    
    return self;
}

- (void)asyncReadEpubWithEpubName:(NSString *)epubPath completion:(ReadEpubCompletion)completion
{
    if (!completion) {
        return;
    }
    
    dispatch_async(_ir_epub_parser_queue, ^{
        [self handleEpubWithEpubName:epubPath completion:completion];
    });
}

- (void)handleEpubWithEpubName:(NSString *)epubName completion:(ReadEpubCompletion)completion
{
    NSString *epubPath = [[NSBundle mainBundle] pathForResource:epubName ofType:@"epub"];
    
    IREpubBook *book = nil;
    NSError *epubError  = nil;
    NSString *errorInfo = nil;
    NSString *unzipPath = nil;
    
    while (1) {
        if (![_fileManager fileExistsAtPath:epubPath]) {
            errorInfo = @"[IREpubParser] Epub book not found";
            NSAssert(NO, errorInfo);
            break;
        }
        
        unzipPath = [[IRFileUtilites applicationCachesDirectory] stringByAppendingPathComponent:epubName];
        
        BOOL isDir;
        BOOL needUnzip = ![_fileManager fileExistsAtPath:unzipPath isDirectory:&isDir] || !isDir;
        if (needUnzip) {
            ZipArchive *zip = [[ZipArchive alloc] init];
            BOOL openSuccess = [zip UnzipOpenFile:epubPath];
            BOOL unzipSuccess = [zip UnzipFileTo:unzipPath overWrite:YES];
            [zip UnzipCloseFile];
            
            if (!openSuccess && !unzipSuccess) {
                errorInfo = @"[IREpubParser] Epub book unzip failed";
                NSAssert(NO, errorInfo);
                break;
            }
        }
        
        break;
    }
    
    if (!errorInfo.length) {
        book = [[IREpubBook alloc] init];
        book.name = epubName;
        [self readContainerXMLWithUnzipPath:unzipPath book:book error:&epubError];
        [self readOpfXMLWithUnzipPath:unzipPath book:book error:&epubError];
    } else {
        epubError = [self epubPareserErrorWithInfo:errorInfo];
    }
    
    runOnMainThread(^{
        completion(book, epubError);
    });
}

/**
 ContainerXML format
 
 <?xml version="1.0" encoding="UTF-8" ?>
 <container version="1.0" xmlns="urn:oasis:names:tc:opendocument:xmlns:container">
     <rootfiles>
         <rootfile full-path="OPS/fb.opf" media-type="application/oebps-package+xml"/>
     </rootfiles>
 </container>

 */
- (void)readContainerXMLWithUnzipPath:(NSString *)unzipPath book:(IREpubBook *)book error:(NSError **)error
{
    NSString *containerXMLPath = [unzipPath stringByAppendingPathComponent:kContainerXMLAppendPath];
    NSData *containerData = [NSData dataWithContentsOfFile:containerXMLPath options:NSDataReadingMappedAlways error:nil];
    
    GDataXMLDocument *xmlDoc = [[GDataXMLDocument alloc] initWithData:containerData options:0 error:error];
    NSLog(@"%@", xmlDoc.rootElement);
    
    GDataXMLElement *rootfiles = [xmlDoc.rootElement elementsForName:@"rootfiles"].firstObject;
    GDataXMLElement *rootfile  = [rootfiles elementsForName:@"rootfile"].firstObject;
    IRMediaType *mediaType = [IRMediaType mediaTypeWithName:[[rootfile attributeForName:@"media-type"] stringValue] filePath:nil];
    book.container = [IRContainer containerWithFullPath:[[rootfile attributeForName:@"full-path"] stringValue]
                                              mediaType:mediaType];
}

/**
 OPF 文件构成
     1. meatadata
         < dc-metadata >: 核心元素
             < title >, < creator >, < subject >, < description >, < contributor >
             < date >, < type >, < format >, < identifier >, < source >, < language >
             < relation >, < coverage >, < rights >
         < x-metadata >: 扩展元素
     2. manifest
     3. spine
     4. guide
     5. tour
 @param unzipPath Epub 文件解压路径
 */
- (void)readOpfXMLWithUnzipPath:(NSString *)unzipPath book:(IREpubBook *)book error:(NSError **)error
{
    
}

#pragma mark - helper

- (NSError *)epubPareserErrorWithInfo:(NSString *)info
{
    return [NSError errorWithDomain:@"EpubPareserErrorDomain" code:-1 userInfo:@{@"errorInfo" : info}];
}

@end
