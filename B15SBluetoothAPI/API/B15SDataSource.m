//
//  B15SDataSource.m
//  TestBlueDemo
//
//  Created by sucheng on 2017/6/12.
//  Copyright © 2017年 sucheng. All rights reserved.
//

#import "B15SDataSource.h"

#import "ConstNSNotificationName.h"
#import "B15SSleepModel.h"
@implementation B15SDataSource

+(instancetype)sharedInstance
{
    static  B15SDataSource *dataSource=nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        dataSource=[[super allocWithZone:NULL]init];
        
    });
    
    return dataSource;
}

+(id)allocWithZone:(struct _NSZone *)zone
{
    
    return [B15SDataSource sharedInstance];
    
}

-(id) copyWithZone:(struct _NSZone *)zone
{
    return [B15SDataSource sharedInstance];
}

-(void)observePerpheralDataChange
{

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didReceiveUserStepKcal:) name:DidReceiveUserStepAndKcalNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didReceiveUserHealthData:) name:DidReceiveUserHealthDataNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DidReceiveUserRealTimeTestHeartRateOrBloodOxgyen:) name:DidReceiveUserRealTimeTestHeartRateOrBloodOxgyenNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DidReceiveUserRealTimeTestBloodPressure:) name:DidReceiveUserRealTimeTestBloodPressureNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DidReceiveUserSleepData:) name:DidReceiveUserSleepDataNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DidReceiveUserWholePointTest:) name:DidReceiveUserWholePointTestNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DidReceiveUserOnceTest:) name:DidReceiveUserOnceTestNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DidReceiveAKeyTest:) name:DidReceiveAKeyTestNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DidReceiveBatteryPower:) name:DidReceiveBatteryPowerNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DidReceiveB15SSleepData:) name:DidReceiveB15SSleepDataNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DidReceiveVersion:) name:DidReceiveVersionNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DidReceiveSnake:) name:DidReceiveBraceletSnakeNotification object:nil];
    NSLog(@"%s",__func__);

}

#pragma mark --- 处理步数和卡路里 ---

-(void)didReceiveUserStepKcal:(NSNotification*)notification
{

    NSDictionary *userInfo=notification.userInfo;
    
    if (_delegate && [_delegate respondsToSelector:@selector(didReceiveUserStep:withKcal:)])
    {
    
        [_delegate didReceiveUserStep:[[userInfo objectForKey:@"step"]integerValue] withKcal:[[userInfo objectForKey:@"kcal"]floatValue]];
        
    }
    NSLog(@"%s",__func__);

}

#pragma mark --- 处理睡眠数据 ---
-(void)DidReceiveUserSleepData:(NSNotification*)notification
{
    
    B15SSleepModel *sleepModel=[[B15SSleepModel alloc]init];
    sleepModel.deepSleepHour=[[notification.userInfo objectForKey:@"deepSleepHour"]integerValue];
    sleepModel.deepSleepMinute=[[notification.userInfo objectForKey:@"deepSleepMinute"]integerValue];
    sleepModel.shallowSleepHour=[[notification.userInfo objectForKey:@"shallowSleepHour"]integerValue];
    sleepModel.shallowSleepMinute=[[notification.userInfo objectForKey:@"shallowSleepMinute"]integerValue];
    sleepModel.awakeTime=[[notification.userInfo objectForKey:@"awakeTime"]integerValue];
    
    if (_delegate&&[_delegate respondsToSelector:@selector(didReceiveUserSleepData:)])
    {
        [_delegate didReceiveUserSleepData:sleepModel];
        
    }
    NSLog(@"%s",__func__);
    
}
-(void)didReceiveUserHealthData:(NSNotification*)notification
{

    HealthDataModel *healthModel=[[HealthDataModel alloc]init];
    if ([notification.userInfo objectForKey:@"identifier"]==0)//心率
    {
        
        healthModel.identifier = 0;
        healthModel.year = [[notification.userInfo objectForKey:@"year"]integerValue];
        healthModel.month = [[notification.userInfo objectForKey:@"month"]integerValue];
        healthModel.day =[[notification.userInfo objectForKey:@"month"]integerValue];
        healthModel.hour = [[notification.userInfo objectForKey:@"day"]integerValue];
        healthModel.minute = [[notification.userInfo objectForKey:@"hour"]integerValue];
        healthModel.maxValue  =[[notification.userInfo objectForKey:@"maxValue"]integerValue];
        
    }
    else if ([[notification.userInfo objectForKey:@"identifier"] integerValue]==1)
    {
        //血压
        healthModel.identifier = 1;
        healthModel.year = [[notification.userInfo objectForKey:@"year"]integerValue];
        healthModel.month = [[notification.userInfo objectForKey:@"month"]integerValue];
        healthModel.day =[[notification.userInfo objectForKey:@"month"]integerValue];
        healthModel.hour = [[notification.userInfo objectForKey:@"day"]integerValue];
        healthModel.minute = [[notification.userInfo objectForKey:@"hour"]integerValue];
        healthModel.maxValue  =[[notification.userInfo objectForKey:@"maxValue"]integerValue];
        healthModel.minValue=[[notification.userInfo objectForKey:@"minValue"]integerValue];
        
    }
    else if ([[notification.userInfo objectForKey:@"identifier"] integerValue]==2)
    {//血氧
        healthModel.identifier = 2;
        healthModel.year = [[notification.userInfo objectForKey:@"year"]integerValue];
        healthModel.month = [[notification.userInfo objectForKey:@"month"]integerValue];
        healthModel.day =[[notification.userInfo objectForKey:@"month"]integerValue];
        healthModel.hour = [[notification.userInfo objectForKey:@"day"]integerValue];
        healthModel.minute = [[notification.userInfo objectForKey:@"hour"]integerValue];
        healthModel.maxValue  =[[notification.userInfo objectForKey:@"maxValue"]integerValue];
        
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(didReceiveUserHealthData:)])
    {
        
        [_delegate didReceiveUserHealthData:healthModel];
        
    }
    NSLog(@"%s",__func__);

}

