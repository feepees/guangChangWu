//
//  DownloadedViewController.m
//  guangChangWU
//
//  Created by Android on 2017/6/15.
//  Copyright © 2017年 cc.youdu. All rights reserved.
//

#import "DownloadedViewController.h"
#import <FMDB.h>
#import "XCFileManager.h"
#import "VideoModel.h"
#import "DownloadVideoTableViewCell.h"
#import "UIView+FPErrorPage.h"
@interface DownloadedViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)NSMutableArray *dataSoure;
@property(nonatomic,strong)UITableView *tableView;
@end

@implementation DownloadedViewController
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        [_tableView registerNib:[UINib nibWithNibName:@"DownloadVideoTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cellId"];
        
    }
    return _tableView;
}
-(NSMutableArray *)dataSoure{
    if (!_dataSoure) {
        _dataSoure = [[NSMutableArray alloc]init];
        
    }
    return _dataSoure;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    [self queryVideoInfo];
    // Do any additional setup after loading the view.
}
-(void)queryVideoInfo{
    NSString *dbPath=[[XCFileManager documentsDir] stringByAppendingPathComponent:@"videoInfo.db"];
    FMDatabase *db=[FMDatabase databaseWithPath:dbPath];
    if ([db open]) {
        FMResultSet *result=  [db executeQuery:@"SELECT * from t_video"];
        while([result next]) {
            if ([[result stringForColumn:@"isdownloaded"] isEqualToString:@"1"]) {
                VideoModel *model=[[VideoModel alloc]init];
                model.name=[result stringForColumn:@"name"];
                model.video_id=[result stringForColumn:@"video_id"];
                model.video=[result stringForColumn:@"video"];
                model.video_img=[result stringForColumn:@"video_img"];
                model.unique_id=[result stringForColumn:@"unique_id"];
                model.isDownloaded=[result stringForColumn:@"isdownload"];
                [self.dataSoure addObject:model];
            }
        }
        if (self.dataSoure.count>0) {
            [self.view hideBlankPageView];
            [self.tableView reloadData];
        }
        else
        {
            [self.view showBlankPageView];
        }
    }
    
}
#pragma mark -----------------------------UITableViewDelegate-------------------------
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSoure.count;
}
//
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId=@"cellId";
    DownloadVideoTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    cell.model=self.dataSoure[indexPath.item];
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}
@end
