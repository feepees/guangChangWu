//
//  SelectTpyeViewController.m
//  guangChangWU
//
//  Created by Android on 2017/6/7.
//  Copyright © 2017年 cc.youdu. All rights reserved.
//

#import "SelectTpyeViewController.h"
#import "EditorContentViewController.h"
#import "FMWriteVideoController.h"
#import "FMFileVideoController.h"
@interface SelectTpyeViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@end

@implementation SelectTpyeViewController

- (IBAction)photoAction:(id)sender {
    UIImagePickerController *imagePicker=[[UIImagePickerController alloc]init];
    imagePicker.sourceType=UIImagePickerControllerSourceTypeCamera;
    imagePicker.allowsEditing=YES;
    imagePicker.delegate=self;
    [self presentViewController:imagePicker animated:YES completion:nil];
}
- (IBAction)albumAction:(id)sender {
    UIImagePickerController *imagePicker=[[UIImagePickerController alloc]init];
    imagePicker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.delegate=self;
    [self presentViewController:imagePicker animated:YES completion:nil];
}
- (IBAction)articleAction:(id)sender {
    EditorContentViewController *deitorC=[[EditorContentViewController alloc]init];
    deitorC.user_id=self.user_id;
    deitorC.type=@"0";
    deitorC.special_id=self.special_id;
    UINavigationController *navC=[[UINavigationController alloc]initWithRootViewController:deitorC];
    [self presentViewController:navC animated:YES completion:nil];
}
- (IBAction)videoAction:(id)sender {
//    FMWriteVideoController *fmwC=[[FMWriteVideoController alloc]init];
//    fmwC.user_id=self.user_id;
//    UINavigationController *navC=[[UINavigationController alloc]initWithRootViewController:fmwC];
//    [self presentViewController:navC animated:YES completion:nil];
    
    FMFileVideoController *fmwC=[[FMFileVideoController alloc]init];
    fmwC.user_id=self.user_id;
    fmwC.special_id=self.special_id;
    UINavigationController *navC=[[UINavigationController alloc]initWithRootViewController:fmwC];
    [self presentViewController:navC animated:YES completion:nil];
}
- (IBAction)cancleAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
#pragma mark ----------------ImagePickerDelegate-----------------------
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    [picker dismissViewControllerAnimated:YES completion:nil];
    EditorContentViewController *deitorC=[[EditorContentViewController alloc]init];
    deitorC.user_id=self.user_id;
    deitorC.type=@"1";
    deitorC.special_id=self.special_id;
    deitorC.image=info[UIImagePickerControllerOriginalImage];
    UINavigationController *navC=[[UINavigationController alloc]initWithRootViewController:deitorC];
    [self presentViewController:navC animated:YES completion:nil];
}
@end
