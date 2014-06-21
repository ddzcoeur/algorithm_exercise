//
//  CCZoomingScrollView.h
//  CocoVoice
//
//  Created by PeterZhou on 14-5-8.
//
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "CCTapDetectingImageView.h"
#import "CCTapDetectView.h"
#import "CCPhoto.h"


@interface CCZoomingScrollView : UIScrollView<UIScrollViewDelegate, CCTapDetectingImageViewDelegate, CCTapDetectingViewDelegate>

@property (nonatomic) int currentIndex;
@property (nonatomic, strong) CCPhoto *currentPhoto;

- (id)initWithPhoto:(CCPhoto *)photo andFrame:(CGRect)frame;
- (void)setViewPhoto:(CCPhoto *)photo;
- (void)prepareForReuse;
- (void)setMaxZoom:(int)maxZoom;

@end
