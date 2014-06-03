//
//  Utility.m
//  DDZ_Algorithm
//
//  Created by PeterZhou on 14-5-30.
//  Copyright (c) 2014年 PeterZhou. All rights reserved.
//

#import "Utility.h"

#define DEFAULT_ROTATION 6

@implementation Utility

+ (Utility *)sharedInstance{
    static Utility *_sharedInstance = nil;
    dispatch_once_t _once;
    dispatch_once(&_once, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

- (id)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}

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
        end--;
    }
    return f_str;
}

+ (int)getRotation:(NSString *)string{
    int rotation = DEFAULT_ROTATION;
    if (rotation<string.length) {
        rotation = (int)string.length-1;
    }
    for (int i = 0; i<string.length; i++) {
        NSString *c = [string substringWithRange:NSMakeRange(i, 1)];
        BOOL isNum = [c isPureInt];
        if (isNum) {
            return i;
        }
        else{
            continue;
        }
    }
    return rotation;
}



@end
