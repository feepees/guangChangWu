//
//  DownloadVideoTableViewCell.m
//  guangChangWU
//
//  Created by Android on 2017/6/16.
//  Copyright © 2017年 cc.youdu. All rights reserved.
//

#import "DownloadVideoTableViewCell.h"

#import <UIImageView+AFNetworking.h>
@interface DownloadVideoTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UILabel *sizeLable;

@end
@implementation DownloadVideoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setModel:(VideoModel *)model{
    
    NSLog(@"video_img%@",[NSString stringWithFormat:@"%@%@",LocalHost,model.video_img]);
    _model=model;
    [self.headImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",LocalHost,model.video_img]] placeholderImage:[UIImage imageNamed:@"tupian"]];
    self.titleLable.text=model.name;
    self.sizeLable.text=@"408M";
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
