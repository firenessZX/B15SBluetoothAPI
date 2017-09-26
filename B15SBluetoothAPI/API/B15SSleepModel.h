//
//  B15SSleepModel.h
//  TestBlueDemo
//
//  Created by sucheng on 2017/6/10.
//  Copyright © 2017年 sucheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface B15SSleepModel : NSObject

/** 深睡多少小时 */
@property(nonatomic,assign)NSUInteger deepSleepHour;
/** 深睡多少分钟 */
@property(nonatomic,assign)NSUInteger  deepSleepMinute;
/** 浅睡多少小时 */
@property(nonatomic,assign)NSUInteger  shallowSleepHour;
/** 浅睡多少分钟 */
@property(nonatomic,assign)NSUInteger  shallowSleepMinute;
/** 醒来次数 */
@property(nonatomic,assign)NSUInteger  awakeTime;


@end
