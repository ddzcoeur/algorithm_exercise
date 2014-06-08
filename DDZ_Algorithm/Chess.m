//
//  Chess.m
//  DDZ_Algorithm
//
//  Created by Ayasofya on 14-6-8.
//  Copyright (c) 2014年 PeterZhou. All rights reserved.
//

#import "Chess.h"

@implementation Chess

+ (void)chess{
    for (int i = 0; i<9; i++) {
        for (int j = 0; j<9; j++) {
            if (i%3 != j%3) {
                NSLog(@"A = %d, B = %d",i+1,j+1);
            }
        }
    }
}

@end
