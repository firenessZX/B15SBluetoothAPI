//
//  B15SPeripheral.h
//  TestBlueDemo
//
//  Created by sucheng on 2017/6/10.
//  Copyright © 2017年 sucheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "B15SDataSouceDelegate.h"
/**
 
 系统外设类，用于扫描外设服务、服务的特征以及接收外设数据
 
 */

@interface B15SPeripheral : NSObject

//**  */
@property(nonatomic,strong,readonly)CBPeripheral * peripheral;

/**  */
@property(nonatomic,weak)id<B15SDataSouceDelegate> delegate;

/**
 单利方法，返回全局唯一的外设对象
 @return singleton object
 */
+(instancetype)sharedInstance;

/**
 此方法由此API调用
 */
-(void)initPeripheral;

@end
