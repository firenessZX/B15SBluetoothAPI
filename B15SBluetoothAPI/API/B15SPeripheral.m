//
//  B15SPeripheral.m
//  TestBlueDemo
//
//  Created by sucheng on 2017/6/10.
//  Copyright © 2017年 sucheng. All rights reserved.
//

#import "B15SPeripheral.h"
#import "B15SBluetoothDevice.h"
#import "ConstNSNotificationName.h"
#import "B15SDataSource.h"
@interface B15SPeripheral ()<CBPeripheralDelegate,CBPeripheralManagerDelegate>
//** 读特征 */
@property(nonatomic,strong)CBCharacteristic * readCharacteristic;
//** 写特征 */
@property(nonatomic,strong)CBCharacteristic * writeCharacteristic;

@end

static NSString * const  B15SServiceUUID    =@"6e400001-b5a3-f393-e0a9-e50e24dcca9e";
static NSString * const  B15SWrite          =@"6e400002-b5a3-f393-e0a9-e50e24dcca9e";
static NSString * const B15SRead            =@"6e400003-b5a3-f393-e0a9-e50e24dcca9e";

@implementation B15SPeripheral

+(instancetype)sharedInstance
{
    static  B15SPeripheral *peripheral=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        peripheral=[[super allocWithZone:NULL]init];
        
    });
    
    return peripheral;
}

+(id)allocWithZone:(struct _NSZone *)zone
{
    
    return [B15SPeripheral sharedInstance];
    
}

-(id) copyWithZone:(struct _NSZone *)zone
{
    return [B15SPeripheral sharedInstance];
}

-(void)initPeripheral
{

    [[B15SDataSource sharedInstance]observePerpheralDataChange];
    self.peripheral.delegate=self;
    [_peripheral discoverServices:nil];
    [B15SBluetoothDevice sharedInstance].peripheral=_peripheral;
    NSLog(@"%s",__func__);

}

#pragma mark  --- 已经扫描到了服务 ---
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
    
    if (error)
    {
        
        return;
        
    }
    
    for (CBService *service in peripheral.services)
    {
        
        if ([service.UUID isEqual:[CBUUID UUIDWithString:B15SServiceUUID]])
        {
            
            [peripheral discoverCharacteristics:@[[CBUUID UUIDWithString:B15SRead],[CBUUID UUIDWithString:B15SWrite]] forService:service];
            break;
        }
        
    }
    NSLog(@"%s",__func__);

    
}

#pragma mark  --- 已经扫描到了服务的特征值 ---
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {
    
    if (error)
    {
        return;
    }
    
    for (CBCharacteristic *characteristic in service.characteristics)
    {
        
        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:B15SRead]])
        {
            
            [peripheral setNotifyValue:YES forCharacteristic:characteristic];
            _readCharacteristic=characteristic;
            break;
        }
        
    }
    //获取Characteristic的值，读到数据会进入方法：-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
    for (CBCharacteristic *characteristic in service.characteristics)
    {
        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:B15SWrite]])
        {
            [peripheral setNotifyValue:YES forCharacteristic:characteristic];
            _writeCharacteristic=characteristic;
            [B15SBluetoothDevice sharedInstance].writeCharacter=characteristic;
            break;
            
        }
        
    }
    NSLog(@"%s",__func__);

}

