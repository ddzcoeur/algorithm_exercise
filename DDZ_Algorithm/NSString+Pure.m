//
//  NSString+Pure.m
//  DDZ_Algorithm
//
//  Created by Ayasofya on 14-6-3.
//  Copyright (c) 2014年 PeterZhou. All rights reserved.
//

#import "NSString+Pure.h"

@implementation NSString (Pure)

- (BOOL)isPureInt{
    
    NSScanner* scan = [NSScanner scannerWithString:self];
    
    int val;
    
    return[scan scanInt:&val] && [scan isAtEnd];
    
}

@end
