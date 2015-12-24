//
//  RootViewController.m
//  NSThread-xiti
//
//  Created by Chris on 14/12/23.
//  Copyright (c) 2014年 www.aoyolo.com 艾悠乐iOS学院. All rights reserved.
//

#import "RootViewController.h"
#import "PPRevealSideViewController.h"
#import "DownloadingCell.h"
#import "DownloadItemCell.h"

#define urlOne @"http://dl_dir.qq.com/qqfile/qq/QQforMac/QQ_V2.1.0.dmg"
#define urlTwo @"http://dl_dir.qq.com/qqfile/qq/QQforMac/QQ_V1.4.1.dmg"
#define urlThree @"http://dlied6.qq.com/invc/xfspeed/mac/verupdate/QQMacMgr_2.0.0.dmg"
#define urlFourth @"http://dldir1.qq.com/invc/tt/QQBrowser_mac.dmg"
#define urlFifth @"http://dldir1.qq.com/qqfile/QQforMac/QQ_V4.0.1.dmg"
#define urlSixth @"http://dl_dir.qq.com/music/clntupate/QQMusicForMacV1.0.2.dmg"

@interface RootViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray* downContentDatas;
    NSArray* downURLArr;
}
@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    
    _theTable.delegate = self;
    _theTable.dataSource = self;
    _theTable.rowHeight = 60;
    
    self.navigationItem.title = @"首页";
    
    //如果没有这一句，状态栏会黑边
    [self.revealSideViewController resetOption:PPRevealSideOptionsiOS7StatusBarFading];
    
    UIBarButtonItem *leftBarBtn = [[UIBarButtonItem alloc]initWithTitle:@"左侧" style:UIBarButtonItemStylePlain target:self action:@selector(onLeftBarBtn:)];
    self.navigationItem.leftBarButtonItem = leftBarBtn;
    
    NSArray *onlineBooksUrl = @[urlOne, urlTwo, urlThree, urlFourth, urlFifth, urlSixth];
//    NSArray *onlineBooksUrl = [NSArray arrayWithObjects:
//                               @"http://dldir1.qq.com/qqfile/qq/QQ2013/QQ2013SP5/9050/QQ2013SP5.exe",
//                               @"http://dldir1.qq.com/qqfile/tm/TM2013Preview1.exe",
//                               @"http://dldir1.qq.com/invc/tt/QQBrowserSetup.exe",
//                               @"http://dldir1.qq.com/music/clntupate/QQMusic_Setup_100.exe",
//                               @"http://dl_dir.qq.com/invc/qqpinyin/QQPinyin_Setup_4.6.2028.400.exe",nil];
    
//    downContentDatas = [[NSMutableArray alloc]initWithArray:names];
    downURLArr = [[NSArray alloc]initWithArray:onlineBooksUrl];
    
}

- (void)onLeftBarBtn:(UIBarButtonItem *)barBtn
{
    [self.revealSideViewController pushOldViewControllerOnDirection:PPRevealSideDirectionLeft animated:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [downURLArr count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"contentCell";
    DownloadItemCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // Configure the cell...
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"DownloadItemCell" owner:self options:nil]lastObject];
        [cell.downloadBtn addTarget:self action:@selector(onClickedDown:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    //增加下面的cell配置，让在标志为“myCell"的单元格中显示list数据
    NSInteger row = [indexPath row];
    UILabel* lab = (UILabel*)[cell viewWithTag:10];
    lab.text = [[downURLArr objectAtIndex:row] lastPathComponent];
    [cell.downloadBtn setTag:row];
    return cell;
}

- (void)onClickedDown:(UIButton *)sender
{
    NSString* urlStr = [downURLArr objectAtIndex:sender.tag];
    [[DownloadManager sharedDownLoad]addRequestWithUrl:urlStr];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
