//
//  Utility.h
//  DDZ_Algorithm
//
//  Created by PeterZhou on 14-5-30.
//  Copyright (c) 2014年 PeterZhou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utility : NSObject

//向左旋转position位置
/**
 *  向左旋转
 *
 *  @param position 旋转的位数
 *  @param arr      需要旋转的数组
 *
 *  @return 旋转后的数组
 */
+ (NSArray *)rotationArrayWithRotaionPosition:(int)position Array:(NSArray *)arr;
+ (NSString *)rotationArrayWithRotaionPosition:(int)position string:(NSString *)str;

@end
