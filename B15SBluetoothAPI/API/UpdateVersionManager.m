//
//  UpdateVersion.m
//  TestBlueDemo
//
//  Created by sucheng on 2017/6/14.
//  Copyright © 2017年 sucheng. All rights reserved.
//

#import "UpdateVersionManager.h"
#import <iOSDFULibrary/iOSDFULibrary-Swift.h>
#import "B15SBluetoothManager.h"
@interface UpdateVersionManager ()<NSURLSessionDownloadDelegate,DFUProgressDelegate,DFUServiceDelegate,LoggerDelegate>

/** 升级用到的类 */
@property(nonatomic,strong)DFUServiceController * dfuServiceController;

@property(nonatomic,strong)DFUFirmware * selectedFirmware;

@property(nonatomic,strong)DFUServiceInitiator * initiator;

@end

@implementation UpdateVersionManager

+(void)checkVersionWithHostURL:(NSString *)hostURL withBraceletVerson:(NSString *)braceletVersion withCompletionHandler:(void (^ _Nullable)(BOOL))completionHandler
{
    //创建URL对象
    NSURL *url=[NSURL URLWithString:hostURL];
        //创建请求
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
    //设置请求方法
    request.HTTPMethod=@"POST";
    //设置请求头
    [request setValue:@"application/json;encoding=utf-8" forHTTPHeaderField:@"Content-Type"];
    //设置请求体
    NSString *body=[NSString stringWithFormat:@"clientType=ios&status=1&version=%@",braceletVersion];
    request.HTTPBody=[body dataUsingEncoding:NSUTF8StringEncoding];
    //创建请求会话
    NSURLSession *session=[NSURLSession sharedSession];
    //请求任务
    NSURLSessionDataTask *dataTask=[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        
        if ([[dict objectForKey:@"version"]floatValue]>braceletVersion.floatValue)
        {//服务器固件版本大于手环固件版本，下载文件升级
        
            [self downLoadFireWareFileWithURL:[dict objectForKey:@"url"]];
            completionHandler(YES);
        }
        else
        {   //已经是最新版本
        
            completionHandler(NO);
        }
        
    }];
    
    //启动任务
    [dataTask resume];
    NSLog(@"%s",__func__);

}

+(void)downLoadFireWareFileWithURL:(NSString*)url
{
    //创建请求
    NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    NSURLSession *session=[NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:[[UpdateVersionManager alloc]init] delegateQueue:[[NSOperationQueue alloc]init]];
    NSURLSessionDownloadTask *downloadTask=[session downloadTaskWithRequest:request];
    
    [downloadTask resume];
    NSLog(@"%s",__func__);

}

#pragma mark --- 监听下载进度 ---
-(void)URLSession:(NSURLSession *)session downloadTask:(nonnull NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite{

    float progress =1.0*totalBytesWritten/totalBytesExpectedToWrite;
    
    if (_delegate && [_delegate respondsToSelector:@selector(downloadProgress:)])
    {
    
        [_delegate downloadProgress:progress];
        
    }
    NSLog(@"%s",__func__);

}

#pragma mark --- 下载完成 ---
-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{

    NSURL *targetPath=[NSURL fileURLWithPath:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:downloadTask.response.suggestedFilename]];
    //剪切文件
   BOOL success =[[NSFileManager defaultManager]moveItemAtURL:location toURL:targetPath error:nil];
    
    if (success){
        [self setDFUFileURL:targetPath];

    }
    NSLog(@"%s",__func__);

}



#pragma mark --- 下载成功或下载失败都会执行此方法，下载成功error为空，下载失败error不为空 ---
-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{

    if (error)
    {
    
        if (_delegate && [_delegate respondsToSelector:@selector(downloadStatus:)])
        {
        
            [_delegate downloadStatus:DownloadStatusSuccess];
        }
        
    }
    else
    {
        if (_delegate && [_delegate respondsToSelector:@selector(downloadStatus:)])
        {
        
            [_delegate downloadStatus:DownloadStatusFail];
        }
        
    }
    NSLog(@"%s",__func__);

}

