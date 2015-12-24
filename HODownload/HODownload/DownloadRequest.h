//
//  DownloadRequest.h
//  asidown
//
//  Created by Chris on 15/1/20.
//  Copyright (c) 2015年 www.aoyolo.com 艾悠乐iOS学院. All rights reserved.
//

#import "ASIHTTPRequest.h"

@interface DownloadRequest : ASIHTTPRequest<ASIHTTPRequestDelegate, ASIProgressDelegate>

- (instancetype)initWithURL:(NSString *)newURL;

@end
