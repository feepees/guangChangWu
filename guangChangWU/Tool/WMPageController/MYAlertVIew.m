//
//  MYAlertVIew.m
//  maYiChaoFeng
//
//  Created by Android on 2017/3/15.
//  Copyright © 2017年 cc.youdu. All rights reserved.
//

#import "MYAlertVIew.h"
@interface MYAlertVIew()

@property(nonatomic,copy)NSString *titletext;
@property(nonatomic,copy)void(^photoBlock)();
@property(nonatomic,copy)void(^ablumBlock)();
@end
@implementation MYAlertVIew
//创建提示框
+(instancetype)showToView:(UIView *)view withTitle:(NSString *)title{
    MYAlertVIew *alert=[[self alloc]initWithView:view withTitle:title];
    
    [view addSubview:alert];
    
    return alert;

}
//创建获取头像框
+(instancetype)showPhotoAlertToView:(UIView *)view withTakePhoto:(void(^)())takePhoto andAlbum:(void(^)())album{
    MYAlertVIew  *alert=[[self alloc]initWithView:(UIView *)view withTakePhoto:takePhoto andAlbum:album];
    
    [view addSubview:alert];
    
    return alert;
}
-(instancetype)initWithView:(UIView *)view withTakePhoto:(void(^)())takePhoto andAlbum:(void(^)())album{
    if ((self = [super initWithFrame:view.bounds])) {
        [self commonInit];
        [self addPhotoContent];
    }
    self.photoBlock=takePhoto;
    self.ablumBlock=album;
    return self;
}
-(void)addPhotoContent{
    UIView *content=[[UIView alloc]initWithFrame:CGRectMake(30, (self.frame.size.height-100)/2, self.frame.size.width-60, 100)];
    content.backgroundColor=[UIColor whiteColor];
    content.userInteractionEnabled=YES;
    [self addSubview:content];
    UIImageView *photoImageView=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 20, 20)];
    photoImageView.image=[UIImage imageNamed:@"grzl_pz_icon"];
    [content addSubview:photoImageView];
    UILabel *photoLable=[[UILabel alloc]initWithFrame:CGRectMake(50, 10, 100, 20)];
    photoLable.text=@"拍照";
    [content addSubview:photoLable];
    UIButton *photoBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, content.frame.size.width, 50)];
    photoBtn.backgroundColor=[UIColor clearColor];
    [photoBtn addTarget:self action:@selector(photoAction:) forControlEvents:UIControlEventTouchUpInside];
    [content addSubview:photoBtn];
    
    UIImageView *ablumImageView=[[UIImageView alloc]initWithFrame:CGRectMake(10, 60, 20, 20)];
    ablumImageView.image=[UIImage imageNamed:@"grzl_xc_icon"];
    [content addSubview:ablumImageView];
    UILabel *ablumLable=[[UILabel alloc]initWithFrame:CGRectMake(50, 60, 120, 20)];
    ablumLable.text=@"从相册中选择";
    [content addSubview:ablumLable];
    UIButton *ablumBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 50, content.frame.size.width, 50)];
    ablumBtn.backgroundColor=[UIColor clearColor];
    [ablumBtn addTarget:self action:@selector(ablumAction:) forControlEvents:UIControlEventTouchUpInside];
    [content addSubview:ablumBtn];
    
    
}
-(void)photoAction:(UIButton *)sender{
    self.photoBlock();
}
-(void)ablumAction:(UIButton *)sender{
    self.ablumBlock();
}

-(instancetype)initWithView:(UIView *)view withTitle:(NSString *)title{
    if ((self = [super initWithFrame:view.bounds])) {
        self.titletext=title;
        [self commonInit];
        [self addContentView];

    }
    return self;
}
-(void)commonInit{
    self.backgroundColor=[UIColor colorWithRed:155/255.0 green:155/255.0 blue:155/255.0 alpha:0.7];
    [self addAction];
    
    
}
-(void)addAction{
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]init];
    [tap addTarget:self action:@selector(tapAction)];
    self.userInteractionEnabled=YES;
    [self addGestureRecognizer:tap];

}
-(void)tapAction{
    
    [self removeFromSuperview];
}
-(void)addContentView{
    UIView *content=[[UIView alloc]initWithFrame:CGRectMake(30, (self.frame.size.height-100)/2, self.frame.size.width-60, 100)];
    content.backgroundColor=[UIColor whiteColor];
    content.userInteractionEnabled=YES;
    [self addSubview:content];
    
    UILabel *titleLable=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, 200, 30)];
    titleLable.text=self.titletext;
    titleLable.textColor=[UIColor blackColor];
    [content addSubview:titleLable];
    
    UIButton *comfirmBtn=[[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width-110, 60, 40, 30)];
    [comfirmBtn addTarget:self action:@selector(comfirmAction:) forControlEvents:UIControlEventTouchUpInside];
    [comfirmBtn setTitle:@"确认" forState:UIControlStateNormal];
    [comfirmBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [content addSubview:comfirmBtn];
    
    UIButton *cancelBtn=[[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width-160, 60, 40, 30)];
    [cancelBtn addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [content addSubview:cancelBtn];
}

-(void)comfirmAction:(UIButton *)sender{
    if (self.comfirmActiom) {
        self.comfirmActiom();
    }
    [self removeFromSuperview];
}

-(void)cancelAction:(UIButton *)sender{
    if (self.cancelAction) {
        self.cancelAction();
    }
    [self removeFromSuperview];

}
@end