#pragma mark ---- 获取的charateristic的值 ---
-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    //value的类型是NSData，具体开发时，会根据外设协议制定的方式去解析数据
    NSLog(@"%s",__func__);
    
    NSUInteger length=characteristic.value.length;
    
    Byte byte[length];
    
    [characteristic.value getBytes:byte length:length];
    
    if (byte[0]==0xab)
    {
        
        if (byte[4]==0x51)
        {
        
               //手环主动测量的心率,血压，血氧数据
            if (byte[5]==0x08)
            {
               
                NSUInteger step=(byte[6] << 16) + (byte[7] << 8) + byte[8]; //步数
                float kcal=(byte[9] << 16) + (byte[10] << 8) + byte[11];//卡路里
                
                [[NSNotificationCenter defaultCenter]postNotificationName:DidReceiveUserStepAndKcalNotification object:nil userInfo:@{@"step":@(step),@"kcal":@(kcal)}];
            
//                if (_delegate&&[_delegate respondsToSelector:@selector(didReceiveUserStep:withKcal:)])
//                {
//                
//                    [_delegate didReceiveUserStep:step withKcal:kcal];
//                    
//                }
//                
//                B15SSleepModel *sleepModel=[[B15SSleepModel alloc]init];
//                sleepModel.deepSleepHour=byte[12];
//                sleepModel.deepSleepMinute=byte[13];
//                sleepModel.shallowSleepHour=byte[14];
//                sleepModel.shallowSleepMinute=byte[15];
//                sleepModel.awakeTime=byte[16];
                
//                if (_delegate&&[_delegate respondsToSelector:@selector(didReceiveUserSleepData:)])
//                {
//                    [_delegate didReceiveUserSleepData:sleepModel];
//                    
//                }
                [[NSNotificationCenter defaultCenter]postNotificationName:DidReceiveUserSleepDataNotification object:nil userInfo:@{@"deepSleepHour":@(byte[12]),@"deepSleepMinute":@(byte[13]),@"shallowSleepHour:":@(byte[14]),@"shallowSleepMinute":@(byte[15]),@"awakeTime":@(byte[16])}];
                
            }
            else if (byte[5]==0x11)
            {
               
                if (byte[11]>0)//心率
                {
//                    HealthDataModel *healthModel=[[HealthDataModel alloc]init];
//                    
//                    healthModel.identifier = 0;
//                    healthModel.year = byte[6] + 2000;
//                    healthModel.month = byte[7];
//                    healthModel.day = byte[8];
//                    healthModel.hour = byte[9];
//                    healthModel.minute = byte[10];
//                    healthModel.maxValue  = byte[11];
//                    
//                    if (_delegate && [_delegate respondsToSelector:@selector(didReceiveUserHealthData:)])
//                    {
//                    
//                        [_delegate didReceiveUserHealthData:healthModel];
//                        
//                    }
                    
                    [[NSNotificationCenter defaultCenter]postNotificationName:DidReceiveUserHealthDataNotification object:nil userInfo:@{@"identifier":@(0),@"year":@(byte[6]+2000),@"month":@(byte[7]),@"day":@(byte[8]),@"hour":@(byte[9]),@"minute":@(byte[10]),@"maxValue":@(byte[11])}];
                    

                }
       
            }
            else if (byte[5]==0x12)
            {
            
                if (byte[11]>0)//血氧
                {
//                    HealthDataModel *healthModel=[[HealthDataModel alloc]init];
//                    healthModel.identifier = 2;
//                    healthModel.year = byte[6] + 2000;
//                    healthModel.month = byte[7];
//                    healthModel.day = byte[8];
//                    healthModel.hour = byte[9];
//                    healthModel.minute = byte[10];
//                    healthModel.maxValue  = byte[11];
//                    if (_delegate && [_delegate respondsToSelector:@selector(didReceiveUserHealthData:)])
//                    {
//                        
//                        [_delegate didReceiveUserHealthData:healthModel];
//                        
//                    }
                    [[NSNotificationCenter defaultCenter]postNotificationName:DidReceiveUserHealthDataNotification object:nil userInfo:@{@"identifier":@(2),@"year":@(byte[6]+2000),@"month":@(byte[7]),@"day":@(byte[8]),@"hour":@(byte[9]),@"minute":@(byte[10]),@"maxValue":@(byte[11])}];

                }

            }
            else if (byte[5]==0x13)
            {
                if (byte[11]>0)//血压
                {
//                    HealthDataModel *healthModel=[[HealthDataModel alloc]init];
//                    healthModel.identifier = 1;
//                    healthModel.year = byte[6] + 2000;
//                    healthModel.month = byte[7];
//                    healthModel.day = byte[8];
//                    healthModel.hour = byte[9];
//                    healthModel.minute = byte[10];
//                    healthModel.maxValue  = byte[11];
//                    healthModel.minValue=byte[12];
//                    
//                    if (_delegate && [_delegate respondsToSelector:@selector(didReceiveUserHealthData:)])
//                    {
//                        [_delegate didReceiveUserHealthData:healthModel];
//                        
//                    }
                       [[NSNotificationCenter defaultCenter]postNotificationName:DidReceiveUserHealthDataNotification object:nil userInfo:@{@"identifier":@(1),@"year":@(byte[6]+2000),@"month":@(byte[7]),@"day":@(byte[8]),@"hour":@(byte[9]),@"minute":@(byte[10]),@"maxValue":@(byte[11]),@"minValue":@(byte[12])}];
                    
                }

            }
            else if (byte[5]==0x20)
            {//整点测量的数据（步数、卡路里、心率、血氧、血压）
//                WholePointTestModel *testModel=[[WholePointTestModel alloc]init];
//                testModel.year = byte[6] + 2000;
//                testModel.month = byte[7];
//                testModel.day = byte[8];
//                testModel.hour = byte[9];
//                testModel.step = byte[10] * 256 * 256 + byte[11] * 256 + byte[12];
//                testModel.cal = byte[13] * 256 * 256 + byte[14] * 256 + byte[15];
//                testModel.heartRateValue = byte[16];
//                testModel.bloodOxgyenValue = byte[17];
//                testModel.bloodPressureMaxValue = byte[18];
//                testModel.bloodPressurepMinValue = byte[19];
//                if (_delegate && [_delegate respondsToSelector:@selector(didReceiveWholePointData:)])
//                {
//                
//                    [_delegate didReceiveWholePointData:testModel];
//                }
                [[NSNotificationCenter defaultCenter]postNotificationName:DidReceiveUserWholePointTestNotification object:nil userInfo:@{@"year":@(byte[6]+2000),@"month":@(byte[7]),@"day":@(byte[8]),@"hour":@(byte[9]),@"step":@(byte[10] * 256 * 256 + byte[11] * 256 + byte[12]),@"kcal":@(byte[13] * 256 * 256 + byte[14] * 256 + byte[15]),@"heartRateValue":@(byte[16]),@"bloodOxgyenValue":@(byte[17]),@"bloodPressureMaxValue":@(byte[18]),@"bloodPressureMinValue":@(byte[19])}];
                
            }
        }
        else if (byte[4]==0x31)
        {
        
            if (byte[5]==0x09)
            {
                //心率单次测量
                if (byte[6]>0)
                {
                
//                    NSDateComponents *component=[self getDateComponentsFromDate:[NSDate date]];
//                    HealthDataModel *healthModel=[[HealthDataModel alloc]init];
//                    healthModel.identifier = 0;
//                    healthModel.year = component.year;
//                    healthModel.month = component.month;
//                    healthModel.day = component.day;
//                    healthModel.hour = component.hour;
//                    healthModel.minute = component.minute;
//                    healthModel.maxValue  = byte[6];
//                    if (_delegate && [_delegate respondsToSelector:@selector(didReceiveHeartRateorBloodOgyenorBloodPressureOnceTestData:)])
//                    {
//                    
//                        [_delegate didReceiveHeartRateorBloodOgyenorBloodPressureOnceTestData:healthModel];
//                        
//                    }
                    
                    [[NSNotificationCenter defaultCenter]postNotificationName:DidReceiveUserOnceTestNotification object:nil userInfo:@{@"identifier":@(0),@"heartRateValue":@(byte[6])}];
                    
                }
   
            }
            else if (byte[5]==0x0a)
            {
            
                if (byte[6]>0)
                {
                    //心率实时测量
//                if (_delegate && [_delegate respondsToSelector:@selector(didReceiveHeartRateorBloodOgyenRealTimeTestDataWithIdentifider:withValue:)])
//                    {
//                        
//                        [_delegate didReceiveHeartRateorBloodOgyenRealTimeTestDataWithIdentifider:100 withValue:byte[6]];
//                        
//                    }
                    [[NSNotificationCenter defaultCenter]postNotificationName:DidReceiveUserRealTimeTestHeartRateOrBloodOxgyenNotification object:nil userInfo:@{@"identifider":@(100),@"value":@(byte[6])}];
                    
                }
                
            }
            else if (byte[5]==0x11)
            {
                //血氧 单次测量
                if (byte[6]>0)
                {
//                    NSDateComponents *component = [self getDateComponentsFromDate:[NSDate date]];
//                    HealthDataModel *healthModel = [[HealthDataModel alloc] init];
//                    healthModel.identifier = 2;
//                    healthModel.year = component.year;
//                    healthModel.month = component.month;
//                    healthModel.day = component.day;
//                    healthModel.hour = component.hour;
//                    healthModel.minute = component.minute;
//                    healthModel.maxValue  = byte[6];
//                    if (_delegate && [_delegate respondsToSelector:@selector(didReceiveHeartRateorBloodOgyenorBloodPressureOnceTestData:)])
//                    {
//                        
//                        [_delegate didReceiveHeartRateorBloodOgyenorBloodPressureOnceTestData:healthModel];
//                        
//                    }
                    
                    [[NSNotificationCenter defaultCenter]postNotificationName:DidReceiveUserOnceTestNotification object:nil userInfo:@{@"identifier":@(2),@"maxValue":@(byte[6])}];
                    
                    
                    
                }
            }
            else if (byte[5]==0x12)
            {
                //血氧实时测量
                if (byte[6]>0)
                {
//                    if (_delegate && [_delegate respondsToSelector:@selector(didReceiveHeartRateorBloodOgyenRealTimeTestDataWithIdentifider:withValue:)])
//                    {
//                        
//                        [_delegate didReceiveHeartRateorBloodOgyenRealTimeTestDataWithIdentifider:101 withValue:byte[6]];
//                        
//                    }
                    [[NSNotificationCenter defaultCenter]postNotificationName:DidReceiveUserRealTimeTestHeartRateOrBloodOxgyenNotification object:nil userInfo:@{@"identifider":@(101),@"value":@(byte[6])}];
                    
                }
                
            }
            else if (byte[5]==0x21)
            {//血压单次测量
                if (byte[6]>0 && byte[7]>0)
                {
                    
//                    NSDateComponents *component = [self getDateComponentsFromDate:[NSDate date]];
//                    HealthDataModel *healthModel = [[HealthDataModel alloc] init];
//                    healthModel.identifier = 1;
//                    healthModel.year = component.year;
//                    healthModel.month = component.month;
//                    healthModel.day = component.day;
//                    healthModel.hour = component.hour;
//                    healthModel.minute = component.minute;
//                    healthModel.maxValue  = byte[6];
//                    healthModel.minValue = byte[7];
//                    if (_delegate && [_delegate respondsToSelector:@selector(didReceiveHeartRateorBloodOgyenorBloodPressureOnceTestData:)])
//                    {
//                        
//                        [_delegate didReceiveHeartRateorBloodOgyenorBloodPressureOnceTestData:healthModel];
//                        
//                    }
                
                    [[NSNotificationCenter defaultCenter]postNotificationName:DidReceiveUserOnceTestNotification object:nil userInfo:@{@"identifier":@(1),@"maxValue":@(byte[6]),@"minValue":@(byte[7])}];
                    
                }
                
            }
            else if (byte[5]==0x22)
            {
                //血压实时测量
                if (byte[6]>0 && byte[7]>0)
                {
                    
//                    if (_delegate && [_delegate respondsToSelector:@selector(didReceiveBloodPressureRealTimeTestDataWithMaxValue:withMinValue:)])
//                    {
//                        
//                        [_delegate didReceiveBloodPressureRealTimeTestDataWithMaxValue:byte[6] withMinValue:byte[7]];
//                        
//                    }
                    
                    [[NSNotificationCenter defaultCenter]postNotificationName:DidReceiveUserRealTimeTestBloodPressureNotification object:nil userInfo:@{@"maxValue":@(byte[6]),@"minValue":@(byte[7])}];
                    
                }
                
            }
            
        }
        else if (byte[4]==0x32)
        {//一键测量
        
//            if (_delegate && [_delegate respondsToSelector:@selector(aKeyMeasurementWithHeartRateValue:withBloodOxgyenValue:withbloodPressureMaxValue:withBloodPressureMinValue:)])
//            {
//            
//                [_delegate aKeyMeasurementWithHeartRateValue:byte[6] withBloodOxgyenValue:byte[7] withbloodPressureMaxValue:byte[8] withBloodPressureMinValue:byte[9]];
//                
//            }
            
            [[NSNotificationCenter defaultCenter]postNotificationName:DidReceiveAKeyTestNotification object:nil userInfo:@{@"heartRateValue":@(byte[6]),@"bloodOxgyenValue":@(byte[7]),@"bloodPressureMaxValue":@(byte[8]),@"bloodPressureMinValue":@(byte[9])}];
            
            
        }
        else if (byte[4]==0x92)
        {//版本号
        
//            if (_delegate && [_delegate respondsToSelector:@selector(getVersionWithVersionType:withVersion:)])
//            {
//            
//                [_delegate getVersionWithVersionType:byte[8] withVersion:byte[6]+byte[7]/100];
//            }
            
            [[NSNotificationCenter defaultCenter]postNotificationName:DidReceiveVersionNotification object:nil userInfo:@{@"versionType":@(byte[8]),@"version":@(byte[6]+byte[7]/100)}];
            
            
        }
        else if (byte[4==0x91])
        {

            if (byte[7]==0)//摇一摇拍照
            {
             [[NSNotificationCenter defaultCenter]postNotificationName:DidReceiveBraceletSnakeNotification object:nil userInfo:@{@"shake":@(byte[7])}];
            }
            else
            {//电池电量
                [[NSNotificationCenter defaultCenter]postNotificationName:DidReceiveBatteryPowerNotification object:nil userInfo:@{@"batteryPower":@(byte[7])}];
                
            }
            
        }
        else if (byte[4]==0x11)
        {
        //跌倒次数
            
        }
        else if (byte[4]==0x79)
        {

            
        }
        else if (byte[4]==0x52)
        {
        //睡眠数据
            NSDictionary *dict=@{@"year": @(byte[6]+2000),@"month":@(byte[7]),@"day":@(byte[8]),@"hour":@(byte[9]),@"minute":@(byte[10]),@"state":@(byte[11]),@"minutes":@(byte[12]*256+byte[13])};
            
//            if (_delegate && [_delegate respondsToSelector:@selector(getB15SSleepData:)])
//            {
//            
//                [_delegate getB15SSleepData:dict];
//                
//            }
            
            [[NSNotificationCenter defaultCenter]postNotificationName:DidReceiveB15SSleepDataNotification object:nil userInfo:dict];
            
        }
        
    }
    else
    {
    
        if (byte[0]==0x04)
        {
            if (byte[5]==0xcc)
            {
                //版本号
//                if (_delegate && [_delegate respondsToSelector:@selector(getVersionWithVersionType:withVersion:)])
//                {
//                    
//                    [_delegate getVersionWithVersionType:byte[7]+byte[8]/100 withVersion:byte[9]];
//                    
//                }
                
                [[NSNotificationCenter defaultCenter]postNotificationName:DidReceiveVersionNotification object:nil userInfo:@{@"versionType":@(byte[7]+byte[8]/100),@"version":@(byte[9])}];

            }
            else if (byte[5]==0xEA)
            {
            
                //电池电量
//                if (_delegate && [_delegate respondsToSelector:@selector(getBatteryPower:)])
//                {
//                
//                    [_delegate getBatteryPower:byte[8]];
//                }
                
                [[NSNotificationCenter defaultCenter]postNotificationName:DidReceiveBatteryPowerNotification object:nil userInfo:@{@"batteryPower":@(byte[8])}];
                

            }
        }
    
    }
    
    if (byte[0]==0)
    {
        //整点数据,有重复数据就更新，没有就插入数据
        
    }
    if (byte[0]==0xab)
    {
        if (byte[4]==0x21)
        {

             //先获取版本号 再用版本号在获取活动量数据
            [[B15SBluetoothDevice sharedInstance]sendCommand:CommandTypeVersion on:YES];
            [[B15SBluetoothDevice sharedInstance]sendCommand:CommandTypeBatteryLevel on:YES];
            
            //切换语言
            NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
            NSArray * allLanguages = [defaults objectForKey:@"AppleLanguages"];
            NSString * preferredLang = [allLanguages objectAtIndex:0];
            if ([preferredLang isEqualToString:@"zh-Hans-CN"]||[preferredLang isEqualToString:@"zh-Hans"])
            {
                [[B15SBluetoothDevice sharedInstance]sendCommand:CommandTypeSwitchLanguage on:NO];
            }
            else
            {
            
                [[B15SBluetoothDevice sharedInstance]sendCommand:CommandTypeSwitchLanguage on:YES];

            }
            
            
        }
        
    }
    
    
}

#pragma mark ---- 停止扫描并断开连接 ---
-(void)disconnectPeripheral:(CBCentralManager *)centralManager peripheral:(CBPeripheral *)peripheral{
    //停止扫描
    [centralManager stopScan];
    //断开连接
    [centralManager cancelPeripheralConnection:peripheral];
    
}



@end
