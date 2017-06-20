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
#import <GPUImage/GPUImage.h>
#import <AssetsLibrary/AssetsLibrary.h>



@interface EditorContentViewController ()
@property (weak, nonatomic) IBOutlet UITextView *titileTextField;
@property (weak, nonatomic) IBOutlet UILabel *placeHolder;
@property (weak, nonatomic) IBOutlet UIButton *imageBtn;
@property(nonatomic,strong)NSString *special;
@property (weak, nonatomic) IBOutlet UILabel *specialLable;

//GPUImage
@property(nonatomic,strong)GPUImageMovie *movieFile;

@property(nonatomic,strong)GPUImageUIElement *landInput;
@property(nonatomic,strong)GPUImageAlphaBlendFilter *landBlendFilter;
@property(nonatomic,strong)GPUImageMovieWriter *movieWriter;
@property(nonatomic,strong)GPUImageBrightnessFilter *brightnessFilter;

//AVFoundation
@property(nonatomic,strong)AVAsset *videoAsset;
@property(nonatomic,strong)NSURL *videoUrl;

@end

@implementation EditorContentViewController

- (IBAction)subjectAction:(id)sender {

    SpecialViewController *specialC=[[SpecialViewController alloc]init];
    specialC.title=@"选择专题";
    specialC.selectSpecial=^(NSString *special,NSString *title){
        self.special=special;
        self.specialLable.text=[NSString stringWithFormat:@"#%@",title];
    };
    [self.navigationController pushViewController:specialC animated:YES];
}

