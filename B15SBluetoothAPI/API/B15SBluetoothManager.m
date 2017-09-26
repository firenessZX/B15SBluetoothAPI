
//  B15SBluetoothManager.m
//  B15SBlueToothAPI
//
//  Created by sucheng on 2017/6/7.
//  Copyright © 2017年 sucheng. All rights reserved.
//

#import "B15SBluetoothManager.h"
#import "B15SPeripheral.h"
#import "ConstNSNotificationName.h"
#import "B15SBluetoothDevice.h"
#import "B15SDataSource.h"
@interface B15SBluetoothManager ()<CBCentralManagerDelegate>
//** 定时器用于扫描设备 */
@property(nonatomic,weak)NSTimer * timer;
//** 发现的设备 */
@property(nonatomic,strong)NSMutableArray * peripheralsArray;
//** 过滤设备名称 */
@property(nonatomic,retain)NSArray * filterName;
//** 是否连接成功 */
@property(nonatomic,copy)NSString* status;

@end


@implementation B15SBluetoothManager
static  B15SBluetoothManager *B15SManager=nil;
+(B15SBluetoothManager *)sharedInstance
{
    @synchronized (self)
    {
        if (B15SManager == nil)
        {
            B15SManager = [[self alloc] init];
        }
    }
    return B15SManager;
}

#pragma mark 重写初始化方法
- (instancetype)init
{
    @synchronized(self)
    {
        if((B15SManager=[super init]))
        {
            _autoReconnect = YES;
            [self initBluetooth];
        }
        return B15SManager;
    }
}

#pragma mark --- 初始化蓝牙功能 ---
-(void)initBluetooth
{
    _centralManager=[[CBCentralManager alloc]initWithDelegate:self queue:nil];
    [_centralManager setDelegate:self];
    [self addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    NSLog(@"%s",__func__);
}

#pragma mark --- 监听设备连接状态 ---
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{

    if ([self.status isEqualToString:DeviceConnectSuccess])
    {
        if (_delegate&&[_delegate respondsToSelector:@selector(centralConnectDeviceStatus:withBlueToothManager:)])
        {
            
            [_delegate centralConnectDeviceStatus:B15SBluetoothManagerConnectSuccess withBlueToothManager:[B15SBluetoothManager sharedInstance]];
        }
    }
    else if ([self.status isEqualToString:DeviceConnectFail])
    {
            
            if (_delegate&&[_delegate respondsToSelector:@selector(centralConnectDeviceStatus:withBlueToothManager:)])
            {
                
                [_delegate centralConnectDeviceStatus:B15SBluetoothManagerConnectFailed withBlueToothManager:[B15SBluetoothManager sharedInstance]];
            }
    }
    
    
}

-(CBPeripheral*)fetchLastConnectPeripheral
{
    NSLog(@"%s",__func__);
    NSString *DeviceUUID=[[NSUserDefaults standardUserDefaults] objectForKey:kLastPeripheralIdentifierConnectedKey];
    if (DeviceUUID)
    {//根据UUID取回上次连接的设备
        
        NSUUID *UUID=[[NSUUID alloc]initWithUUIDString:DeviceUUID];
        
        NSArray <CBPeripheral *>*lastPeripheralArray = [_centralManager retrievePeripheralsWithIdentifiers:@[UUID]];
        
        if (lastPeripheralArray.count==0||lastPeripheralArray==nil)
        {    // 可重连设备的标识符存在,但是获取到的外设记录为空,错误处理
            
            return nil;
        }
        
         CBPeripheral *device =lastPeripheralArray.firstObject;
        
        _peripheral=device;
        
        [[B15SPeripheral sharedInstance]setValue:device forKey:@"peripheral"];

    }
    
    return _peripheral;
    
}

-(void)setAutoReconnect:(BOOL)autoReconnect
{

    _autoReconnect=autoReconnect;
    
    if (_peripheral)
    {
        return;
    }
    if (_autoReconnect)
    {
        if ([self fetchLastConnectPeripheral])
        {
            [_centralManager connectPeripheral:[self fetchLastConnectPeripheral] options:nil];
        }

    }
    NSLog(@"%s",__func__);

}

#pragma mark --- 此代理方法必须调用，只有手机蓝牙打开才能进行设备扫描 ---
-(void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    NSLog(@"%s",__func__);

    switch (central.state)
    {
        case CBManagerStatePoweredOff:
            _isTurnOn=NO;
            break;
            
        case CBManagerStatePoweredOn:
        {
            _isTurnOn=YES;
            if (_autoReconnect)//开启自动重连
            {

                if ([self fetchLastConnectPeripheral])
                {
                    [central connectPeripheral:[self fetchLastConnectPeripheral] options:nil];
                    
                }
                else
                {
//                [self beginScanDevice];
                    
                }
            }
      //      else
       //     {
//                [self beginScanDevice];
     //       }
        }
          
        break;
        default:
            break;
    }
    
}

-(void)scanDevicesWithInterval:(NSTimeInterval)interval
{
    NSLog(@"%s",__func__);

    _peripheralsArray=[NSMutableArray array];
    
    _timer=[NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(stopScanDevice) userInfo:nil repeats:NO];
    
    [self beginScanDevice];
}

-(void)scanDevicesWithInterval:(NSTimeInterval)interval filterName:(NSArray<NSString *> * _Nonnull)filterName
{

    NSLog(@"%s",__func__);

    _peripheralsArray=[NSMutableArray array];
    
    _timer=[NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(stopScanDevice) userInfo:nil repeats:NO];
    
    self.filterName=filterName;
    
    [self beginScanDevice];

}

#pragma mark --- 开始扫描---
-(void)beginScanDevice
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_centralManager scanForPeripheralsWithServices:nil options:nil];
    });

}

