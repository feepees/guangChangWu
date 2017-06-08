//
//  EditorContentViewController.m
//  guangChangWU
//
//  Created by Android on 2017/5/31.
//  Copyright © 2017年 cc.youdu. All rights reserved.
//



#import "EditorContentViewController.h"
#import "FMWriteVideoController.h"
#import "MJHttpTool.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import "SpecialViewController.h"
#import "YJProgressHUD.h"


@interface EditorContentViewController ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *titileTextField;
@property (weak, nonatomic) IBOutlet UILabel *placeHolder;
@property (weak, nonatomic) IBOutlet UIButton *imageBtn;
@property(nonatomic,strong)NSString *special;
@property (weak, nonatomic) IBOutlet UILabel *specialLable;

@end

@implementation EditorContentViewController

- (IBAction)subjectAction:(id)sender {

    SpecialViewController *specialC=[[SpecialViewController alloc]init];
    specialC.selectSpecial=^(NSString *special,NSString *title){
        self.special=special;
        self.specialLable.text=[NSString stringWithFormat:@"#%@",title];
    };
    [self.navigationController pushViewController:specialC animated:YES];
}

- (IBAction)photoAction:(id)sender {
    
}
- (IBAction)submitAction:(id)sender {
    if (self.titileTextField.text) {
        [YJProgressHUD showMessage:@"请编辑内容" inView:self.view];
        return;
    }
    NSMutableDictionary *parameter=[NSMutableDictionary dictionary];
    parameter[@"content"]=self.titileTextField.text;
    parameter[@"user_id"]=self.user_id;
    if(self.special){
        parameter[@"special_id"]=self.special;}
    else{
        parameter[@"special_id"]=@"0";
    }
    parameter[@"fj_type"]=self.type;
    NSData *data;
    if (self.image) {
        data=UIImageJPEGRepresentation(self.image, 0.5);
    }
    NSLog(@"Url%@参数%@文件路径%@",Show,parameter,self.fileUrl);
    [YJProgressHUD showProgress:@"正在上传" inView:self.view];
    [MJHttpTool PostFile:Show parameters:parameter fileUrl:self.fileUrl data:data success:^(id responseObject) {
        NSLog(@"responseObject%@",responseObject);
        [YJProgressHUD hide];
        if (responseObject[@"code"]) {
            [YJProgressHUD showSuccess:@"发布成功" inview:self.view];
            NSLog(@"发布成功");
        }
        else{
             [YJProgressHUD showMessage:@"发布失败" inView:self.view];
            NSLog(@"发布失败");
        }
    } failure:^(NSError *error) {
         [YJProgressHUD hide];
        [YJProgressHUD showMessage:@"网络异常" inView:self.view];
        NSLog(@"error%@",error);
    }];
}
- (IBAction)cancelAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)dealloc{
    NSLog(@"%@我被销毁了",self);
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.titileTextField.delegate=self;
    [self setNavigationBar];
    self.view.backgroundColor=[UIColor colorWithRed:240/250.0 green:240/250.0 blue:240/250.0 alpha:1];
    //RAC(self.placeHolder,hidden)=self.titileTextField.rac_textSignal;
    if (self.image) {
        [self.imageBtn setBackgroundImage:self.image forState:UIControlStateNormal];
    }
}

-(void)setNavigationBar{
    self.navigationController.navigationBar.barTintColor=[UIColor colorWithRed:30/255.0 green:140/255.0 blue:228/255.0 alpha:1];
    UILabel *titleLable=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    titleLable.textColor=[UIColor whiteColor];
    titleLable.font=[UIFont systemFontOfSize:21];
    titleLable.textAlignment=NSTextAlignmentCenter;
    titleLable.text=@"正文详情";
    self.navigationItem.titleView=titleLable;
    UIButton *rightBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    [rightBtn setTitle:@"发布" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [rightBtn addTarget:self action:@selector(submitAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    
    UIButton *leftBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    [leftBtn setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:leftBtn];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.titileTextField endEditing:YES];
}
//i374   310   
#pragma mark ----------------------UITextViewDelegate--------
-(void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length>0) {
        self.placeHolder.hidden=YES;
    }
    else{
    self.placeHolder.hidden=NO;
    }
}


@end
