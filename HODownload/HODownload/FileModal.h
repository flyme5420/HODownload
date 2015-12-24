//
//  FileModal.h
//  asidown
//
//  Created by Chris on 15/1/22.
//  Copyright (c) 2015年 www.aoyolo.com 艾悠乐iOS学院. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileModal : NSObject

@property (nonatomic, strong) NSString *fileName;
@property (nonatomic, strong) NSString *fileUrl;
@property (nonatomic, assign) BOOL isExist;
@property (nonatomic, assign) BOOL isfailed;
@property (nonatomic, assign) long long int contentLen;

@end
