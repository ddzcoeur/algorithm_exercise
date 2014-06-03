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

+ (NSString *)rotationArrayWithRotaionPosition:(int)position string:(NSString *)str{
    int end = (int)str.length-1;
    NSString *s1_str = [Utility rotationWithRotation:0 endPosition:position-1 string:str];
    NSString *s2_str = [Utility rotationWithRotation:position endPosition:end string:s1_str];
    NSString *f_str = [Utility rotationWithRotation:0 endPosition:end string:s2_str];
    return f_str;
}

+ (NSString *)rotationWithRotation:(int)i endPosition:(int)end string:(NSString *)str{
    NSMutableString *f_str = [NSMutableString stringWithString:str];
    for (int j = i; j<end; j++) {
        NSRange b_range = NSMakeRange(j,1);
        NSRange e_range = NSMakeRange(end, 1);
        NSString *b_str = [f_str substringWithRange:b_range];
        NSString *e_str = [f_str substringWithRange:e_range];
        [f_str replaceCharactersInRange:e_range withString:b_str];
        [f_str replaceCharactersInRange:b_range withString:e_str];
//        [arr exchangeObjectAtIndex:j withObjectAtIndex:end];
        end--;
    }
    return f_str;
}

@end
