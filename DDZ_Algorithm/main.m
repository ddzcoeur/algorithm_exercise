//
//  main.m
//  DDZ_Algorithm
//
//  Created by PeterZhou on 14-5-30.
//  Copyright (c) 2014年 PeterZhou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Utility.h"



int main(int argc, const char * argv[])
{

    @autoreleasepool {
        NSMutableArray *ar = [NSMutableArray arrayWithObjects:@"a",@"b",@"c",@"d",@"e",@"f",@"g",@"h",@"i", nil];
        NSArray *ar_rotation = [Utility rotationArrayWithRotaionPosition:7 Array:ar];
        // insert code here...
        for (int i = 0; i<ar_rotation.count; i++) {
            NSLog(@"%@ ",[ar_rotation objectAtIndex:i]);
        }
        
        NSString *str = @"abcdefghi";
        NSString *f_str = [Utility rotationArrayWithRotaionPosition:4 string:str];
        NSLog(@"final str:%@",f_str);
    }
    return 0;
}

