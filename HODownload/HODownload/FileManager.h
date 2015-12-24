//
//  FileManager.h
//  asidown
//
//  Created by Chris on 15/1/28.
//  Copyright (c) 2015年 www.aoyolo.com 艾悠乐iOS学院. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileManager : NSObject
{
    NSFileManager *_fm;
}

+ (FileManager *)sharedFileMgr;
- (BOOL)fileExist:(NSString *)filename;
- (NSString *)getTempFilePath:(NSString *)filename;
- (NSString *)getFilePath:(NSString *)filename;
- (unsigned long long)getFileContentSize:(NSString *)filename;
- (unsigned long long)getFileTotalSize:(NSString *)filename;
- (void)removeFileByName:(NSString *)filename;
- (void)removePlistInfoWithFileName:(NSString *)filename;
- (NSString *)getPlistPath;
- (void)createFileAtPath:(NSString *)filepath;
- (void)createDirctoryAtPath:(NSString *)filepath;

@end