-(void)setDFUFileURL:(NSURL *)dfuFileurl
{

    //获取文件名（带扩展名）
    NSString * fileNameComponent =dfuFileurl.lastPathComponent;
    
    NSString *extensionName=[[fileNameComponent pathExtension]lowercaseString];
    
    if (!([extensionName isEqualToString:@"zip"]||[extensionName isEqualToString:@"hex"])) {
        return;
    }
    if ([extensionName isEqualToString:@"zip"])
    {
    
        self.selectedFirmware=[[DFUFirmware alloc]initWithUrlToZipFile:dfuFileurl];
        
    }
    else
    {
        self.selectedFirmware=[[DFUFirmware alloc]initWithUrlToBinOrHexFile:dfuFileurl urlToDatFile:nil type:DFUFirmwareTypeApplication];
    }
    
    [self uploadDevice];
    NSLog(@"%s",__func__);

}

-(void)uploadDevice
{
    if ([[B15SBluetoothManager sharedInstance].peripheral.name isEqualToString:@"DfuLang"])
    {
    
        [self DFUUpdateVersion];

    }
    NSLog(@"%s",__func__);

}
-(void)DFUUpdateVersion
{

    NSDictionary* defaults = [NSDictionary dictionaryWithObjects:@[@"2.3", [NSNumber numberWithInt:20], @NO] forKeys:@[@"key_diameter", @"dfu_number_of_packets", @"dfu_force_dfu"]];
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaults];
    if (_dfuServiceController==nil)
    {
        CBPeripheral *DFUPeripheral=[B15SBluetoothManager sharedInstance].peripheral;
        CBCentralManager *manager=[B15SBluetoothManager sharedInstance].centralManager;
        _initiator=[[DFUServiceInitiator alloc]initWithCentralManager:manager target:DFUPeripheral];
        [_initiator withFirmwareFile:_selectedFirmware];
        _initiator.forceDfu=[[[NSUserDefaults standardUserDefaults]objectForKey:@"dfu_force_dfu"]boolValue];
        _initiator.packetReceiptNotificationParameter=[[[NSUserDefaults standardUserDefaults]objectForKey:@"dfu_number_of_packets"]integerValue];
        _initiator.logger=self;
        _initiator.delegate=self;
        _initiator.progressDelegate=self;
        _dfuServiceController=[_initiator start];
        
    }
    NSLog(@"%s",__func__);

}

#pragma mark --- 固件升级进度 ---
-(void)onUploadProgress:(NSInteger)part totalParts:(NSInteger)totalParts progress:(NSInteger)progress currentSpeedBytesPerSecond:(double)currentSpeedBytesPerSecond avgSpeedBytesPerSecond:(double)avgSpeedBytesPerSecond
{

    if (_delegate && [_delegate respondsToSelector:@selector(updateProgress:)])
    {
    
        [_delegate updateProgress:progress/100.0];
        
    }
    NSLog(@"%s",__func__);

}

-(void)didStateChangedTo:(enum DFUState)state
{

    switch (state)
    {
        case DFUStateCompleted:
            if (_delegate && [_delegate respondsToSelector:@selector(firmwareUpdateStatus:)])
            {
            
                [_delegate firmwareUpdateStatus:FirmwareUpdateStatusSuccess];
            }
            [B15SBluetoothManager sharedInstance].autoReconnect=YES;
            break;
        case DFUStateFailed:
            if (_delegate && [_delegate respondsToSelector:@selector(firmwareUpdateStatus:)])
            {
                
                [_delegate firmwareUpdateStatus:FirmwareUpdateStatusFail];
            }
            [B15SBluetoothManager sharedInstance].autoReconnect=YES;
        break;
            default:
            break;
    }
    NSLog(@"%s",__func__);

}

-(void)didErrorOccur:(enum DFUError)error withMessage:(NSString *)message
{

    
    
}

-(void)logWith:(enum LogLevel)level message:(NSString *)message
{

    
    
}


@end
