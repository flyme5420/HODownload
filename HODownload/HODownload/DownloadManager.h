//
//  DownloadManager.h
//  asidown
//
//  Created by Chris on 15/1/21.
//  Copyright (c) 2015年 www.aoyolo.com 艾悠乐iOS学院. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASINetworkQueue.h"
#import "DownloadRequest.h"
#import "FileModal.h"

typedef void (^REFRESH)(FileModal *fd, float progress);
typedef void (^FAILBLOCK)(FileModal *fd, float progress);

@interface DownloadManager : NSObject
{
    ASINetworkQueue *_queue;
}

@property (strong, nonatomic) NSMutableArray *downLoadUrlList;
@property (nonatomic, copy) REFRESH refreshProgress;
@property (nonatomic, copy) FAILBLOCK failedblock;

+ (DownloadManager *)sharedDownLoad;
- (void)loadDownloadFiles;
- (void)addRequestWithUrl:(NSString *)url;
- (FileModal *)getFileModalWithTitle:(NSString *)title;
- (DownloadRequest *)getRequestWithTitle:(NSString *)title;
- (void)setProgressToMax:(NSString *)title;
- (void)removeRequestAtIndex:(NSInteger)index;
- (void)removeFileWithFileName:(NSString *)fileName;
- (void)suspendOrStart:(NSString *)fileName;
- (NSInteger)getIndexByName:(NSString *)fileName;

@end