-(void)stopScanDevice{
    
    [_centralManager stopScan];
    [_timer invalidate];
    _timer =nil;
    
    if (_delegate&&[_delegate respondsToSelector:@selector(centralDidScanDevice:withBlueToothManager:)])
    {
    
        [_delegate centralDidScanDevice:_peripheralsArray withBlueToothManager:[B15SBluetoothManager sharedInstance]];
        
        [_peripheralsArray removeAllObjects];
    }
    NSLog(@"%s",__func__);

}

#pragma mark --- 已经扫描到了设备 ---

-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI
{
    
    if (_autoReconnect)
    {//先判断是否开启自动重连，如果开启自动重连就从本地取出上次连接的设备的UUID进行连接
    
        if ([peripheral.identifier.UUIDString isEqualToString:[[NSUserDefaults standardUserDefaults]objectForKey:kLastPeripheralIdentifierConnectedKey]])
        {
            
            
            [self connectDevice:peripheral withOption:nil];
            [_centralManager stopScan];
            return;
            
        }

    }
    
    for (NSDictionary *dictionary in _peripheralsArray)
    {

        if (peripheral== [dictionary objectForKey:@"device"])
        {
        
            return;
        }
        
    }
    
    if (self.filterName.count>0)
    {
         if ([self.filterName containsObject:peripheral.name])//过滤设备名称
        {
            
        NSDictionary *dict=@{@"device":peripheral,@"macAddress":[self dealwithMacAddress:[NSString stringWithFormat:@"%@",[advertisementData objectForKey:CBAdvertisementDataManufacturerDataKey]]]};
        [_peripheralsArray addObject:dict];
            
        }
    }
    else
    {
        
        NSDictionary *dict=@{@"device":peripheral,@"macAddress":[self dealwithMacAddress:[NSString stringWithFormat:@"%@",[advertisementData objectForKey:CBAdvertisementDataManufacturerDataKey]]]};
        [_peripheralsArray addObject:dict];
        
    }
    NSLog(@"%s",__func__);

}


#pragma mark --- 连接设备 ---
-(void)connectDevice:(CBPeripheral *)peripheral withOption:(NSDictionary<NSString *,id> *)option
{
    
    [self.centralManager connectPeripheral:peripheral options:nil];

    NSLog(@"%s",__func__);

}



#pragma mark  --- 设备连接成功 ---
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    _peripheral=peripheral;
    [_centralManager stopScan];
    self.status=DeviceConnectSuccess;
    [[B15SPeripheral sharedInstance]setValue:_peripheral forKey:@"peripheral"];
    [[B15SPeripheral sharedInstance]initPeripheral];
    [[NSUserDefaults standardUserDefaults]setObject:peripheral.identifier.UUIDString forKey:kLastPeripheralIdentifierConnectedKey];
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:isBindKey];
    [[NSUserDefaults standardUserDefaults]synchronize];
    NSLog(@"%s",__func__);

}

#pragma mark -- 设备连接失败 ---
-(void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    self.status=DeviceConnectFail;
    NSLog(@"%s",__func__);

}

#pragma mark --- 断开连接 ----

-(void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{

    if (![[NSUserDefaults standardUserDefaults]boolForKey:isBindKey])//主动解除绑定
    {
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:kLastPeripheralIdentifierConnectedKey];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
    else
    {// 开始扫描设备，重新尝试连接设备

        [self beginScanDevice];
    }
    NSLog(@"%s",__func__);

}

-(void)cancelConnectDevice
{

    [_centralManager cancelPeripheralConnection:_peripheral];
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:isBindKey];
    [[NSUserDefaults standardUserDefaults]synchronize];
    NSLog(@"%s",__func__);

}

#pragma mark --- 处理Mac地址 ---
-(NSString*)dealwithMacAddress:(NSString*)macString
{
    
    if (macString.length<19||[macString isEqual:nil])
    {
    
        return @"";
    }
    
    macString =[macString stringByReplacingOccurrencesOfString:@"<" withString:@""];
    macString =[macString stringByReplacingOccurrencesOfString:@">" withString:@""];
    macString =[macString stringByReplacingOccurrencesOfString:@" " withString:@""];
    macString=[[macString substringFromIndex:4]uppercaseString];
    NSMutableString *mutableString=[NSMutableString stringWithString:macString];
    [mutableString insertString:@":" atIndex:2];
    [mutableString insertString:@":" atIndex:5];
    [mutableString insertString:@":" atIndex:8];
    [mutableString insertString:@":" atIndex:11];
    [mutableString insertString:@":" atIndex:14];
    return mutableString;
    
}

-(void)dealloc
{
    
    [self removeObserver:self forKeyPath:@"status" context:nil];
    
}

@end