- (IBAction)photoAction:(id)sender {
    [self waterfilter];
    
}
-(void)GPUImage_waterFilter{
    self.movieFile =[[GPUImageMovie alloc] initWithURL:self.fileUrl];
    self.movieFile.runBenchmark=YES;
    self.movieFile.playAtActualSpeed=NO;
    AVAsset *files=[AVAsset assetWithURL:self.fileUrl];
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
    CGSize movieSize=files.naturalSize;
#pragma clang diagnostic pop
    
    NSLog(@"size%@",[NSValue valueWithCGSize:movieSize]);
    
    //水印图片
    UIImageView *waterImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 80, 56)];
    waterImageView.image=[UIImage imageNamed:@"shuiyin"];
    
    UIView *coverView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, movieSize.width, movieSize.height)];
    coverView.backgroundColor=[UIColor clearColor];
    
    waterImageView.center=CGPointMake(waterImageView.bounds.size.width, coverView.bounds.size.height+80);
    
    [coverView addSubview:waterImageView];
    
    self.landInput=[[GPUImageUIElement alloc]initWithView:coverView];
    self.landBlendFilter=[[GPUImageAlphaBlendFilter alloc]init];
    self.landBlendFilter.mix=1.0f;
    NSString *pathToMovie = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Movie.mp4"];
    unlink([pathToMovie UTF8String]); //如果视频存在，删掉！
    NSURL *movieURL = [NSURL fileURLWithPath:pathToMovie];
    
    _movieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:movieURL size:movieSize];
    _movieWriter.transform = CGAffineTransformMakeScale(0.3, 0.3);
    
    _brightnessFilter = [[GPUImageBrightnessFilter alloc] init];
    _brightnessFilter.brightness = 0.0f;
    
    [_movieFile addTarget:_brightnessFilter];
    [_brightnessFilter addTarget:_landBlendFilter];
    [_landInput addTarget:_landBlendFilter];
    
    [_landBlendFilter addTarget:_movieWriter];
    
    
    __weak typeof(self) weakSelf = self;
    _movieWriter.shouldPassthroughAudio = YES;
    _movieFile.audioEncodingTarget = _movieWriter;
    [_movieFile enableSynchronizedEncodingUsingMovieWriter:_movieWriter];
    
    [_movieWriter startRecording];
    [_movieFile startProcessing];
    
    [_movieWriter setCompletionBlock:^{
        [weakSelf.brightnessFilter removeTarget:weakSelf.movieWriter];
        [weakSelf.movieWriter finishRecording];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
            
            [library writeVideoAtPathToSavedPhotosAlbum:movieURL
                                        completionBlock:^(NSURL *assetURL, NSError
                                                          *error) {
                                            
                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                NSLog(@"---finished!!!!!");
                                                
                                                [[[UIAlertView alloc] initWithTitle:@"" message:@"已经成功写入相册!" delegate:nil cancelButtonTitle:@"好的"
                                                                  otherButtonTitles: nil] show];
                                            });
                                        }];
        });
    }];

}
-(void)waterfilter{
    //1 创建AVAsset实例 AVAsset包含了video的所有信息 self.videoUrl输入视频的路径
    self.videoAsset = [AVAsset assetWithURL:self.fileUrl];
    //2 创建AVMutableComposition实例. apple developer 里边的解释 【AVMutableComposition is a mutable subclass of AVComposition you use when you want to create a new composition from existing assets. You can add and remove tracks, and you can add, remove, and scale time ranges.】
    AVMutableComposition *mixComposition = [[AVMutableComposition alloc] init];
    
    //3 视频通道  工程文件中的轨道，有音频轨、视频轨等，里面可以插入各种对应的素材
    AVMutableCompositionTrack *videoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo
                                                                        preferredTrackID:kCMPersistentTrackID_Invalid];
    //音频轨道
    AVMutableCompositionTrack *aduioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio
                                                                        preferredTrackID:kCMPersistentTrackID_Invalid];
    NSLog(@"audio%@video%@",[self.videoAsset tracksWithMediaType:AVMediaTypeAudio],[self.videoAsset tracksWithMediaType:AVMediaTypeVideo]);

    //把音频轨道添加到可变轨道中
    if ([self.videoAsset tracksWithMediaType:AVMediaTypeAudio].count) {
        [aduioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, self.videoAsset.duration)
                        ofTrack:[[self.videoAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0]
                         atTime:kCMTimeZero error:nil];
    }

    //把视频轨道数据加入到可变轨道中 这部分可以做视频裁剪TimeRange
    [videoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, self.videoAsset.duration)
                        ofTrack:[[self.videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0]
                         atTime:kCMTimeZero error:nil];
        //3.1 AVMutableVideoCompositionInstruction 视频轨道中的一个视频，可以缩放、旋转等
    AVMutableVideoCompositionInstruction *mainInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    mainInstruction.timeRange = CMTimeRangeMake(kCMTimeZero, self.videoAsset.duration);
    
    // 3.2 AVMutableVideoCompositionLayerInstruction 一个视频轨道，包含了这个轨道上的所有视频素材
    AVMutableVideoCompositionLayerInstruction *videolayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack];
    AVAssetTrack *videoAssetTrack = [[self.videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    UIImageOrientation videoAssetOrientation_  = UIImageOrientationUp;
    BOOL isVideoAssetPortrait_  = NO;
    CGAffineTransform videoTransform = videoAssetTrack.preferredTransform;
    if (videoTransform.a == 0 && videoTransform.b == 1.0 && videoTransform.c == -1.0 && videoTransform.d == 0) {
        videoAssetOrientation_ = UIImageOrientationRight;
        isVideoAssetPortrait_ = YES;
    }
    if (videoTransform.a == 0 && videoTransform.b == -1.0 && videoTransform.c == 1.0 && videoTransform.d == 0) {
        videoAssetOrientation_ =  UIImageOrientationLeft;
        isVideoAssetPortrait_ = YES;
    }
    if (videoTransform.a == 1.0 && videoTransform.b == 0 && videoTransform.c == 0 && videoTransform.d == 1.0) {
        videoAssetOrientation_ =  UIImageOrientationUp;
    }
    if (videoTransform.a == -1.0 && videoTransform.b == 0 && videoTransform.c == 0 && videoTransform.d == -1.0) {
        videoAssetOrientation_ = UIImageOrientationDown;
    }
    [videolayerInstruction setTransform:videoAssetTrack.preferredTransform atTime:kCMTimeZero];
    [videolayerInstruction setOpacity:0.0 atTime:mainInstruction.timeRange.duration];
    
    // 3.3 - Add instructions
    mainInstruction.layerInstructions = [NSArray arrayWithObjects:videolayerInstruction,nil];
    //AVMutableVideoComposition：管理所有视频轨道，可以决定最终视频的尺寸，裁剪需要在这里进行
    AVMutableVideoComposition *mainCompositionInst = [AVMutableVideoComposition videoComposition];
    
    CGSize naturalSize;
    if(isVideoAssetPortrait_){
        naturalSize = CGSizeMake(videoAssetTrack.naturalSize.height, videoAssetTrack.naturalSize.width);
    } else {
        naturalSize = videoAssetTrack.naturalSize;
    }
    
    float renderWidth, renderHeight;
    renderWidth = naturalSize.width;
    renderHeight = naturalSize.height;
    mainCompositionInst.renderSize = CGSizeMake(renderWidth, renderHeight);
    mainCompositionInst.instructions = [NSArray arrayWithObject:mainInstruction];
    mainCompositionInst.frameDuration = CMTimeMake(1, 30);
    [self applyVideoEffectsToComposition:mainCompositionInst size:naturalSize];
    
    // 4 - 输出路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *myPathDocs =  [documentsDirectory stringByAppendingPathComponent:
                             [NSString stringWithFormat:@"FinalVideo-%d.mp4",arc4random() % 1000]];
    self.videoUrl = [NSURL fileURLWithPath:myPathDocs];
    
    // 5 - 视频文件输出
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:mixComposition
                                                                      presetName:AVAssetExportPresetMediumQuality];
    exporter.outputURL=self.videoUrl;
    exporter.outputFileType = AVFileTypeMPEG4;
    exporter.shouldOptimizeForNetworkUse = YES;
    exporter.videoComposition = mainCompositionInst;
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            //这里是输出视频之后的操作，做你想做的
            [self getVideoLength:self.videoUrl];
            [self getFileSize:self.videoUrl.path];
            [self exportDidFinish:exporter];
        });
    }];
}
- (void)exportDidFinish:(AVAssetExportSession*)session {
    if (session.status == AVAssetExportSessionStatusCompleted) {
        NSURL *outputURL = session.outputURL;
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        if ([library videoAtPathIsCompatibleWithSavedPhotosAlbum:outputURL]) {
            [library writeVideoAtPathToSavedPhotosAlbum:outputURL completionBlock:^(NSURL *assetURL, NSError *error){
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (error) {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Video Saving Failed"
                                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                        [alert show];
                    } else {
                        
                        
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Video Saved" message:@"Saved To Photo Album"
                                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                        [alert show];
                    }
                });
            }];
        }
    }
}
- (void)applyVideoEffectsToComposition:(AVMutableVideoComposition *)composition size:(CGSize)size
{
    // 1 - Set up the text layer
    CATextLayer *subtitle1Text = [[CATextLayer alloc] init];
    [subtitle1Text setFont:@"Helvetica-Bold"];
    [subtitle1Text setFontSize:36];
    [subtitle1Text setFrame:CGRectMake(0, 0, size.width, 100)];
    [subtitle1Text setString:@"哈哈  这是水印"];
    [subtitle1Text setAlignmentMode:kCAAlignmentCenter];
    [subtitle1Text setForegroundColor:[[UIColor redColor] CGColor]];
    
    CALayer *layer=[CALayer layer];
    [layer setFrame:CGRectMake(size.width-65, 0, 65, 35)];
    UIImage *image=(id)[UIImage imageNamed:@"shuiyin"].CGImage;
    layer.contents=image;
    // 2 - The usual overlay
    CALayer *overlayLayer = [CALayer layer];
    //[overlayLayer addSublayer:subtitle1Text];
    [overlayLayer addSublayer:layer];
    overlayLayer.frame = CGRectMake(0, 0, size.width, size.height);
    [overlayLayer setMasksToBounds:YES];
    
    CALayer *parentLayer = [CALayer layer];
    CALayer *videoLayer = [CALayer layer];
    parentLayer.frame = CGRectMake(0, 0, size.width, size.height);
    videoLayer.frame = CGRectMake(0, 0, size.width, size.height);
    [parentLayer addSublayer:videoLayer];
    [parentLayer addSublayer:overlayLayer];
    
    composition.animationTool = [AVVideoCompositionCoreAnimationTool
                                 videoCompositionCoreAnimationToolWithPostProcessingAsVideoLayer:videoLayer inLayer:parentLayer];
    
}

