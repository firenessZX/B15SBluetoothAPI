//
//  B15SBluetoothDevice.m
//  TestBlueDemo
//
//  Created by sucheng on 2017/6/10.
//  Copyright © 2017年 sucheng. All rights reserved.
//

#import "B15SBluetoothDevice.h"

@interface B15SBluetoothDevice ()

@end

@implementation B15SBluetoothDevice

+(instancetype)sharedInstance
{
    static  B15SBluetoothDevice *B15SDevice=nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        B15SDevice=[[super allocWithZone:NULL]init];
        
    });
    
    return B15SDevice;
}

+(id)allocWithZone:(struct _NSZone *)zone
{
    
    return [B15SBluetoothDevice sharedInstance];
    
}

-(id) copyWithZone:(struct _NSZone *)zone
{
    return [B15SBluetoothDevice sharedInstance];
}

#pragma mark --- 固件升级 ---
-(void)firmwareUpdate
{

    NSMutableData *data = [NSMutableData data];
    Byte byte[7] = {0};
    byte[0] = 0xAB;
    byte[1] = 0;
    byte[2] = 4;
    byte[3] = 0xff;
    byte[4] = 0x25;
    byte[5] = 0x80;
    [data appendBytes:byte length:7];
    [self.peripheral writeValue:data forCharacteristic:_writeCharacter type:CBCharacteristicWriteWithResponse];
    NSLog(@"已发送固件升级指令");

}

#pragma mark --- 跌倒开关 ---
-(void)fallWithSwitch:(BOOL)swit
{

    NSMutableData *data = [NSMutableData data];
    Byte byte[7] = {0};
    byte[0] = 0xAB;
    byte[1] = 0;
    byte[2] = 4;
    byte[3] = 0xff;
    byte[4] = 0x11;
    byte[5] = 0x80;
    byte[6] = swit;
    [data appendBytes:byte length:7];
    [self.peripheral writeValue:data forCharacteristic:_writeCharacter type:CBCharacteristicWriteWithResponse];
    
    NSLog(@"已发送跌倒指令");

}

#pragma mark  --- 血氧实时，血氧单次 ，心率 实时测量，心率 单次测量，血压 单次测量，血压 实时测量 ---
-(void)measurementWithHealthTestType:(HealthTestType)testType withSwitch:(BOOL)swit
{

    
    NSMutableData *data = [NSMutableData data];
    Byte byte[7] = {0};
    byte[0] = 0xAB;
    byte[1] = 0;
    byte[2] = 4;
    byte[3] = 0XFF;
    byte[4] = 0x31;
    byte[5] = testType;
    byte[6] = swit;
    [data appendBytes:byte length:7];
    [self.peripheral writeValue:data forCharacteristic:_writeCharacter type:CBCharacteristicWriteWithResponse];
    
    NSLog(@"已发送测量指令");

}
#pragma mark  --- 一键测量 ---
-(void)aKeyMeasureAll
{

    NSMutableData *data = [NSMutableData data];
    Byte byte[6] = {0};
    byte[0] = 0xAB;
    byte[1] = 0;
    byte[2] = 3;
    byte[3] = 0XFF;
    byte[4] = 0x32;
    byte[5] = 0x80;
    [data appendBytes:byte length:6];
    [self.peripheral writeValue:data forCharacteristic:_writeCharacter type:CBCharacteristicWriteWithResponse];
    NSLog(@"已发送一键测量指令");

}
#pragma mark  --- app下拉获取数据指令 ---

-(void)dropDownPagetoSendCommandWithYear:(NSUInteger)year withMonth:(NSUInteger)month withDay:(NSUInteger)day withHour:(NSUInteger)hour
{

    NSMutableData *data = [NSMutableData data];
    Byte byte[12] = {0};
    byte[0] = 0xAB;
    byte[1] = 0;
    byte[2] = 9;
    byte[3] = 0XFF;
    byte[4] = 0x51;
    byte[5] = 0x80;
    //数据值
    byte[7] = year - 2000;
    byte[8] = month;
    byte[9] = day;
    byte[10] = hour;
    byte[11] = 0;
    [data appendBytes:byte length:12];
    
    [self.peripheral writeValue:data forCharacteristic:_writeCharacter type:CBCharacteristicWriteWithResponse];

    NSLog(@"已发送app下拉获取数据指令");

}

