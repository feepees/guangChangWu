//
//  ViewController.m
//  guangChangWU
//
//  Created by Android on 2017/5/23.
//  Copyright © 2017年 cc.youdu. All rights reserved.
//

#import "ViewController.h"
#import "EditorContentViewController.h"
#import "SelectTpyeViewController.h"
#import "VIdeoListViewController.h"
#import "MJHttpTool.h"
#import <FMDB.h>
#import "XCFileManager.h"
#import "YJProgressHUD.h"
@interface ViewController ()<UIWebViewDelegate>
@property(nonatomic,strong)UIWebView *web;
@property(nonatomic,strong)FMDatabase *db;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIWebView *web=[[UIWebView alloc]initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height-20)];
    self.web=web;
    web.scalesPageToFit=YES;
    web.scrollView.bounces=NO;
    web.delegate=self;
    NSURL *url=[NSURL URLWithString:WebUrl];
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    [web loadRequest:request];
    [self.view addSubview:web];
}
-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
}
-(void)storgeDataWithInfo:(NSDictionary *)info andType:(NSString *)type{
    NSString *dbPath=[[XCFileManager documentsDir] stringByAppendingPathComponent:@"videoInfo.db"];
    FMDatabase *db=[FMDatabase databaseWithPath:dbPath];
    
    self.db=db;
    if ([db open]) {
        BOOL result=[db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_video (id integer PRIMARY KEY AUTOINCREMENT, name text NOT NULL,video_id text NOT NULL,video_img text NOT NULL, video text NOT NULL,unique_id text NOT NULL,isdownloaded text NOT NULL)"];
        if (result) {
            NSLog(@"success");
            FMResultSet *result=  [db executeQuery:@"SELECT * from t_video"];
            BOOL isDownloaded=NO;
            while([result next]) {
                if ([[result stringForColumn:@"unique_id"] isEqualToString:[NSString stringWithFormat:@"%@_%@",type,info[@"id"]]]) {
                    isDownloaded=YES;
                }
            }
            if (isDownloaded) {
                [YJProgressHUD showMessage:@"该视频已经下载" inView:self.view];
            }
            else{
                BOOL isInsert=[self.db executeUpdate:@"INSERT INTO t_video (name,video_id,video_img,video,unique_id,isdownloaded) VALUES (?,?,?,?,?,?);",info[@"name"],info[@"id"],info[@"video_img"],info[@"video"],[NSString stringWithFormat:@"%@_%@",type,info[@"id"]],@"0"];
                if (isInsert) {
                    NSLog(@"插入成功");
                }
            }
        }
    }

}
-(void)handlerWithVideoInfo:(NSDictionary *)info andType:(NSString *)type{
    [self storgeDataWithInfo:info andType:type];
    
    if (![XCFileManager isExistsAtPath:[[XCFileManager documentsDir] stringByAppendingPathComponent:@"video"]]) {
        [XCFileManager createDirectoryAtPath:[[XCFileManager documentsDir] stringByAppendingPathComponent:@"video"]];
    }
    NSLog(@"path%@",[XCFileManager documentsDir]);
    NSString *videoPath=[[XCFileManager documentsDir] stringByAppendingPathComponent:[NSString stringWithFormat:@"video/%@_%@.mp4",type,info[@"id"]]];
    [MJHttpTool fileDownload:
     [NSString stringWithFormat:@"%@%@",LocalHost,info[@"video"]]
                progress:^(NSProgress *downloadProgress) {
                        //NSLog(@"progress%@",downloadProgress);
                        }
                taratPath:
                        videoPath
                completionHandler:^(NSURL *filePath) {
                    ;
                    NSLog(@"%@",[filePath.lastPathComponent componentsSeparatedByString:@"."][0]);
                    [self.db executeUpdate:@"update t_video set isdownloaded = ? where unique_id = ?",@"1",[filePath.lastPathComponent componentsSeparatedByString:@"."][0]];

                    
    }];
}

#pragma mark ----------------UIWebViewDelegate----------------------------
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
     if ([request.URL.scheme isEqualToString:@"show"]) {
         NSArray *a=[request.URL.query componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"=&"]];
         NSLog(@"show userid=%@",a);
         SelectTpyeViewController *selectC=[[SelectTpyeViewController alloc]init];
        selectC.user_id=a[1];
         selectC.special_id=a[3];
    
        [self presentViewController:selectC animated:YES completion:nil];
        return NO;
    }
    if ([request.URL.scheme isEqualToString:@"xiazai"]) {
       
        NSArray *a=[request.URL.query componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"=&"]];
        NSLog(@"show userid=%@",a);
        NSMutableDictionary *parameter=[NSMutableDictionary dictionary];
        parameter[@"video_id"]=a[1];
        parameter[@"video_type"]=a[3];
       [MJHttpTool Post:VideoInfo parameters:parameter success:^(id responseObject) {
           NSLog(@"responseObject%@",responseObject);
           
           [self handlerWithVideoInfo:responseObject[@"data"] andType:a[3]];
           
       } failure:^(NSError *error) {
           NSLog(@"error%@",error);
       }];
        return NO;

    }
    if ([request.URL.scheme isEqualToString:@"list"]) {
        NSLog(@"进入我的下载");
        VIdeoListViewController *videoC=[[VIdeoListViewController alloc]init];
        videoC.title=@"我的下载";
        UINavigationController *navC=[[UINavigationController alloc]initWithRootViewController:videoC];
        [self presentViewController:navC animated:YES completion:nil];
        return NO;
    }
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView{

}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{

}

@end
