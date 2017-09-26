//
//  B15SBluetoothDevice.h
//  TestBlueDemo
//
//  Created by sucheng on 2017/6/10.
//  Copyright © 2017年 sucheng. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <CoreBluetooth/CoreBluetooth.h>

#import "StatusTpye.h"

@interface B15SBluetoothDevice : NSObject

//** 外设 */
@property(nonatomic,strong)CBPeripheral * peripheral;

//** 写入特征 */
@property(nonatomic,strong)CBCharacteristic * writeCharacter;

/**
 单利方法，此方法返回一个唯一实例，通过此单利进行发送指令到设备
 */
+(instancetype)sharedInstance;

/**
 固件升级
 */
-(void)firmwareUpdate;
/**
 跌倒开关

 @param swit 开关
 */
-(void)fallWithSwitch:(BOOL)swit;

/**
 测量开关,一键测量
*/
-(void)measurementWithHealthTestType:(HealthTestType)testType withSwitch:(BOOL)swit;

/**
 一键测量所有
 */
-(void)aKeyMeasureAll;

/**
 App下拉页面获取数据的命令

 @param year 年
 @param month 月
 @param day 日
 @param hour 小时
 */
-(void)dropDownPagetoSendCommandWithYear:(NSUInteger)year withMonth:(NSUInteger)month withDay:(NSUInteger)day withHour:(NSUInteger)hour;

/**
 智能提醒通知开关,ANCS通知提醒必须配对成功才能使用

 @param notificationTpye 通知类型
 @param isOn 开或关
 */
-(void)smartReminderNotificationSwitch:(ANCSMessageNotificationType)notificationTpye on:(BOOL)isOn;

/**
 闹钟设置
 @param identifier 标志
 @param isOn 闹钟开或关
 @param hour 小时
 @param minute 分钟
 @param weekday 周
 @param isRepeat 是否重复
 */
-(void)setAlarmClockWithIdentifier:(NSUInteger)identifier
                              isOn:(BOOL)isOn
                          withHour:(NSUInteger)hour
                        withMinute:(NSUInteger)minute
                       withWeekday:(NSUInteger)weekday
                   withRepeat:(BOOL)isRepeat;


/**
 同步用户信息

 @param userAge 年龄
 @param userHeight 身高
 @param userWeight 体重
 @param userMaxBloodPressure 最大血压
 @param userMinBloodPressure 最小血压
 @param distanceUnit 步长
 */
-(void)syncUserInfomation:(NSUInteger)userAge
           withUserHeight:(NSUInteger)userHeight
           withUserWeight:(NSUInteger)userWeight
 withUserMaxBloodPressure:(NSUInteger)userMaxBloodPressure
 withUserMinBloodPressure:(NSUInteger)userMinBloodPressure
         withDistanceUnit:(NSUInteger)distanceUnit;

/**
 设置久坐提醒

 @param isOn 是否开启久坐提醒
 @param startHour 开始时间(小时)
 @param startMinute 开始时间（分钟）
 @param endHour 结束时间（小时）
 @param endMinute 结束时间(分钟)
 @param commandType 命令类型
 */
-(void)setLongSitReminder:(BOOL)isOn
            withStartHour:(NSUInteger)startHour
          withStartMinute:(NSUInteger)startMinute
              withEndHour:(NSUInteger)endHour
            withEndMinute:(NSUInteger)endMinute
          withCommandType:(CommandType)commandType;


/**
 设置勿扰模式

 @param isOn 是否开启勿扰模式
 @param startHour 开始时间（小时）
 @param startMinute 开始时间（分钟）
 @param endHour 结束时间（小时）
 @param endMinute 结束时间（分钟）
 @param commandType 命令类型
 */
-(void)setUndisturbedAction:(BOOL)isOn
              withStartHour:(NSUInteger)startHour
            withStartMinute:(NSUInteger)startMinute
                withEndHour:(NSUInteger)endHour
              withEndMinute:(NSUInteger)endMinute
            withCommandType:(CommandType)commandType;

/**

 @param commandType 命令类型
 @param isOn 是否开启此功能
 */
-(void)sendCommand:(CommandType)commandType on:(BOOL)isOn;

/**
 同步手环时间
 */
-(void)syncTimeToSmartBracelet;

/**
 ios 配对
 */
-(void)sendBondPair;

/**
 入睡时间记录
 */
-(void)enterSleepTimeRecord;

/**
 整点测量

 @param swit 状态
 */
-(void)wholePointTestDataWithSwitch:(BOOL)swit;

@end