#pragma mark  --- 智能提醒开关 ---
-(void)smartReminderNotificationSwitch:(ANCSMessageNotificationType)notificationTpye on:(BOOL)isOn
{

    Byte byte[8] = {0};
    byte[0] = 0xab;
    //数据长度 2 bytes
    byte[1] = 0;
    byte[2] = 5;
    //数据id + status 共 3 bytes
    byte[3] = 0xff;
    byte[4] = 0x72;
    byte[5] = 0x80;
    byte[6] = notificationTpye;
    byte[7] = isOn;
    NSData *data = [NSData dataWithBytes:byte length:8];
    
    [self.peripheral writeValue:data forCharacteristic:_writeCharacter type:CBCharacteristicWriteWithResponse];
    
    NSLog(@"已发送智能提醒指令");

}

#pragma mark  --- 闹钟设置 ---
-(void)setAlarmClockWithIdentifier:(NSUInteger)identifier isOn:(BOOL)isOn withHour:(NSUInteger)hour withMinute:(NSUInteger)minute withWeekday:(NSUInteger)weekday withRepeat:(BOOL)isRepeat
{

    Byte byte[11] = {0};
    byte[0] = 0xab;
    //数据长度 2 bytes
    byte[1] = 0x00;
    byte[2] = 0x08;
    //数据id + status 共 3 bytes
    byte[3] = 0xff;
    byte[4] = 0x73;
    byte[5] = 0x80;
    //数据值
    byte[6] = identifier;
    byte[7] = isOn;
    byte[8] = hour;
    byte[9] = minute;
    byte[10] = weekday + isRepeat * powf(2, 7);
    NSData *data = [NSData dataWithBytes:byte length:11];
    [self.peripheral writeValue:data forCharacteristic:_writeCharacter type:CBCharacteristicWriteWithResponse];
    NSLog(@"已发送闹钟指令");

}

#pragma mark  --- 同步用户信息 ---
-(void)syncUserInfomation:(NSUInteger)userAge withUserHeight:(NSUInteger)userHeight withUserWeight:(NSUInteger)userWeight withUserMaxBloodPressure:(NSUInteger)userMaxBloodPressure withUserMinBloodPressure:(NSUInteger)userMinBloodPressure withDistanceUnit:(NSUInteger)distanceUnit
{

    Byte byte[13] = {0};
    byte[0] = 0xab;
    byte[1] = 0;
    byte[2] = 10;
    
    byte[3] = 0xff;
    byte[4] = 0x74;
    byte[5] = 0x80;
    
    byte[7] = userAge;
    byte[8] = userHeight;
    byte[9] = userWeight;
    byte[10] = userMaxBloodPressure;
    byte[11] = userMinBloodPressure;
    byte[12] = distanceUnit;
    NSData *data = [NSData dataWithBytes:byte length:13];
    [self.peripheral writeValue:data forCharacteristic:_writeCharacter type:CBCharacteristicWriteWithResponse];
    NSLog(@"已发送同步用户信息指令");

}

#pragma mark  --- 设置久坐提醒 ---
-(void)setLongSitReminder:(BOOL)isOn withStartHour:(NSUInteger)startHour withStartMinute:(NSUInteger)startMinute withEndHour:(NSUInteger)endHour withEndMinute:(NSUInteger)endMinute withCommandType:(CommandType)commandType
{

    Byte byte[11] = {0};
    byte[0] = 0xab;
    //数据长度 2 bytes
    byte[1] = 0;
    byte[2] = 8;
    //数据id + status 共 3 bytes
    byte[3] = 0xff;
    byte[4] = commandType;
    byte[5] = 0x80;
    byte[6] = isOn;
    byte[7] = startHour;
    byte[8] = startMinute;
    byte[9] = endHour;
    byte[10] =endMinute;
    NSData *data = [NSData dataWithBytes:byte length:11];
    
    [self.peripheral writeValue:data forCharacteristic:_writeCharacter type:CBCharacteristicWriteWithResponse];
    NSLog(@"已发送久坐提醒指令");

}

#pragma mark  --- 设置勿扰模式 ---
-(void)setUndisturbedAction:(BOOL)isOn withStartHour:(NSUInteger)startHour withStartMinute:(NSUInteger)startMinute withEndHour:(NSUInteger)endHour withEndMinute:(NSUInteger)endMinute withCommandType:(CommandType)commandType
{

    Byte byte[11] = {0};
    byte[0] = 0xab;
    //数据长度 2 bytes
    byte[1] = 0;
    byte[2] = 8;
    //数据id + status 共 3 bytes
    byte[3] = 0xff;
    byte[4] = commandType;
    byte[5] = 0x80;
    byte[6] = isOn;
    byte[7] = startHour;
    byte[8] = startMinute;
    byte[9] = endHour;
    byte[10] =endMinute;
    NSData *data = [NSData dataWithBytes:byte length:11];

    [self.peripheral writeValue:data forCharacteristic:_writeCharacter type:CBCharacteristicWriteWithResponse];
    NSLog(@"已发送勿扰模式指令");

}
#pragma mark  --- 功能性开关，抬腕亮屏，拍照等等 ---

