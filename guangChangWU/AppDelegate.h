//
//  AppDelegate.h
//  guangChangWU
//
//  Created by Android on 2017/5/23.
//  Copyright © 2017年 cc.youdu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property(nonatomic,strong)BMKMapManager *mapManager;

@end

