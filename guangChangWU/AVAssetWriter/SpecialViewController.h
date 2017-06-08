//
//  SpecialViewController.h
//  guangChangWU
//
//  Created by Android on 2017/6/8.
//  Copyright © 2017年 cc.youdu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SpecialViewController : UIViewController
@property(nonatomic,copy)void(^selectSpecial)(NSString *special,NSString *title);
@end
