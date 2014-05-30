//
//  Utility.m
//  DDZ_Algorithm
//
//  Created by PeterZhou on 14-5-30.
//  Copyright (c) 2014年 PeterZhou. All rights reserved.
//

#import "Utility.h"

@implementation Utility
/**
 *  旋转
 *
 *  @param position 旋转位数
 *  @param arr      需要旋转的数组
 *
 *  @return 旋转后数组
 */
+ (NSArray *)rotationArrayWithRotaionPosition:(int)position Array:(NSArray *)arr{
    NSMutableArray *array = [NSMutableArray arrayWithArray:arr];
    int end = (int)arr.count-1;
    [Utility rotationWithRotation:0 endPosition:position-1 array:array];
    [Utility rotationWithRotation:position endPosition:end array:array];
    [Utility rotationWithRotation:0 endPosition:end array:array];
    return array;
}

+ (NSArray *)rotationWithRotation:(int)i endPosition:(int)end array:(NSMutableArray *)arr{
    for (int j = i; j<end; j++) {
        [arr exchangeObjectAtIndex:j withObjectAtIndex:end];
        end--;
    }
    return arr;
}

@end
