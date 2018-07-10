//
//  IREpubParser.m
//  iReader
//
//  Created by zouzhiyong on 2018/3/15.
//  Copyright © 2018年 zouzhiyong. All rights reserved.
//

#import "IREpubParser.h"
#import <ZipArchive.h>
#import "GDataXMLNode.h"
#import "IRMediaType.h"
#import "IREpubBookPrivate.h"

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
        IRDebugLog(@"[IREpubParser] Epub unzip Path: %@", unzipPath);
        
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
        if (!epubError) {
            [self readOpfXMLWithUnzipPath:unzipPath book:book error:&epubError];
        }
        
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
    NSData *containerData = [NSData dataWithContentsOfFile:containerXMLPath options:NSDataReadingMappedAlways error:error];
    
    if (!containerData && *error) {
        IRDebugLog(@"[IREpubParser] Creat container data error: %@", *error);
        return;
    }
    
    GDataXMLDocument *xmlDoc = [[GDataXMLDocument alloc] initWithData:containerData options:0 error:error];
    IRDebugLog(@"[IREpubParser] containerXML: %@", xmlDoc.rootElement);
    
    if (!xmlDoc && *error) {
        IRDebugLog(@"[IREpubParser] Container XML parse error: %@", *error);
        return;
    }
    
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
    NSString *opfPath = [unzipPath stringByAppendingPathComponent:book.container.fullPath];
    NSData *opfData = [NSData dataWithContentsOfFile:opfPath options:NSDataReadingMappedAlways error:error];
    
    if (!opfData && *error) {
        IRDebugLog(@"[IREpubParser] Creat OPF data error: %@", *error);
        return;
    }
    
    GDataXMLDocument *opfDoc = [[GDataXMLDocument alloc] initWithData:opfData options:0 error:error];
    IRDebugLog(@"[IREpubParser] OPF content: %@", opfDoc.rootElement);
    
    if (!opfDoc && *error) {
        IRDebugLog(@"[IREpubParser] OPF parse error: %@", *error);
        return;
    }
    
    // Base OPF info
    NSString *identifier = nil;
    GDataXMLElement *package = opfDoc.rootElement;
    identifier = [[package attributeForName:@"unique-identifier"] stringValue];
    book.version = [[package attributeForName:@"version"] stringValue];
    IRDebugLog(@"[IREpubParser] OPF unique-identifier: %@ version: %@", identifier, book.version);
    
    // metadata
    GDataXMLElement *opfMetadataDoc = [package elementsForName:@"metadata"].firstObject;
    if (opfMetadataDoc) {
        book.opfMetadata = [self readOpfMetadataWithXMLElement:opfMetadataDoc];
    }
}

- (IROpfMetadata *)readOpfMetadataWithXMLElement:(GDataXMLElement *)opfMetadataDoc
{
    IROpfMetadata *opfMetadata = [[IROpfMetadata alloc] init];
    for (GDataXMLElement *element in opfMetadataDoc.children) {
        if ([element.name isEqualToString:@"dc:title"]) {
            opfMetadata.title = [element stringValue];
            
        } else if ([element.name isEqualToString:@"dc:language"]) {
            opfMetadata.language = [element stringValue];
            
        } else if ([element.name isEqualToString:@"dc:creator"]) {
            opfMetadata.creator = [element stringValue];
            
        } else if ([element.name isEqualToString:@"dc:description"]) {
            opfMetadata.bookDesc = [element stringValue];
            
        } else if ([element.name isEqualToString:@"dc:source"]) {
            opfMetadata.source = [element stringValue];
            
        } else if ([element.name isEqualToString:@"dc:date"]) {
            opfMetadata.date = [element stringValue];
            
        } else if ([element.name isEqualToString:@"dc:rights"]) {
            opfMetadata.rights = [element stringValue];
            
        } else if ([element.name isEqualToString:@"dc:identifier"]) {
            opfMetadata.identifier = [[element attributeForName:@"opf:scheme"] stringValue];
            
        } else if ([element.name isEqualToString:@"dc:subject"]) {
            if (!opfMetadata.subjects) {
                opfMetadata.subjects = [NSMutableArray arrayWithCapacity:opfMetadataDoc.childCount];
            }
            
            NSString *subject = [element stringValue];
            if (subject) {
                [opfMetadata.subjects addObject:subject];
            }
            
        }
    }
    
    return opfMetadata;
}

#pragma mark - helper

- (NSError *)epubPareserErrorWithInfo:(NSString *)info
{
    return [NSError errorWithDomain:@"EpubPareserErrorDomain" code:-1 userInfo:@{@"errorInfo" : info}];
}

@end
