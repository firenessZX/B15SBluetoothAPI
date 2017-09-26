//
//  B15SBluetoothCentralManagerDelegate.h
//  TestBlueDemo
//
//  Created by sucheng on 2017/6/8.
//  Copyright © 2017年 sucheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StatusTpye.h"
@class B15SBluetoothManager;

@protocol B15SBluetoothManagerDelegate <NSObject>

@optional

/**
 已经扫描到设备协议方法
 @param devices 扫描到的设备数组
 */

-(void)centralDidScanDevice:(NSArray<NSDictionary*>*)devices withBlueToothManager:(B15SBluetoothManager*)manager;


/**
 连接状态——连接成功，连接失败，连接超时,只有连接成功才能进行数据的收发。在蓝牙连接成功后，第一条指令的发送，要适当延迟几秒发送给手环,否则会报错。(主要是因为蓝牙连接成功后，需要扫描设备的服务特征，只有特征匹配才能进行数据的传输。)
 @param statusTpye 状态
 */
-(void)centralConnectDeviceStatus:(B15SBluetoothManagerConnectType)statusTpye withBlueToothManager:(B15SBluetoothManager*)manager;


@end
