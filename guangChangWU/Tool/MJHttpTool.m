//
//  MJHttpTool.m
//  maYiChaoFeng
//
//  Created by Android on 2017/2/21.
//  Copyright © 2017年 cc.youdu. All rights reserved.
//

#import "MJHttpTool.h"
#import "AFNetworking.h"
@interface MJHttpTool()
@property(nonatomic,strong)NSURLSessionDownloadTask *downloadTask;
@end
static AFHTTPSessionManager *manager;
@implementation MJHttpTool
+ (void)GET:(NSString *)URLString
 parameters:(id)parameters
    success:(void (^)(id responseObject))success
    failure:(void (^)(NSError *error))failure{

    AFHTTPSessionManager *mgr = [MJHttpTool getAFHTTPSessionManager];
    
    [mgr GET:URLString parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // AFN请求成功时候调用block
        // 先把请求成功要做的事情，保存到这个代码块
        if (success) {
            success(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
        
        
    }];


}


+ (void)Post:(NSString *)URLString
  parameters:(id)parameters
     success:(void (^)(id responseObject))success
     failure:(void (^)(NSError *error))failure{

    AFHTTPSessionManager *mgr = [MJHttpTool getAFHTTPSessionManager];
    
    [mgr POST:URLString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];



}
//上传文件
+ (void)PostFile:(NSString *)URLString
  parameters:(id)parameters
         fileUrl:(NSURL *)fileUrl
            data:(NSData *)data
     success:(void (^)(id responseObject))success
     failure:(void (^)(NSError *error))failure{
    
    AFHTTPSessionManager *mgr = [MJHttpTool getAFHTTPSessionManager];
    
    [mgr.requestSerializer setValue:@"application/octet-stream" forHTTPHeaderField:@"content-type"];
    [mgr POST:URLString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        if (fileUrl) {
            
        [formData appendPartWithFileURL:fileUrl name:@"file" fileName:@"file.mp4" mimeType:@"application/octet-stream" error:nil];
        }
        else{
            if (data) {
                [formData appendPartWithFileData:data name:@"file" fileName:@"file.jpg" mimeType:@"image/jpeg"];
            }
            else{
            }
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        //NSLog(@"uploadProgress%@",uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
    
    
    
}
//文件下载
+(void)fileDownload:(NSString *)urlString progress:(void (^)(NSProgress *downloadProgress)) ProgressBlock taratPath:(NSString *)Path completionHandler:(void(^)(NSURL *filePath))completionHandler{
    
    AFHTTPSessionManager *mgr=[MJHttpTool getAFHTTPSessionManager];
    NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
       NSURLSessionDownloadTask *dataTask= [mgr downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        ProgressBlock(downloadProgress);
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        return [NSURL fileURLWithPath:Path];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        completionHandler(filePath);
    }];
    
    [dataTask resume];
}

+(AFHTTPSessionManager *)getAFHTTPSessionManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
    manager = [AFHTTPSessionManager manager];
    //    设置请求头
    //https请求设置下面两个属性
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy.validatesDomainName = NO;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"image/jpg", nil];
        });
    return manager;
    
}


@end
