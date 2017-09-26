//
//  UpdateVersion.h
//  TestBlueDemo
//
//  Created by sucheng on 2017/6/14.
//  Copyright © 2017年 sucheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StatusTpye.h"
@protocol UpdateVersionManagerDelegate  <NSObject>

@optional

/**
 下载进度

 @param progress 进度
 */
-(void)downloadProgress:(float)progress;


/**
 固件包下载成功或失败

 @param status 状态
 */
-(void)downloadStatus:(DownloadStatus)status;
/**
 更新进度

 @param progress 进度
 */
-(void)updateProgress:(float)progress;

/**
 固件包更新成功或失败的代理方法， 当更新成功或者更新失败会调用此代理方法

 @param status 状态
 */
-(void)firmwareUpdateStatus:(FirmwareUpdateStatus)status;

@end

//本类主要处理固件的检查升级，固件包的下载
@interface UpdateVersionManager : NSObject

/**  */
@property(nonatomic,weak)id <UpdateVersionManagerDelegate> delegate;

/**-------------固件升级步骤-----------------------
 1、调用此方法传入手环固件版本号，方法内部会与服务器上的固件版本号进行比对，如果服务器上有新的固件版本，会自动下载最新的固件版本号。
 2、发送固件升级命令此时蓝牙会自动断开，手环名称会变成DfuLang,连接此手环，手机蓝牙会将固件包通过蓝牙传送到手环进行固件更新。
 3、若升级成功或升级失败之后蓝牙会自动断开，蓝牙名称会恢复到原来的名称（B15S）,此时会自动尝试重新连接此手环。

*/
/**
 查询是否有最新的固件包可供升级

 @param hostURL 服务器地址
 @param braceletVersion 手环固件版本
 @param completionHandler 回调，YES：有最新的固件包可供升级，NO:已经是最新的版本，不需要升级
 */
+(void)checkVersionWithHostURL:(NSString *_Nonnull)hostURL withBraceletVerson:(NSString *_Nonnull)braceletVersion withCompletionHandler:(void(^_Nullable)(BOOL isUpdate))completionHandler;

@end
