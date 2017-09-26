//
//  ConstNSNotificationName.h
//  TestBlueDemo
//
//  Created by sucheng on 2017/6/12.
//  Copyright © 2017年 sucheng. All rights reserved.
//

#import <UIKit/UIKit.h>

//-----------------------------通知名定义-----------------------------------------
/** 收到步数和卡路里的通知 */
UIKIT_EXTERN NSNotificationName const DidReceiveUserStepAndKcalNotification;
/** 收到睡眠数据的通知 */
UIKIT_EXTERN NSNotificationName const DidReceiveUserSleepDataNotification;
/** 收到健康数据的通知 */
UIKIT_EXTERN NSNotificationName const DidReceiveUserHealthDataNotification;
/** 收到整点测量的通知 */
UIKIT_EXTERN NSNotificationName const DidReceiveUserWholePointTestNotification;
/** 收到单次测量的通知 */
UIKIT_EXTERN NSNotificationName const DidReceiveUserOnceTestNotification;
/** 收到实时测量心率或者血氧的通知 */
UIKIT_EXTERN NSNotificationName const DidReceiveUserRealTimeTestHeartRateOrBloodOxgyenNotification;
/** 收到实时测量血压的通知 */
UIKIT_EXTERN NSNotificationName const DidReceiveUserRealTimeTestBloodPressureNotification;
/** 一键测量的通知 */
UIKIT_EXTERN NSNotificationName const DidReceiveAKeyTestNotification;
/** 版本号的通知 */
UIKIT_EXTERN NSNotificationName const DidReceiveVersionNotification;
/** 收到B15S睡眠睡眠的通知 */
UIKIT_EXTERN NSNotificationName const DidReceiveB15SSleepDataNotification;
/** 收到电池电量的通知 */
UIKIT_EXTERN NSNotificationName const DidReceiveBatteryPowerNotification;
/** 收到手环摇一摇指令的通知 */
UIKIT_EXTERN NSNotificationName const DidReceiveBraceletSnakeNotification;
//-----------------------------------------------------------------------------------------

/** 设备连接成功 */
UIKIT_EXTERN NSNotificationName const DeviceConnectSuccess;
/** 设备连接失败 */
UIKIT_EXTERN NSNotificationName const DeviceConnectFail;

/** 上一次连接的外设的identifier */
UIKIT_EXTERN NSNotificationName const  kLastPeripheralIdentifierConnectedKey;
/** 是否绑定 */
UIKIT_EXTERN NSNotificationName const  isBindKey;