#pragma mark --- 处理心率和血氧的实时测量数据 ---
-(void)DidReceiveUserRealTimeTestHeartRateOrBloodOxgyen:(NSNotification*)notification
{

    if (_delegate && [_delegate respondsToSelector:@selector(didReceiveHeartRateorBloodOgyenRealTimeTestDataWithIdentifider:withValue:)])
    {

       [ _delegate didReceiveHeartRateorBloodOgyenRealTimeTestDataWithIdentifider:[[notification.userInfo objectForKey:@"identifider"]intValue] withValue:[[notification.userInfo objectForKey:@"value"] integerValue]];
        
    }
    NSLog(@"%s",__func__);

}

#pragma mark --- 处理血压的实时测量数据 ---

-(void)DidReceiveUserRealTimeTestBloodPressure:(NSNotification*)notification
{

    if (_delegate && [_delegate respondsToSelector:@selector(didReceiveBloodPressureRealTimeTestDataWithMaxValue:withMinValue:)])
    {
        
        [_delegate didReceiveBloodPressureRealTimeTestDataWithMaxValue:[[notification.userInfo objectForKey:@"maxValue"] integerValue] withMinValue:[[notification.userInfo objectForKey:@"minValue"] integerValue]];
        
    }
    NSLog(@"%s",__func__);

}

-(void)DidReceiveUserWholePointTest:(NSNotification*)notification
{

    WholePointTestModel *testModel=[[WholePointTestModel alloc]init];
    testModel.year = [[notification.userInfo objectForKey:@"year"]integerValue];
    testModel.month = [[notification.userInfo objectForKey:@"month"]integerValue];
    testModel.day = [[notification.userInfo objectForKey:@"day"]integerValue];
    testModel.hour = [[notification.userInfo objectForKey:@"hour"]integerValue];
    testModel.step = [[notification.userInfo objectForKey:@"step"]integerValue];
    testModel.Kcal = [[notification.userInfo objectForKey:@"kcal"]integerValue];
    testModel.heartRateValue = [[notification.userInfo objectForKey:@"heartRateValue"]integerValue];
    testModel.bloodOxgyenValue = [[notification.userInfo objectForKey:@"bloodOxgyenValue"]integerValue];
    testModel.bloodPressureMaxValue =[[notification.userInfo objectForKey:@"bloodPressureMaxValue"]integerValue];
    testModel.bloodPressurepMinValue = [[notification.userInfo objectForKey:@"bloodPressureMinValue"]integerValue];
    if (_delegate && [_delegate respondsToSelector:@selector(didReceiveWholePointData:)])
    {
        
        [_delegate didReceiveWholePointData:testModel];
    }
    NSLog(@"%s",__func__);

}

