//
//  HealthDataModel.h
//  TestBlueDemo
//
//  Created by sucheng on 2017/6/10.
//  Copyright © 2017年 sucheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HealthDataModel : NSObject

/** 0 心率，1 血压，2，血氧，3疲劳 */
@property(nonatomic,assign)NSUInteger  identifier;
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
/** 心率值或者血压值或者血氧值，根据identifier来区分 */
@property (nonatomic, assign) NSUInteger maxValue;
/** 只有血压有最小值 */
@property (nonatomic, assign) NSUInteger minValue;


@end
