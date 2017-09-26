//
//  WholePointTestModel.h
//  TestBlueDemo
//
//  Created by sucheng on 2017/6/10.
//  Copyright © 2017年 sucheng. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 整点测量模型
 */
@interface WholePointTestModel : NSObject
/** 年 */
@property (nonatomic, assign) NSUInteger year;
/** 月 */
@property (nonatomic, assign) NSUInteger month;
/** 日 */
@property (nonatomic, assign) NSUInteger day;
/** 时 */
@property (nonatomic, assign) NSUInteger hour;
/** 分 */
@property (nonatomic, assign) NSUInteger minute;
/** 步数 */
@property (nonatomic, assign) NSUInteger step;
/** 卡路里 */
@property (nonatomic, assign) NSUInteger Kcal;
/** 心率值 */
@property (nonatomic, assign) NSUInteger heartRateValue;
/** 血压最大值 */
@property (nonatomic, assign) NSUInteger bloodPressureMaxValue;
/** 血压最小值 */
@property (nonatomic, assign) NSUInteger bloodPressurepMinValue;
/** 血氧值 */
@property (nonatomic, assign) NSUInteger bloodOxgyenValue;

@end
