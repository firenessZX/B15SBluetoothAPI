//
//  B15SPeripheralDelegate.h
//  TestBlueDemo
//
//  Created by sucheng on 2017/6/10.
//  Copyright © 2017年 sucheng. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "B15SSleepModel.h"
#import "HealthDataModel.h"
#import "WholePointTestModel.h"
/**
 此协议主要用于将外设发送过来的数据进行处理后传递到控制器
 */
@protocol B15SDataSouceDelegate <NSObject>

@optional

/**
 收到步数和卡路里的方法

 @param userStep 步数
 @param kcal 消耗的卡路里
 */
-(void)didReceiveUserStep:(NSUInteger)userStep withKcal:(float)kcal;

/**
 收到外设同步过来的睡眠数据

 @param sleepModel 睡眠模型，请查看模型属性
 */
-(void)didReceiveUserSleepData:(B15SSleepModel*)sleepModel;

/**
 收到外设同步过来的健康数据

 @param healthModel 健康模型，请具体查看模型属性
 */
-(void)didReceiveUserHealthData:(HealthDataModel*)healthModel;


/**
 收到外设同步过来的整点测量数据

 @param wholePointTestModel 整点测量数据模型，请具体查看模型属性
 */
-(void)didReceiveWholePointData:(WholePointTestModel*)wholePointTestModel;


/**
 收到外设同步的心率或血氧或者血压单次测量数据，具体是心率、血氧、血压请根据模型里面的identifider属性值来区分

 @param healthModel 模型
 */
-(void)didReceiveHeartRateorBloodOgyenorBloodPressureOnceTestData:(HealthDataModel*)healthModel;

/**
 收到外设同步的实时心率或血氧测量数据

 @param identifider 标识符：100心率、101血氧
 @param value 实时测量值
 */
-(void)didReceiveHeartRateorBloodOgyenRealTimeTestDataWithIdentifider:(NSUInteger)identifider withValue:(NSUInteger)value;

/**
 收到外设同步的实时血压测量数据

 @param maxValue 血压最大值
 @param minValue 血压最小值
 */
-(void)didReceiveBloodPressureRealTimeTestDataWithMaxValue:(NSUInteger)maxValue withMinValue:(NSUInteger)minValue;

/**
 一键测量代理方法

 @param heartRateValue 心率值
 @param BloodOxgyenValue 血氧值
 @param bloodPressureMaxValue 血压最大值
 @param bloodPressureMinValue 血压最小值
 */
-(void)aKeyMeasurementWithHeartRateValue:(NSUInteger)heartRateValue withBloodOxgyenValue:(NSUInteger)BloodOxgyenValue withbloodPressureMaxValue:(NSUInteger)bloodPressureMaxValue withBloodPressureMinValue:(NSUInteger)bloodPressureMinValue;


/**
 当开启摇一摇拍照功能，手环检测到摇动会给手环发送一条指令，通过此指令手机实现拍照功能。

 @param shakeInstruction 值：0
 */
-(void)iPhonedidReceiveShakeInstruction:(NSUInteger)shakeInstruction;

/**
 版本号

 @param versionType 版本类型
 @param version 版本
 */
-(void)getVersionWithVersionType:(NSUInteger)versionType withVersion:(float)version;

/**
 B15S睡眠数据

 @param dictionary 睡眠数据
 */
-(void)getB15SSleepData:(NSDictionary*)dictionary;

/**
 电池电量

 @param batteryPower 电量
 */
-(void)getBatteryPower:(NSUInteger)batteryPower;



@end
