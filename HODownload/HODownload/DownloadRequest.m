//
//  DownloadRequest.m
//  asidown
//
//  Created by Chris on 15/1/20.
//  Copyright (c) 2015年 www.aoyolo.com 艾悠乐iOS学院. All rights reserved.
//

#import "DownloadRequest.h"
#import "DownloadManager.h"
#import "FileManager.h"

@implementation DownloadRequest

- (instancetype)initWithURL:(NSString *)newURL
{
    self = [super initWithURL:[NSURL URLWithString:newURL]];
    if (self) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *cachesDirectory = [paths objectAtIndex:0];
        NSString *strTitle = [newURL lastPathComponent];

        NSString *downloadPath = [cachesDirectory stringByAppendingPathComponent:strTitle];
        NSLog(@"%@",downloadPath);
        NSString *temp = [downloadPath stringByAppendingPathComponent:@"temp"];
        NSString *tempPath = [temp stringByAppendingPathComponent:strTitle];
        //判断temp文件夹是否存在
        [[FileManager sharedFileMgr] createDirctoryAtPath:temp];
        
        //文件最终存放路径
        NSString *lastDownloadPath = [cachesDirectory stringByAppendingPathComponent:@"DownLoad"];
        [[FileManager sharedFileMgr] createDirctoryAtPath:lastDownloadPath];

        NSString *downloadPathFile = [lastDownloadPath stringByAppendingPathComponent:strTitle];
        self.name = strTitle;
        self.delegate = self;
        [self setDownloadDestinationPath:downloadPathFile];
        [self setTemporaryFileDownloadPath:tempPath];
        self.allowResumeForFileDownloads = YES;//打开断点，是否要断点续传
        self.downloadProgressDelegate = self;
    }
    return self;
}

- (void)requestReceivedResponseHeaders:(NSDictionary *)newHeaders
{
    NSLog(@"headers:%@", newHeaders);
    NSString *contentLenStr = newHeaders[@"Content-Range"];
    NSRange ran = [contentLenStr rangeOfString:@"/"];
    NSString *contentLen = (contentLenStr != nil ? [contentLenStr substringFromIndex:ran.location+1] : newHeaders[@"Content-Length"]);
    FileModal *fd = [[DownloadManager sharedDownLoad]getFileModalWithTitle:self.name];
    fd.isfailed = NO;
    fd.contentLen = [contentLen longLongValue];
    
    //将文件的总长度信息存入plist文件中
    NSString *plistname = [[FileManager sharedFileMgr]getPlistPath];
    NSLog(@"%@",plistname);
    //判断temp文件夹是否存在
    [[FileManager sharedFileMgr]createFileAtPath:plistname];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithContentsOfFile:plistname];
    if (dic == nil) {
        dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    }
    NSMutableArray *fileInfo = [NSMutableArray arrayWithObjects:fd.fileUrl, contentLen, nil];
    [dic setObject:fileInfo forKey:self.name];
    [dic writeToFile:plistname atomically:YES];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"err:%@", request.error);
    FileModal *fd = [[DownloadManager sharedDownLoad]getFileModalWithTitle:self.name];
    fd.isfailed = YES;
    if ([DownloadManager sharedDownLoad].failedblock) {
        [DownloadManager sharedDownLoad].failedblock(fd, 1);
    }
}

- (void)setProgress:(float)newProgress
{
    if (newProgress == 1.0) {
        [[DownloadManager sharedDownLoad] setProgressToMax:self.name];
    }
    FileModal *fd = [[DownloadManager sharedDownLoad]getFileModalWithTitle:self.name];
    NSLog(@"name:%@, progress:%f", fd.fileName, newProgress);
    if ([DownloadManager sharedDownLoad].refreshProgress) {
        [DownloadManager sharedDownLoad].refreshProgress(fd, newProgress);
    }
}

@end
