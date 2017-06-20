//
//  UIView+FPErrorPage.m
//  maYiChaoFeng
//
//  Created by Android on 2017/4/7.
//  Copyright © 2017年 cc.youdu. All rights reserved.
//

#import "UIView+FPErrorPage.h"
#import <objc/runtime.h>
#import <Masonry.h>
@implementation UIView (FPErrorPage)
#pragma mark  --------------------空白页----------------------------------------------
-(void)setBlankPage:(BlankPage *)blankPage{
    [self willChangeValueForKey:NSStringFromSelector(@selector(blankPage))];
    objc_setAssociatedObject(self, @selector(blankPage), blankPage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:NSStringFromSelector(@selector(blankPage))];
}
-(BlankPage *)blankPage{
    return objc_getAssociatedObject(self, _cmd);
}
-(void)showBlankPageView{
    if(!self.blankPage){
        self.blankPage=[[BlankPage alloc]initWithFrame:self.bounds];
        self.blankPage.backgroundColor=[UIColor whiteColor];
    }
    [self addSubview:self.blankPage];
    [self bringSubviewToFront:self.blankPage];
}
-(void)hideBlankPageView{
    if (self.blankPage) {
        [self.blankPage removeFromSuperview];
        self.blankPage=nil;
    }
}

#pragma mark  --------------------网络错误--------------------------------------------

- (void)setReloadAction:(void (^)())reloadAction{
    objc_setAssociatedObject(self, @selector(reloadAction), reloadAction, OBJC_ASSOCIATION_COPY);
}
- (void (^)())reloadAction{
    return objc_getAssociatedObject(self, _cmd);
}
-(void)setErrorPage:(ErrorPage *)errorPage{
    [self willChangeValueForKey:NSStringFromSelector(@selector(errorPage))];
    objc_setAssociatedObject(self, @selector(errorPage), errorPage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:NSStringFromSelector(@selector(errorPage))];
    
}
-(ErrorPage *)errorPage{
 return objc_getAssociatedObject(self, _cmd);
}

-(void)showErrorPageView{
    if (!self.errorPage) {
        self.errorPage=[[ErrorPage alloc]initWithFrame:self.bounds];
        
    }
    [self addSubview:self.errorPage];
    [self bringSubviewToFront:self.errorPage];
}
-(void)hideErrorPageView{
    if (self.errorPage) {
        [self.errorPage removeFromSuperview];
    }
}
- (void)configReloadAction:(void (^)())block{
    self.reloadAction = block;
    if (self.errorPage && self.reloadAction) {
        self.errorPage.didClickReloadBlock = self.reloadAction;
    }}
@end
#pragma mark  --------------------空白页----------------------------------------------
@interface BlankPage ()
@property (nonatomic,weak) UIImageView* nodataImageView;
@property (nonatomic,weak) UILabel* nodataTipLabel;
@end

@implementation BlankPage
- (instancetype)init{
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView* nodataImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"wushuju"]];
        _nodataImageView = nodataImageView;
        [self addSubview:_nodataImageView];
        
        UILabel* nodataTipLabel = [[UILabel alloc]init];
        nodataTipLabel.numberOfLines = 1;
        nodataTipLabel.font = [UIFont systemFontOfSize:15];
        nodataTipLabel.textAlignment = NSTextAlignmentCenter;
        nodataTipLabel.textColor = [UIColor grayColor];
        nodataTipLabel.text = @"这里没有数据呢,赶紧弄出点动静吧~";
        _nodataTipLabel = nodataTipLabel;
        [self addSubview:_nodataTipLabel];
        
        [_nodataImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.bottom.equalTo(self.mas_centerY).offset(-10);
        }];
        
        [_nodataTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.height.equalTo(@50);
            make.top.equalTo(_nodataImageView.mas_bottom).offset(5);
        }];
    }
    return self;
}
@end
#pragma mark --------------  未联网页面  --------------------------

@interface ErrorPage ()
@property (nonatomic,weak) UIImageView* errorImageView;
@property (nonatomic,weak) UILabel* errorTipLabel;
@property (nonatomic,weak) UIButton* reloadButton;

@end
@implementation ErrorPage
- (instancetype)init{
    return [self initWithFrame:CGRectZero];
}
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        UIImageView* errorImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"wushuju"]];
        _errorImageView = errorImageView;
        [self addSubview:_errorImageView];
        
        UILabel* errorTipLabel = [[UILabel alloc]init];
        errorTipLabel.numberOfLines = 1;
        errorTipLabel.font = [UIFont systemFontOfSize:16];
        errorTipLabel.textAlignment = NSTextAlignmentCenter;
        errorTipLabel.textColor = [UIColor darkGrayColor];
        errorTipLabel.text = @"feepees提醒：您的网络好像有点问题哦~";
        _errorTipLabel = errorTipLabel;
        [self addSubview:_errorTipLabel];
        
        UIButton* reloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
        reloadButton.layer.masksToBounds = YES;
        reloadButton.layer.cornerRadius = 20;
        [reloadButton setTitle:@"  点击刷新" forState:UIControlStateNormal];
        reloadButton.titleLabel.font =[UIFont systemFontOfSize:15];
        [reloadButton setImage:[UIImage imageNamed:@"DWQrefresh_white" ] forState:UIControlStateNormal];
        reloadButton.backgroundColor = [UIColor lightGrayColor];
        [reloadButton addTarget:self action:@selector(_clickReloadButton:) forControlEvents:UIControlEventTouchUpInside];
        _reloadButton = reloadButton;
        [self addSubview:_reloadButton];
        
        [_errorImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.centerY.equalTo(self.mas_centerY).offset(-30);
        }];
        
        [_errorTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.height.equalTo(@20);
            make.top.equalTo(_errorImageView.mas_bottom);
        }];
        
        [_reloadButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(kScreenWidth-60);
            make.height.mas_equalTo(40);
            make.centerX.equalTo(self);
            make.bottom.equalTo(self.mas_bottom).offset(-30);
        }];
    }
    return self;
}
- (void)_clickReloadButton:(UIButton* )btn{
    if (_didClickReloadBlock) {
        _didClickReloadBlock();
    }
}

@end
