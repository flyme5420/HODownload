//
//  FileManager.m
//  asidown
//
//  Created by Chris on 15/1/28.
//  Copyright (c) 2015年 www.aoyolo.com 艾悠乐iOS学院. All rights reserved.
//

#import "FileManager.h"

static FileManager *fileManage = nil;

@implementation FileManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        _fm = [NSFileManager defaultManager];
    }
    return self;
}

+ (FileManager *)sharedFileMgr
{
    if (fileManage == nil) {
        fileManage = [[FileManager alloc]init];
    }
    return fileManage;
}

- (BOOL)fileExist:(NSString *)filename
{
    NSString *filePath = [self getFilePath:filename];
    return [_fm fileExistsAtPath:filePath];
}

- (NSString *)getFilePath:(NSString *)filename
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDirectory = [paths objectAtIndex:0];
    NSString *lastDownloadPath = [cachesDirectory stringByAppendingPathComponent:@"DownLoad"];
    NSString *filePath = [lastDownloadPath stringByAppendingPathComponent:filename];
    return filePath;
}

- (unsigned long long)getFileContentSize:(NSString *)filename
{
    NSString *filePath = [self getTempFilePath:filename];
    NSDictionary *dic = [_fm attributesOfItemAtPath:filePath error:nil];
    unsigned long long filesize = [dic fileSize];
    return filesize;
}

- (unsigned long long)getFileTotalSize:(NSString *)filename
{
    NSMutableDictionary *fileInfo = [NSMutableDictionary dictionaryWithContentsOfFile:[self getPlistPath]];
    unsigned long long fileAllSize = [fileInfo[filename][1] longLongValue];
    return fileAllSize;
}

- (void)removeFileByName:(NSString *)filename
{
    NSString *filePath = [self getFilePath:filename];
    NSError *err = nil;
    if (![_fm removeItemAtPath:filePath error:&err])
    {
        NSLog(@"removeItem failed, err:%@", err);
    }
}

- (void)removePlistInfoWithFileName:(NSString *)filename
{
    NSString *plistFile = [self getPlistPath];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithContentsOfFile:plistFile];
    [dic removeObjectForKey:filename];
    [dic writeToFile:plistFile atomically:YES];
}

- (NSString *)getPlistPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDirectory = [paths objectAtIndex:0];
    
    NSString *plistName = @"file.plist";
    NSString *plistPath = [docDirectory stringByAppendingPathComponent:plistName];
    return plistPath;
}

- (NSString *)getTempFilePath:(NSString *)filename
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDirectory = [paths objectAtIndex:0];
    
    NSString *tempfilepath = [NSString stringWithFormat:@"%@/temp/%@", filename, filename];
    NSString *tempFile = [cachesDirectory stringByAppendingPathComponent:tempfilepath];
    return tempFile;
}

- (void)createFileAtPath:(NSString *)filepath
{
    if (![_fm fileExistsAtPath:filepath]) {
        [_fm createFileAtPath:filepath contents:nil attributes:nil];
    }
}

- (void)createDirctoryAtPath:(NSString *)filepath
{
    BOOL fileExists = [_fm fileExistsAtPath:filepath];
    if (!fileExists)
    {//如果不存在则创建,因为下载时,不会自动创建文件夹
        [_fm createDirectoryAtPath:filepath
               withIntermediateDirectories:YES
                                attributes:nil
                                     error:nil];
    }
}


@end