-(void)sendCommand:(CommandType)commandType on:(BOOL)isOn
{

    if (commandType == CommandTypeFindBracelet)
    {
        Byte byte[6] = {0};
        byte[0] = 0xab;
        //数据长度 2 bytes
        byte[1] = 0;
        byte[2] = 3;
        //数据id + status 共 3 bytes
        byte[3] = 0xff;
        byte[4] = commandType;
        byte[5] = 0x80;
        NSData *data = [NSData dataWithBytes:byte length:6];
        [self.peripheral writeValue:data forCharacteristic:_writeCharacter type:CBCharacteristicWriteWithResponse];
        NSLog(@"已发送开关功能指令");

      }
    else
    {
        Byte byte[7] = {0};
        byte[0] = 0xab;
        //数据长度 2 bytes
        byte[1] = 0;
        byte[2] = 4;
        //数据id + status 共 3 bytes
        byte[3] = 0xff;
        byte[4] = commandType;
        byte[5] = 0x80;
        byte[6] = isOn;
        NSData *data = [NSData dataWithBytes:byte length:7];
        [self.peripheral writeValue:data forCharacteristic:_writeCharacter type:CBCharacteristicWriteWithResponse];
        NSLog(@"已发送开关功能指令");

    }

}

#pragma mark  --- 同步时间 ---
-(void)syncTimeToSmartBracelet
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond) fromDate:[NSDate date]];

    Byte byte[14] = {0};
    byte[0] = 0xab;
    byte[1] = 0;
    byte[2] = 11;
    
    byte[3] = 0xff;
    byte[4] = 0x93;
    byte[5] = 0x80;
    
    byte[7] = ((components.year & 0xff00) >> 8);
    byte[8] = (components.year & 0xff);
    byte[9] = (components.month & 0xff);
    byte[10] = (components.day & 0xff);
    byte[11] = (components.hour & 0xff);
    byte[12] = (components.minute & 0xff);
    byte[13] = (components.second & 0xff);
    NSData *data = [NSData dataWithBytes:byte length:14];
    
    [self.peripheral writeValue:data forCharacteristic:_writeCharacter type:CBCharacteristicWriteWithResponse];
    NSLog(@"已发送同步时间指令");

}
#pragma mark  --- ios配对 ---
-(void)sendBondPair
{

    Byte byte[7] = {0};
    byte[0] = 0xab;
    //数据长度 2 bytes
    byte[1] = 0;
    byte[2] = 4;
    //数据id + status 共 3 bytes
    byte[3] = 0xff;
    byte[4] = 0x21;
    byte[5] = 0x80;
    byte[6] = 0;
    NSData *data = [NSData dataWithBytes:byte length:7];
    [self.peripheral writeValue:data forCharacteristic:_writeCharacter type:CBCharacteristicWriteWithResponse];
    NSLog(@"已发送配对指令");

}

#pragma mark  --- 入睡时间记录 ---

-(void)enterSleepTimeRecord
{

    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond) fromDate:[NSDate date]];

    Byte byte[10] = {0};
    byte[0] = 0xab;
    //数据长度 2 bytes
    byte[1] = 0;
    byte[2] = 7;
    //数据id + status 共 3 bytes
    byte[3] = 0xff;
    byte[4] = 0x52;
    byte[5] = 0x80;
    byte[7] = components.year-2000;
    byte[8] = components.month;
    byte[9] = components.day-1;
    NSData *data = [NSData dataWithBytes:byte length:10];
    [self.peripheral writeValue:data forCharacteristic:_writeCharacter type:CBCharacteristicWriteWithResponse];
    NSLog(@"已发送入睡时间记录指令");

}

#pragma mark  --- 整点测量 ---

-(void)wholePointTestDataWithSwitch:(BOOL)swit{

    Byte byte[7] = {0};
    byte[0] = 0xab;
    //数据长度 2 bytes
    byte[1] = 0;
    byte[2] = 4;
    //数据id + status 共 3 bytes
    byte[3] = 0xff;
    byte[4] = 0x78;
    byte[5] = 0x80;
    byte[6] = swit;
    NSData *data = [NSData dataWithBytes:byte length:7];
    
    [self.peripheral writeValue:data forCharacteristic:_writeCharacter type:CBCharacteristicWriteWithResponse];
    NSLog(@"已发送整点测量指令");

}

@end
