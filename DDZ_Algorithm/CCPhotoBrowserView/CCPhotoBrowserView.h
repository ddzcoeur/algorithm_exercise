//
//  CCPhotoBrowserView.h
//  Coco
//
//  Created by PeterZhou on 14-6-18.
//  Copyright (c) 2014年 Instanza Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCPhoto.h"
#import "CCTapDetectingImageView.h"
#import "CCTapDetectView.h"
#import "CCZoomingScrollView.h"

@class CCPhotoBrowserView;

@protocol CCPhotoBrowserDataSource <NSObject>

@required
- (int)numberOfImageInBrowserView:(CCPhotoBrowserView *)browserView;
- (CCPhoto *)imageForIndex:(int)imageIndex;

@end

@protocol CCPhotoBrowserDelegate <NSObject>


@end

@interface CCPhotoBrowserView : UIView<UIScrollViewDelegate>

@property (nonatomic, weak) id<CCPhotoBrowserDataSource> datasource;

- (id)initWithFrame:(CGRect)frame DataSource:(id<CCPhotoBrowserDataSource>)datasource;
- (void)reloadAll;
- (void)addImageAtIndex:(int)index;
- (void)removeImageAtIndex:(int)index;
- (void)reloadImageAtIndex:(int)index;


@end


