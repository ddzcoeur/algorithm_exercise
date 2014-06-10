//
//  Sorts.m
//  DDZ_Algorithm
//
//  Created by PeterZhou on 14-6-10.
//  Copyright (c) 2014年 PeterZhou. All rights reserved.
//

#import "Sorts.h"

@implementation Sorts

+ (NSArray *)quickSortWithArray:(NSArray *)arr{
    NSMutableArray *arr_after_sort = [NSMutableArray arrayWithArray:arr];
    [Sorts startSort:arr_after_sort low:0 up:(int)arr_after_sort.count];
    
    return arr_after_sort;
}

+ (void)startSort:(NSMutableArray *)arr low:(int)low up:(int)up{
    if (low<up) {
        int mid = [Sorts partitionAnotherWay:arr low:low up:up];
        [Sorts startSort:arr low:0 up:mid];
        [Sorts startSort:arr low:mid+1 up:up];
    }
}

+ (int)partition:(NSMutableArray *)arr low:(int)low up:(int)up{
    int mid = low;
    int pivot = [[arr objectAtIndex:up-1] intValue];
    for (int i = mid+1; i<up; i++) {
        int sort = [[arr objectAtIndex:i] intValue];
        if (sort<=pivot) {
            mid++;
            [arr exchangeObjectAtIndex:mid withObjectAtIndex:i];
        }
    }
    if ([[arr objectAtIndex:mid] intValue]>pivot) {
        [arr exchangeObjectAtIndex:mid withObjectAtIndex:up-1];
    }

    return mid;
}

+ (int)partitionAnotherWay:(NSMutableArray *)arr low:(int)low up:(int)up{
    int mid = low;
    int pivot = [[arr objectAtIndex:up-1] intValue];

    while (mid<up-1) {
        NSLog( @"%d to %d",low,up);
        int i = [[arr objectAtIndex:mid] intValue];

        if (i>pivot) {
            [arr exchangeObjectAtIndex:mid withObjectAtIndex:up-1];
            up--;
        }
        int j = [[arr objectAtIndex:up-1] intValue];
        if (j<pivot) {
            [arr exchangeObjectAtIndex:mid withObjectAtIndex:up-1];
            
        }
        mid++;

    }
    return mid;
}

@end