- (IBAction)submitAction:(id)sender {
    if (!self.titileTextField.text) {
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
    [MJHttpTool PostFile:Show parameters:parameter fileUrl:self.videoUrl data:data success:^(id responseObject) {
        NSLog(@"responseObject%@",responseObject);
        [YJProgressHUD hide];
        if ([responseObject[@"code"] isEqualToString:@"0000"]) {
            [YJProgressHUD showSuccess:@"发布成功" inview:self.view];
            [self.navigationController dismissViewControllerAnimated:YES completion:nil ];
        }
        else{
             [YJProgressHUD showMessage:@"发布失败" inView:self.view];
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
    [self setNavigationBar];
    self.view.backgroundColor=[UIColor colorWithRed:240/250.0 green:240/250.0 blue:240/250.0 alpha:1];

    RAC(self.placeHolder,hidden)= [self.titileTextField.rac_textSignal map:^id _Nullable(NSString * _Nullable value) {
        return @(value.length);
    }];
    
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
- (CGFloat) getFileSize:(NSString *)path
{
    NSLog(@"%@",path);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    float filesize = -1.0;
    if ([fileManager fileExistsAtPath:path]) {
        NSDictionary *fileDic = [fileManager attributesOfItemAtPath:path error:nil];//获取文件的属性
        unsigned long long size = [[fileDic objectForKey:NSFileSize] longLongValue];
        filesize = 1.0*size/1024;
    }else{
        NSLog(@"找不到文件");
    }
    NSLog(@"filesize%f",filesize);
    return filesize;
}//此方法可以获取文件的大小，返回的是单位是KB。
- (CGFloat) getVideoLength:(NSURL *)URL
{
    
    AVURLAsset *avUrl = [AVURLAsset assetWithURL:URL];
    CMTime time = [avUrl duration];
    int second = ceil(time.value/time.timescale);
    NSLog(@"second%d",second);
    return second;
}//此方法可以获取视频文件的时长。
@end
