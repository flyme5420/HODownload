//
//  DownloadManager.m
//  asidown
//
//  Created by Chris on 15/1/21.
//  Copyright (c) 2015年 www.aoyolo.com 艾悠乐iOS学院. All rights reserved.
//

#import "DownloadManager.h"
#import "FileManager.h"

static DownloadManager *downloadManage = nil;

@implementation DownloadManager

- (id)init
{
    if (self = [super init]) {
        _downLoadUrlList = [[NSMutableArray alloc]initWithCapacity:0];
        _queue = [[ASINetworkQueue alloc] init];
        _queue.delegate = self;
        [_queue reset];
        _queue.showAccurateProgress = YES;
        [_queue go];
    }
    return self;
}

+ (DownloadManager *)sharedDownLoad
{
    if (downloadManage == nil) {
        downloadManage = [[DownloadManager alloc]init];
    }
    return downloadManage;
}

- (void)loadDownloadFiles
{
    //从plist文件中读取文件的url并开始下载
    NSString *plistPath = [[FileManager sharedFileMgr]getPlistPath];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
    NSArray *fileArray = [dic allKeys];
    for (NSString *filename in fileArray) {
        NSString *fileurl = dic[filename][0];  //取得文件的url
        [self addRequestWithUrl:fileurl];
    }
}

- (void)addRequestWithUrl:(NSString *)url
{
    DownloadRequest *request = [[DownloadRequest alloc]initWithURL:url];
    NSString *urlStr = [request.url absoluteString];
    NSString *fileName = [urlStr lastPathComponent];
    FileModal *fd = [[FileModal alloc]init];
    fd.fileName = fileName;
    fd.fileUrl = urlStr;
    fd.isExist = NO;
    fd.isfailed = NO;
    if ([[FileManager sharedFileMgr]fileExist:fileName])
    {
        NSLog(@"the file %@ is exist", fileName);
        fd.contentLen = [[FileManager sharedFileMgr]getFileContentSize:fileName];
        fd.isExist = YES;
    }else
    {
        //文件不存在就从plist文件中获取文件总大小
        NSString *plistPath = [[FileManager sharedFileMgr]getPlistPath];
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
        
        //获取已经下载的文件大小
        fd.contentLen = [[FileManager sharedFileMgr]getFileContentSize:fileName];
        
        if (dic[fileName] == nil) {
            NSMutableArray *fileInfo = [NSMutableArray arrayWithObjects:fd.fileUrl, [NSString stringWithFormat:@"%lld",fd.contentLen], nil];
            [dic setObject:fileInfo forKey:fileName];
            [dic writeToFile:plistPath atomically:YES];
        }
        
        if ([self getRequestWithTitle:fileName]) {
            NSLog(@"the file %@ is downloading", fileName);
            return;
        }else
        {
            [_queue addOperation:request];
        }
    }
    if (![self getFileModalWithTitle:fileName]) {
        [_downLoadUrlList addObject:fd];
    }
}

//删除请求
- (void)removeRequestAtIndex:(NSInteger)index
{
    FileModal *fd = _downLoadUrlList[index];
    DownloadRequest *request = [self getRequestWithTitle:[fd.fileUrl lastPathComponent]];
    if (request) {      //如果请求不存在，说明文件在本地存在
        [request clearDelegatesAndCancel];
    }
    [self removeFileWithFileName:fd.fileName];
}

//删除已下载文件
- (void)removeFileWithFileName:(NSString *)fileName
{
    [[FileManager sharedFileMgr]removeFileByName:fileName];
    [[FileManager sharedFileMgr]removePlistInfoWithFileName:fileName];
    [_downLoadUrlList removeObjectAtIndex:[self getIndexByName:fileName]];
}

- (NSInteger)getIndexByName:(NSString *)fileName
{
    for (int i = 0; i < _downLoadUrlList.count; i++) {
        FileModal *fd = _downLoadUrlList[i];
        if ([fd.fileName isEqualToString:fileName]) {
            return i;
        }
    }
    return -1;
}

//暂停或开始下载
- (void)suspendOrStart:(NSString *)fileName
{
    DownloadRequest *request = [self getRequestWithTitle:fileName];
    if (request.isExecuting)
    {
        [request clearDelegatesAndCancel];
    }else
    {
        FileModal *fd = [self getFileModalWithTitle:fileName];
        [self addRequestWithUrl:fd.fileUrl];
    }
}

- (FileModal *)getFileModalWithTitle:(NSString *)title
{
    for (FileModal *fd in _downLoadUrlList) {
        NSString *strTitle = [fd.fileUrl lastPathComponent];
        if ([strTitle isEqualToString:title]) {
            return fd;
        }
    }
    return nil;
}

- (void)setProgressToMax:(NSString *)title
{
    for (FileModal *fd in _downLoadUrlList) {
        NSString *strTitle = [fd.fileUrl lastPathComponent];
        if ([strTitle isEqualToString:title]) {
            fd.isExist = YES;
            NSLog(@"%@ has finished", title);
            break;
        }
    }
}

- (DownloadRequest *)getRequestWithTitle:(NSString *)title
{
    for (DownloadRequest *request in _queue.operations) {
        if ([request.name isEqualToString:title]) {
            return request;
        }
    }
    return nil;
}

@end
