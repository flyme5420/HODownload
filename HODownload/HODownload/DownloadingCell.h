//
//  DownloadingCell.h
//  asidown
//
//  Created by Chris on 15/1/21.
//  Copyright (c) 2015年 www.aoyolo.com 艾悠乐iOS学院. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DownloadingCell.h"
#import "DownloadRequest.h"
#import "DownloadManager.h"
#import "CircularProgressButton.h"
#import "FileModal.h"

@interface DownloadingCell : UITableViewCell

@property (retain, nonatomic) FileModal *fd;
@property (retain, nonatomic) IBOutlet UILabel *name;
@property (retain, nonatomic) IBOutlet UIProgressView *progressView;
@property (retain, nonatomic) IBOutlet UILabel *progressLabel;
@property (strong, nonatomic) IBOutlet UILabel *failedLabel;
@property (retain, nonatomic) IBOutlet CircularProgressButton *progressButton;
- (NSString *)MB:(float)progress;
- (void)setCellProgress:(float)progress;
- (void)setDeleteAction;
- (void)setFailedAction;
- (void)setStatusLabel:(BOOL)flag;

@end
