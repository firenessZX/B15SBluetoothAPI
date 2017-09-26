//
//  ConstNSNotificationName.m
//  TestBlueDemo
//
//  Created by sucheng on 2017/6/12.
//  Copyright © 2017年 sucheng. All rights reserved.
//

#import "ConstNSNotificationName.h"

/** 收到步数和卡路里的通知 */
  NSNotificationName const DidReceiveUserStepAndKcalNotification    =   @"DidReceiveUserStepAndKcalNotification";
/** 收到睡眠数据的通知 */
  NSNotificationName const DidReceiveUserSleepDataNotification      =   @"DidReceiveUserSleepDataNotification";
/** 收到健康数据的通知 */
  NSNotificationName const DidReceiveUserHealthDataNotification     =   @"DidReceiveUserHealthDataNotification";
/** 收到整点测量的通知 */
  NSNotificationName const DidReceiveUserWholePointTestNotification =   @"DidReceiveUserWholePointTestNotification";
/** 收到单次测量的通知 */
  NSNotificationName const DidReceiveUserOnceTestNotification       =   @"DidReceiveUserOnceTestNotification";
/** 收到实时测量心率或者血氧的通知 */
  NSNotificationName const DidReceiveUserRealTimeTestHeartRateOrBloodOxgyenNotification                                                                              =  @"DidReceiveUserRealTimeTestHeartRateOrBloodOxgyenNotification";
/** 收到实时测量血压的通知 */
  NSNotificationName const DidReceiveUserRealTimeTestBloodPressureNotification =    @"DidReceiveUserRealTimeTestBloodPressureNotification";
/** 一键测量的通知 */
  NSNotificationName const DidReceiveAKeyTestNotification           =   @"DidReceiveAKeyTestNotification";
/** 版本号的通知 */
  NSNotificationName const DidReceiveVersionNotification            =   @"DidReceiveVersionNotification";
/** 收到B15S睡眠睡眠的通知 */
  NSNotificationName const DidReceiveB15SSleepDataNotification      =   @"DidReceiveB15SSleepDataNotification";
/** 收到电池电量的通知 */
  NSNotificationName const DidReceiveBatteryPowerNotification       =   @"DidReceiveBatteryPowerNotification";
/** 收到手环摇一摇指令的通知 */
 NSNotificationName const DidReceiveBraceletSnakeNotification       =  @"DidReceiveBraceletSnakeNotification";

//------------------------------------------------------------------------------------------

/** 设备连接成功 */
 NSNotificationName const DeviceConnectSuccess=@"DeviceConnectSuccess";
/** 设备连接失败 */
 NSNotificationName const DeviceConnectFail=@"DeviceConnectFail";
/** 上一次连接的外设的identifier */
NSNotificationName  const kLastPeripheralIdentifierConnectedKey= @"kLastPeripheralIdentifierConnectedKey";
/** 是否绑定 */
NSNotificationName  const isBindKey= @"isBindKey";


