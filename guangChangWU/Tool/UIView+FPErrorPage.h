//
//  UIView+FPErrorPage.h
//  maYiChaoFeng
//
//  Created by Android on 2017/4/7.
//  Copyright © 2017年 cc.youdu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BlankPage,ErrorPage;
@interface UIView (FPErrorPage)

@property(nonatomic,strong)BlankPage *blankPage;
-(void)showBlankPageView;
-(void)hideBlankPageView;

@property(nonatomic,strong)ErrorPage *errorPage;
@property (nonatomic,copy) void(^reloadAction)();
-(void)showErrorPageView;
-(void)hideErrorPageView;
@end

//空白页
@interface BlankPage : UIView

@end

//网络错误
@interface ErrorPage : UIView
@property (nonatomic,copy) void(^didClickReloadBlock)();
@end
