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
@interface ViewController ()<UIWebViewDelegate>
@property(nonatomic,strong)UIWebView *web;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIWebView *web=[[UIWebView alloc]initWithFrame:self.view.bounds];
    self.web=web;
    //web.scalesPageToFit=YES;
    web.scrollView.bounces=NO;
    web.delegate=self;
    NSURL *url=[NSURL URLWithString:@"http://test14.xinyv.net"];
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    [web loadRequest:request];
    
    [self.view addSubview:web];
}
-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    self.web.frame=self.view.bounds;
}
#pragma mark ----------------UIWebViewDelegate----------------------------
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    //NSLog(@"%@",request.URL.absoluteString);
    if ([request.URL.scheme isEqualToString:@"show"]) {
        
        
       NSRange range= [request.URL.absoluteString rangeOfString:@"="];
      NSString *userid=  [request.URL.absoluteString substringFromIndex:range.location+1];
        NSLog(@"show userid=%@",userid);
        SelectTpyeViewController *selectC=[[SelectTpyeViewController alloc]init];
        selectC.user_id=userid;
        [self presentViewController:selectC animated:YES completion:nil];
        /*
        UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"选择发布类型" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        [alert addAction:[UIAlertAction actionWithTitle:@"文章" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            NSLog(@"写文章");
            EditorContentViewController *editorC=[[EditorContentViewController alloc]init];
            [self presentViewController:editorC animated:YES completion:nil];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            EditorContentViewController *editorC=[[EditorContentViewController alloc]init];
            [self presentViewController:editorC animated:YES completion:nil];
            NSLog(@"去拍照");
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"视频" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            EditorContentViewController *editorC=[[EditorContentViewController alloc]init];
            [self presentViewController:editorC animated:YES completion:nil];
            NSLog(@"拍视频");
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"取消");
        }]];
        
        [self presentViewController:alert animated:YES completion:nil];*/
        
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
