//
//  DownViewController.m
//  asidown
//
//  Created by Chris on 15/1/20.
//  Copyright (c) 2015年 www.aoyolo.com 艾悠乐iOS学院. All rights reserved.
//

#import "DownViewController.h"
#import "DownloadManager.h"
#import "DownloadRequest.h"
#import "DownloadingCell.h"
#import "FileModal.h"

@interface DownViewController ()

@end

@implementation DownViewController

- (void)dealloc
{
    NSLog(@"%s", __func__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"DownloadingCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    self.tableView.rowHeight = 110;
    
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(onLeftBtn)];
    self.navigationItem.leftBarButtonItem = leftBtn;
    
    [DownloadManager sharedDownLoad].refreshProgress = ^(FileModal *fd, float progress)
    {
        for (DownloadingCell *cell in self.tableView.visibleCells) {
            if ([cell.name.text isEqualToString:fd.fileName]) {
                [cell setCellProgress:progress];
                [cell setStatusLabel:YES];
                if (progress == 1.0) {
                    [cell setDeleteAction];
                }
                break;
            }
        }
    };
    
    [DownloadManager sharedDownLoad].failedblock = ^(FileModal *fd, float progress)
    {
        for (DownloadingCell *cell in self.tableView.visibleCells) {
            if ([cell.name.text isEqualToString:fd.fileName]) {
                [cell setFailedAction];
                break;
            }
        }
    };
    
    [[DownloadManager sharedDownLoad] loadDownloadFiles];
    
}

- (void)onLeftBtn
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//- (void)onDownloadFinished:(NSNotification *)notifer
//{
//
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    NSUInteger count = [DownloadManager sharedDownLoad].downLoadUrlList.count;
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DownloadingCell *cell = (DownloadingCell *)[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    FileModal *fd = [DownloadManager sharedDownLoad].downLoadUrlList[indexPath.row];
    cell.name.text = [fd.fileUrl lastPathComponent];
    cell.fd = fd;
    if (fd.isExist) {
        [cell setCellProgress:1.0];
        [cell setDeleteAction];
    }
    return cell;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [[DownloadManager sharedDownLoad]removeRequestAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

@end
