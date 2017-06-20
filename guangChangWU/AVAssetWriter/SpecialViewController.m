//
//  SpecialViewController.m
//  guangChangWU
//
//  Created by Android on 2017/6/8.
//  Copyright © 2017年 cc.youdu. All rights reserved.
//


#import "SpecialViewController.h"
#import "MJHttpTool.h"
#import <ReactiveObjC.h>

@interface SpecialViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataSoure;
@property(nonatomic,strong)RACCommand *command;
@end

@implementation SpecialViewController
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellId"];
        _tableView.delegate=self;
        _tableView.dataSource=self;
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
    //[self getData];
    [self getDataCommand];
    [[self.command execute:nil] subscribeNext:^(id  _Nullable x) {
        NSLog(@"shuju%@",x);
        self.dataSoure=x;
        [self.tableView reloadData];
    }];
}
-(void)dealloc{

    NSLog(@"我被销毁了%@",self);
}
-(void)getDataCommand{
self.command=[[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
   return  [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [MJHttpTool GET:Special parameters:nil success:^(id responseObject) {
            NSLog(@" responseObject%@",responseObject[@"data"]);
            [subscriber sendNext:responseObject[@"data"]];
            [subscriber sendCompleted];
        } failure:^(NSError *error) {
            NSLog(@"error%@",error);
        }];
       return nil;
   }];
}];
}
-(void)getData{
    [MJHttpTool GET:Special parameters:nil success:^(id responseObject) {
        NSLog(@" responseObject%@",responseObject[@"data"]);
        self.dataSoure=responseObject[@"data"];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"error%@",error);
    }];
}
#pragma mark ---------------UITableViewDelegate---------------
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSoure.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId=@"cellId";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
    }
    cell.textLabel.text=self.dataSoure[indexPath.item][@"title"];
    cell.detailTextLabel.text=self.dataSoure[indexPath.item][@"note"];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.selectSpecial(self.dataSoure[indexPath.item][@"id"],self.dataSoure[indexPath.item][@"title"]);
    [self.navigationController popViewControllerAnimated:YES];
}
@end
