//
//  B15SDataSource.h
//  TestBlueDemo
//
//  Created by sucheng on 2017/6/12.
//  Copyright © 2017年 sucheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "B15SDataSouceDelegate.h"
@interface B15SDataSource : NSObject

@property(nonatomic,weak)id<B15SDataSouceDelegate> delegate;

+(instancetype)sharedInstance;
/**
 监听外设数据变化,此方法由此API调用
 */
-(void)observePerpheralDataChange;


@end
