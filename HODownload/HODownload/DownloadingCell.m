//
//  DownloadingCell.m
//  asidown
//
//  Created by Chris on 15/1/21.
//  Copyright (c) 2015年 www.aoyolo.com 艾悠乐iOS学院. All rights reserved.
//

#import "DownloadingCell.h"
#import "FileManager.h"

@implementation DownloadingCell

- (void)awakeFromNib {
    // Initialization code
    [_progressButton initButton];
}

- (IBAction)onClickedButton:(UIButton *)sender
{
    [[DownloadManager sharedDownLoad] suspendOrStart:self.name.text];
    [sender setSelected:!sender.isSelected];
}

- (void)setDeleteAction
{
    [_progressButton removeTarget:self action:@selector(onClickedButton:) forControlEvents:UIControlEventTouchUpInside];
    [_progressButton addTarget:self action:@selector(onClickedDelete:) forControlEvents:UIControlEventTouchUpInside];
    [_progressButton setBackgroundImage:[UIImage imageNamed:@"file_delete"] forState:UIControlStateNormal];
}

- (void)onClickedDelete:(UIButton *)btn
{
    //获取DownViewController
    id ctl = [self.superview.superview nextResponder];
    UIAlertController *alertCtl = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定删除本地文件" preferredStyle:UIAlertControllerStyleAlert];
    [alertCtl addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    
    [alertCtl addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSInteger index = [[DownloadManager sharedDownLoad] getIndexByName:self.fd.fileName];
        NSIndexPath *path = [NSIndexPath indexPathForRow:index inSection:0];
        
        [[DownloadManager sharedDownLoad] removeFileWithFileName:self.fd.fileName];
        [(UITableView *)self.superview.superview deleteRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationAutomatic];
    }]];
    
    [ctl presentViewController:alertCtl animated:YES completion:nil];
}

- (void)setCellProgress:(float)progress
{
    self.progressView.progress = progress;
    self.progressLabel.text = [self MB:progress];
    [self.progressButton setProgress:progress];
}

//出错暂停当前下载任务
- (void)setFailedAction
{
    //当前下载大小
    unsigned long long fileContentSize = [[FileManager sharedFileMgr]getFileContentSize:_fd.fileName];
    //文件总大小，读取plist
    unsigned long long fileAllSize = [[FileManager sharedFileMgr]getFileTotalSize:_fd.fileName];
    if (fileAllSize == 0||fileContentSize == 0) {
        [self setCellProgress:0];
    }else
    {
        NSLog(@"filesize:%llu, fileAllSize:%llu", fileContentSize, fileAllSize);
        NSLog(@"progress:%f", fileContentSize*1.0 / fileAllSize);
        [self setCellProgress:fileContentSize*1.0 / fileAllSize];
    }
    [_progressButton setSelected:YES];
    [self setStatusLabel:NO];
}

- (void)setStatusLabel:(BOOL)flag
{
    if (_failedLabel.hidden != flag) {
        _failedLabel.hidden = flag;
    }
}

- (NSString *)MB:(float)progress
{
    unsigned long long fileTotalSize = [[FileManager sharedFileMgr]getFileTotalSize:_fd.fileName];
    NSString *hasDownSizeMb = [NSString stringWithFormat:@"%5.2f", fileTotalSize*progress/1024.0/1024.0];
    NSString *fileSizeMb = [NSString stringWithFormat:@"%5.2f", fileTotalSize/1024.0/1024.0];
    NSString *showText = [NSString stringWithFormat:@"%@M/%@M",hasDownSizeMb,fileSizeMb];
    return showText;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
