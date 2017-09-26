//
//  B15SBluetoothManager.h
//  B15SBlueToothAPI
//
//  Created by sucheng on 2017/6/7.
//  Copyright © 2017年 sucheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "B15SBluetoothManagerDelegate.h"


/**
 系统蓝牙管理类：处理蓝牙的扫描，连接功能
 */
@interface B15SBluetoothManager : NSObject

//** 中央设备 */
@property(nonatomic,retain)CBCentralManager * centralManager;

//** 外设 */
@property(nonatomic,strong,readonly)CBPeripheral * peripheral;

//** 蓝牙是否打开 */
@property(assign,readonly)BOOL isTurnOn;

/** 是否开启自动重连功能  默认开启*/
@property(nonatomic,assign)BOOL autoReconnect;


//** 代理 */
@property(nonatomic,weak)id<B15SBluetoothManagerDelegate> delegate;

/**
 单例方法,系统启动时先调用一次这个函数，将会初始化蓝牙模块
 @return 全APP唯一的对象
 */
+(B15SBluetoothManager *)sharedInstance;

/**
 扫描设备

 @param interval 扫描时间

 */
-(void)scanDevicesWithInterval:(NSTimeInterval)interval;

/**
 扫描设备,根据设备名称来过滤设备
 @param interval 扫描时间
 @param filterName 过滤设备名称
 */
-(void)scanDevicesWithInterval:(NSTimeInterval)interval filterName:( NSArray<NSString*>* _Nonnull)filterName;

/**

 连接设备
 @param peripheral 准备要连接的设备
 @param option 参数
 */
-(void)connectDevice:(CBPeripheral *_Nullable) peripheral withOption:(nullable NSDictionary<NSString *,id> *)option;


/**
 断开设备连接
 */
-(void)cancelConnectDevice;


@end