-(void)DidReceiveUserOnceTest:(NSNotification *)notification
{

    NSDateComponents *component=[self getDateComponentsFromDate:[NSDate date]];
    HealthDataModel *healthModel=[[HealthDataModel alloc]init];

    if ([[notification.userInfo objectForKey:@"identifier"]integerValue]==0)
    {   //心率单次测量
    
        healthModel.identifier = 0;
        healthModel.year = component.year;
        healthModel.month = component.month;
        healthModel.day = component.day;
        healthModel.hour = component.hour;
        healthModel.minute = component.minute;
        healthModel.maxValue  =[[notification.userInfo objectForKey:@"heartRateValue"]integerValue];

    }
    else if ([[notification.userInfo objectForKey:@"identifier"]integerValue]==1)
    {//血压单次测量
    
        healthModel.identifier = 1;
        healthModel.year = component.year;
        healthModel.month = component.month;
        healthModel.day = component.day;
        healthModel.hour = component.hour;
        healthModel.minute = component.minute;
        healthModel.maxValue  =[[notification.userInfo objectForKey:@"maxValue"]integerValue];
        healthModel.minValue = [[notification.userInfo objectForKey:@"minValue"]integerValue];
        
        
    }
    else if ([[notification.userInfo objectForKey:@"identifier"]integerValue]==2)
    {//血氧单次测量

        healthModel.identifier = 2;
        healthModel.year = component.year;
        healthModel.month = component.month;
        healthModel.day = component.day;
        healthModel.hour = component.hour;
        healthModel.minute = component.minute;
        healthModel.maxValue  = [[notification.userInfo objectForKey:@"maxValue"]integerValue];

    }

     if (_delegate && [_delegate respondsToSelector:@selector(didReceiveHeartRateorBloodOgyenorBloodPressureOnceTestData:)])
    {
        
        [_delegate didReceiveHeartRateorBloodOgyenorBloodPressureOnceTestData:healthModel];
        
    }
    
    NSLog(@"%s",__func__);

}

#pragma mark --- 处理一键测量数据 ---
-(void)DidReceiveAKeyTest:(NSNotification*)notification
{
    
    if (_delegate && [_delegate respondsToSelector:@selector(aKeyMeasurementWithHeartRateValue:withBloodOxgyenValue:withbloodPressureMaxValue:withBloodPressureMinValue:)])
    {
    
        [_delegate aKeyMeasurementWithHeartRateValue:[[notification.userInfo objectForKey:@"heartRateValue"]integerValue] withBloodOxgyenValue:[[notification.userInfo objectForKey:@"bloodOxgyenValue"]integerValue] withbloodPressureMaxValue:[[notification.userInfo objectForKey:@"bloodPressureMaxValue"]integerValue] withBloodPressureMinValue:[[notification.userInfo objectForKey:@"bloodPressureMinValue"]integerValue]];
        
    }
    NSLog(@"%s",__func__);

}

#pragma mark --- 电池电量数据 ---
-(void)DidReceiveBatteryPower:(NSNotification*)notification
{

    if (_delegate && [_delegate respondsToSelector:@selector(getBatteryPower:)])
    {
        
        [_delegate getBatteryPower:[[notification.userInfo objectForKey:@"batteryPower"] integerValue]];
        
    }
    NSLog(@"%s",__func__);

}

#pragma mark --- 摇一摇 ---
-(void)DidReceiveSnake:(NSNotification *)notification
{

    if (_delegate && [_delegate respondsToSelector:@selector(iPhonedidReceiveShakeInstruction:)])
    {
    
        [_delegate iPhonedidReceiveShakeInstruction:[[notification.userInfo objectForKey:@"shake"] integerValue]];
        
    }
    NSLog(@"%s",__func__);

}

#pragma mark --- B15s睡眠数据 ---
-(void)DidReceiveB15SSleepData:(NSNotification *)notification
{
    
    if (_delegate && [_delegate respondsToSelector:@selector(getB15SSleepData:)])
    {
        
        [_delegate getB15SSleepData:notification.userInfo];
        
    }
    NSLog(@"%s",__func__);

    
}

#pragma mark --- 处理版本号数据 ---

-(void)DidReceiveVersion:(NSNotification *)notification
{

    if (_delegate && [_delegate respondsToSelector:@selector(getVersionWithVersionType:withVersion:)])
    {
        
        [_delegate getVersionWithVersionType:[[notification.userInfo objectForKey:@"versionType"] integerValue] withVersion:[[notification.userInfo objectForKey:@"version"] floatValue]];
    }
    NSLog(@"%s",__func__);

}

- (NSDateComponents *)getDateComponentsFromDate:(NSDate *)date
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday) fromDate:date];
    
    return components;
}

-(void)dealloc
{

    [[NSNotificationCenter defaultCenter]removeObserver:self name:DidReceiveUserStepAndKcalNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:DidReceiveUserHealthDataNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:DidReceiveUserRealTimeTestHeartRateOrBloodOxgyenNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:DidReceiveUserRealTimeTestBloodPressureNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:DidReceiveUserSleepDataNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:DidReceiveUserWholePointTestNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:DidReceiveUserOnceTestNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:DidReceiveAKeyTestNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:DidReceiveBatteryPowerNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:DidReceiveB15SSleepDataNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:DidReceiveVersionNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:DidReceiveBraceletSnakeNotification object:nil];
    
}

@end
