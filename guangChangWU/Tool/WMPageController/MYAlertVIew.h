//
//  MYAlertVIew.h
//  maYiChaoFeng
//
//  Created by Android on 2017/3/15.
//  Copyright © 2017年 cc.youdu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MYAlertVIew : UIView

@property(nonatomic,copy)void(^comfirmActiom)();
@property(nonatomic,copy)void(^cancelAction)();



+(instancetype)showToView:(UIView *)view withTitle:(NSString *)title;

+(instancetype)showPhotoAlertToView:(UIView *)view withTakePhoto:(void(^)())takePhoto andAlbum:(void(^)())album;


@end
