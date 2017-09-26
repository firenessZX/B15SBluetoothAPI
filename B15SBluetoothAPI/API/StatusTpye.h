//
//  StatusTpye.h
//  TestBlueDemo
//
//  Created by sucheng on 2017/6/9.
//  Copyright © 2017年 sucheng. All rights reserved.
//

#import <Foundation/Foundation.h>

/**连接外设的枚举定义*/
typedef NS_ENUM(NSUInteger,B15SBluetoothManagerConnectType) {
    
    /** 设备连接成功 */
    B15SBluetoothManagerConnectSuccess=100,
    /** 设备连接失败 */
    B15SBluetoothManagerConnectFailed=101,

};

/**ANCS消息通知枚举定义*/
typedef NS_ENUM(NSUInteger, ANCSMessageNotificationType) {
    
    /** 来电提醒 */
    ANCSMessageNotificationTypeCall             = 1,
    /** 短信提醒 */
    ANCSMessageNotificationTypeMessage          = 3,
    /** QQ消息提醒 */
    ANCSMessageNotificationTypeQQ               = 7,
    /** 微信消息提醒 */
    ANCSMessageNotificationTypeWechat           = 9,
    /** whatsApp消息提醒 */
    ANCSMessageNotificationTypeWhatsApp         = 10,
    /** twitter消息提醒 */
    ANCSMessageNotificationTypeTwitter          = 15,
    /** Fackbook消息提醒 */
    ANCSMessageNotificationTypeFacebook         = 16,
    /** Fackbook消息内容提醒 */
    ANCSMessageNotificationTypeFacebookMessage  = 17,
    /** 微博消息提醒 */
    ANCSMessageNotificationTypeWeibo            = 19,
    
};

/**开关功能类型枚举定义*/
typedef NS_ENUM(NSUInteger, CommandType){
        /** 查找手环 */
    CommandTypeFindBracelet = 0x71,
       /** 久坐提醒开关 */
    CommandTypeLongSit = 0x75,
    /** 勿扰模式开关 */
    CommandTypeUndisturbed = 0x76,
    /** 抬手亮屏开关 */
    CommandTypeRaiseHandLightScreen = 0x77,
    /** 拍照开关 */
    CommandTypeTakePictures = 0x79,
    /** 防丢开关 */
    CommandTypeAntiLost = 0x7a,
    /** 中英文切换开关 */
    CommandTypeSwitchLanguage = 0x7b,
    /** 电量 */
    CommandTypeBatteryLevel = 0x91,
    /** 版本号 */
    CommandTypeVersion = 0x92,
    /** 一键测量心率，血压，血氧  */
    CommandTypeOneKeyMeasureAll = 0x32,
    /** 删除数据 */
    CommandTypeDeleteData = 0x23,
    
};

/*
@param status 状态
* 血氧 实时测量   0x12
* 血氧 单次测量   0x11
* 心率 实时测量   0x0A
* 心率 单次测量   0x09
* 血压 单次测量   0x21
* 血压 实时测量   0x22
*/
/**
 健康测试类型枚举
 */
typedef NS_ENUM(NSUInteger, HealthTestType) {
    /** 血氧实时测量 */
    BloodOxygenRealTimeTest=0x12,
    /** 血氧单次测量 */
    BloodOxygenOnceTest=0x11,
    /** 心率实时测量 */
    HeartRateRealTimeTest=0x0A,
    /** 心率单次测量 */
    HeartRateOnceTest=0x09,
    /** 血压实时测量 */
    BloodPressureRealTimeTest=0x22,
    /** 血压单次测量 */
    BloodPressureOnceTest=0x21,

};

/**
 文件下载状态枚举定义

 - DownloadStatusSuccess: 下载成功
 - DownloadStatusFail: 下载失败
 */
typedef NS_ENUM(NSUInteger, DownloadStatus) {
    /** 下载成功 */
    DownloadStatusSuccess,
    /** 下载失败 */
    DownloadStatusFail,

};

/**
 固件包更新状态枚举定义

 - FirmwareUpdateStatusSuccess: 固件包更新成功
 - FirmwareUpdateStatusFail: 固件包更新失败
 */
typedef NS_ENUM(NSUInteger, FirmwareUpdateStatus) {
    //固件包更新成功
    FirmwareUpdateStatusSuccess,
    //固件包更新失败
    FirmwareUpdateStatusFail,

};

