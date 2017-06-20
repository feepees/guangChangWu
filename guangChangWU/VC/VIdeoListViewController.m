//
//  VIdeoListViewController.m
//  guangChangWU
//
//  Created by Android on 2017/6/15.
//  Copyright © 2017年 cc.youdu. All rights reserved.
//

#import "VIdeoListViewController.h"
#import "DownloadedViewController.h"
#import "DownloadingViewController.h"
#import "MYAlertVIew.h"
#import "XCFileManager.h"
#import <FMDB.h>
@interface VIdeoListViewController ()
@property(nonatomic,strong)NSArray *titleData;

@end

@implementation VIdeoListViewController

-(NSArray *)titleData{
    if (!_titleData) {
        _titleData = [[NSArray alloc]initWithObjects:@"正在下载",@"下载完成",nil];
        
    }
    return _titleData;
}
//
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title=@"我的下载";
        self.titleSizeNormal = 15;
        self.titleSizeSelected = 15;
        self.menuViewStyle = WMMenuViewStyleLine;
        self.menuItemWidth = [UIScreen mainScreen].bounds.size.width / self.titleData.count;
        self.menuHeight = 50;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBar];
}

-(void)setNavigationBar{
    self.navigationController.navigationBar.barTintColor=[UIColor colorWithRed:30/255.0 green:140/255.0 blue:228/255.0 alpha:1];
    UILabel *titleLable=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    titleLable.textColor=[UIColor whiteColor];
    titleLable.font=[UIFont systemFontOfSize:21];
    titleLable.textAlignment=NSTextAlignmentCenter;
    titleLable.text=@"我的下载";
    self.navigationItem.titleView=titleLable;
    UIButton *rightBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    [rightBtn setImage:[UIImage imageNamed:@"shanchu"] forState:UIControlStateNormal];
    
    [rightBtn addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    
    UIButton *leftBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    [leftBtn setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:leftBtn];
}
-(void)cancelAction:(UIButton *)button{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)deleteAction:(UIButton *)button{
    MYAlertVIew *alert=[MYAlertVIew showToView:self.view withTitle:@"确定要删除全部列表么，长按视频可删除单个"];
    alert.comfirmActiom=^{
        NSLog(@"清楚列表");
        NSString *dbPath=[[XCFileManager documentsDir] stringByAppendingPathComponent:@"videoInfo.db"];
        FMDatabase *db=[FMDatabase databaseWithPath:dbPath];
        if ([db open]) {

            [db executeUpdate:@"delete from t_video; "];
        }
    };
    alert.cancelAction=^{
    
    };
}
#pragma mark ------WMPageViewcontroller----------------
-(NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController{
    return self.titleData.count;
}

-(UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index{
    switch (index) {
        case 0:{
            
            DownloadingViewController   *vcClass = [[DownloadingViewController alloc] init];
            vcClass.title = @"正在下载";
            
            return vcClass;
        }
            
            break;
        case 1:{
            
            DownloadedViewController *vcClass = [DownloadedViewController new];
            vcClass.title = @"下载完成";
            return vcClass;
            
        }
            break;
            
            
        default:
            return nil;
            break;
    }
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    
    return self.titleData[index];
}
@end
