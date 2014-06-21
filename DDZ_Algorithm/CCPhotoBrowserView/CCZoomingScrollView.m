//
//  CCZoomingScrollView.m
//  CocoVoice
//
//  Created by PeterZhou on 14-5-8.
//
//

#import "CCZoomingScrollView.h"

@interface CCZoomingScrollView(){
    CCTapDetectingImageView *_photoImageView;
    CCTapDetectView *_tapView;
}

@property (nonatomic) int maxScale;

@end

@implementation CCZoomingScrollView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configure];
    }
    return self;
}



- (id)initWithPhoto:(CCPhoto *)photo andFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        // Tap view for background
		[self configure];
        [self setViewPhoto:photo];
    }
    return self;
}

#pragma mark - configure
- (void)configure{
    _tapView = [[CCTapDetectView alloc] initWithFrame:self.bounds];
    _tapView.tapDelegate = self;
    _tapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _tapView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_tapView];
    
    // Image view
    _photoImageView = [[CCTapDetectingImageView alloc] initWithFrame:CGRectZero];
    _photoImageView.tapDelegate = self;
    _photoImageView.contentMode = UIViewContentModeCenter;
    _photoImageView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_photoImageView];
    //maxscale
    [self setMaxScale:2];
    // Setup
    self.backgroundColor = [UIColor whiteColor];
    self.delegate = self;
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    self.decelerationRate = UIScrollViewDecelerationRateFast;
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}

- (void)prepareForReuse {
    self.currentPhoto = nil;
    _photoImageView.image = nil;
    _currentIndex = NSUIntegerMax;
}

- (void)setMaxZoom:(int)maxZoom{
    self.maxScale = maxZoom;
}
#pragma mark - Image
- (UIImage *)getImageFromCache:(NSString *)imageUrl{
    UIImage *o_image = nil;
    o_image = [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:imageUrl];
    if (!o_image) {
        o_image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:imageUrl];
    }
    return o_image;
}

- (void)setViewPhoto:(CCPhoto *)photo{
    self.backgroundColor = [UIColor whiteColor];
    self.currentPhoto = photo;
    UIImage *originImage = [self getImageFromCache:photo.fullImageUrl];
    if (originImage) {
        self.currentPhoto.originImage = originImage;
    }
    if (photo.originImage) {
        [self displayImage:photo.originImage];
    }
    else{
        [self displayURLImage:photo.fullImageUrl];
    }
    
}

- (void)displayURLImage:(NSString *)originImageUrl{
    self.maximumZoomScale = 1;
    self.minimumZoomScale = 1;
    self.zoomScale = 1;
    self.contentSize = CGSizeMake(0, 0);
    
    // Get image from browser as it handles ordering of fetching
    if (originImageUrl) {
        
        // Hide indicator
        
        // Set image
        UIImage *prevImage = self.currentPhoto.prevImage;
        if (!prevImage) {
            prevImage = kCommonImageBackgroundLoadingUIImg;
        }
        __typeof(self) __weak wself = self;
        [_photoImageView setImageWithURL2:[NSURL URLWithString:originImageUrl] placeholderImage:prevImage options:SDWebImageRetryFailed progress:^(NSUInteger receiveSize,long long expectedSize){
            
        }
                                completed:^(UIImage *image, NSError *error, SDImageCacheType type){
            if (image) {
                wself.currentPhoto.originImage = image;
                [wself displayImage:image];
            }
            else{
                [wself displayImageFailure];
            }
        }];
        _photoImageView.hidden = NO;
        
        // Setup photo frame
        CGRect photoImageViewFrame;
        photoImageViewFrame.origin = CGPointZero;
        photoImageViewFrame.size = prevImage.size;
        _photoImageView.frame = photoImageViewFrame;
        self.contentSize = photoImageViewFrame.size;
        
        // Set zoom to minimum zoom
        [self setMaxMinZoomScalesForCurrentBounds];
        
    } else {
        
        // Failed no image
        [self displayImageFailure];
        
    }
    [self setNeedsLayout];
}

- (void)displayImage:(UIImage *)prevImage{
    self.maximumZoomScale = 1;
    self.minimumZoomScale = 1;
    self.zoomScale = 1;
    self.contentSize = CGSizeMake(0, 0);
    
    // Get image from browser as it handles ordering of fetching
    if (prevImage) {
        
        // Hide indicator
        
        // Set image
        _photoImageView.image = prevImage;
        _photoImageView.hidden = NO;
        
        // Setup photo frame
        CGRect photoImageViewFrame;
        photoImageViewFrame.origin = CGPointZero;
        photoImageViewFrame.size = prevImage.size;
        _photoImageView.frame = photoImageViewFrame;
        self.contentSize = photoImageViewFrame.size;
        
        // Set zoom to minimum zoom
        [self setMaxMinZoomScalesForCurrentBounds];
        
    } else {
        
        // Failed no image
        [self displayImageFailure];
        
    }
    [self setNeedsLayout];

}

- (void)displayImageFailure {
    
}

#pragma mark - ScrollView Delegate
- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view {
    self.scrollEnabled = YES; // reset
}
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return _photoImageView;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale{
    CCLog(@"scale:%.2f",scale);
}

#pragma mark - setup
- (CGFloat)initialZoomScaleWithMinScale {
    CGFloat zoomScale = self.minimumZoomScale;
    if (_photoImageView) {
        // Zoom image to fill if the aspect ratios are fairly similar
        CGSize boundsSize = self.bounds.size;
        CGSize imageSize = _photoImageView.image.size;
        CGFloat boundsAR = boundsSize.width / boundsSize.height;
        CGFloat imageAR = imageSize.width / imageSize.height;
        CGFloat xScale = boundsSize.width / imageSize.width;    // the scale needed to perfectly fit the image width-wise
        CGFloat yScale = boundsSize.height / imageSize.height;  // the scale needed to perfectly fit the image height-wise
        // Zooms standard portrait images on a 3.5in screen but not on a 4in screen.
        if (ABS(boundsAR - imageAR) < 0.17) {
            zoomScale = MAX(xScale, yScale);
            // Ensure we don't zoom in or out too far, just in case
            zoomScale = MIN(MAX(self.minimumZoomScale, zoomScale), self.maximumZoomScale);
        }
    }
    return zoomScale;
}

- (void)setMaxMinZoomScalesForCurrentBounds {
	
	// Reset
	self.maximumZoomScale = 1;
	self.minimumZoomScale = 1;
	self.zoomScale = 1;
	
	// Bail if no image
	if (_photoImageView.image == nil) return;
    
	// Reset position
	_photoImageView.frame = CGRectMake(0, 0, _photoImageView.frame.size.width, _photoImageView.frame.size.height);
	
	// Sizes
    CGSize boundsSize = self.bounds.size;
    CGSize imageSize = _photoImageView.image.size;
    
    // Calculate Min
    CGFloat xScale = boundsSize.width / imageSize.width;    // the scale needed to perfectly fit the image width-wise
    CGFloat yScale = boundsSize.height / imageSize.height;  // the scale needed to perfectly fit the image height-wise
    CGFloat minScale = MIN(xScale, yScale);                 // use minimum of these to allow the image to become fully visible
    
    // Calculate Max
	CGFloat maxScale = self.maxScale;
//    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
//        // Let them go a bit bigger on a bigger screen!
//        maxScale = 4;
//    }
    
    // Image is smaller than screen so no zooming!
	if (xScale >= 1 && yScale >= 1) {
		minScale = 1.0;
	}
	
	// Set min/max zoom
	self.maximumZoomScale = maxScale;
    if (minScale == 0) {
        minScale = 1.0f;
    }
	self.minimumZoomScale = minScale;
    
    // Initial zoom
    self.zoomScale = [self initialZoomScaleWithMinScale];
    
    // If we're zooming to fill then centralise
    if (self.zoomScale != minScale) {
        self.contentOffset = CGPointMake((imageSize.width * self.zoomScale - boundsSize.width) / 2.0,
                                         (imageSize.height * self.zoomScale - boundsSize.height) / 2.0);
        self.scrollEnabled = NO;
    }
    
    // Layout
	[self setNeedsLayout];
    
}

#pragma mark - layout
- (void)layoutSubviews {
	_tapView.frame = self.bounds;
	[super layoutSubviews];
	
    // Center the image as it becomes smaller than the size of the screen
    CGSize boundsSize = self.bounds.size;
    CGRect frameToCenter = _photoImageView.frame;
    
    // Horizontally
    if (frameToCenter.size.width < boundsSize.width) {
        frameToCenter.origin.x = floorf((boundsSize.width - frameToCenter.size.width) / 2.0);
	} else {
        frameToCenter.origin.x = 0;
	}
    
    // Vertically
    if (frameToCenter.size.height < boundsSize.height) {
        frameToCenter.origin.y = floorf((boundsSize.height - frameToCenter.size.height) / 2.0);
	} else {
        frameToCenter.origin.y = 0;
	}
    
	// Center
	if (!CGRectEqualToRect(_photoImageView.frame, frameToCenter))
		_photoImageView.frame = frameToCenter;
	
}

#pragma mark - Tap Detection

- (void)handleSingleTap:(CGPoint)touchPoint {
//	[_photoBrowser performSelector:@selector(toggleControls) withObject:nil afterDelay:0.2];
}

- (void)handleDoubleTap:(CGPoint)touchPoint {
	
	// Cancel any single tap handling
	
	// Zoom
	if (self.zoomScale != self.minimumZoomScale && self.zoomScale != [self initialZoomScaleWithMinScale]) {
		
		// Zoom out
		[self setZoomScale:self.minimumZoomScale animated:YES];
		
	} else {
		
		// Zoom in to twice the size
        CGFloat newZoomScale = ((self.maximumZoomScale + self.minimumZoomScale) / 2);
        CGFloat xsize = self.bounds.size.width / newZoomScale;
        CGFloat ysize = self.bounds.size.height / newZoomScale;
        [self zoomToRect:CGRectMake(touchPoint.x - xsize/2, touchPoint.y - ysize/2, xsize, ysize) animated:YES];
        
	}
}

// Image View
- (void)imageView:(UIImageView *)imageView singleTapDetected:(UITouch *)touch {
    [self handleSingleTap:[touch locationInView:imageView]];
}
- (void)imageView:(UIImageView *)imageView doubleTapDetected:(UITouch *)touch {
    [self handleDoubleTap:[touch locationInView:imageView]];
}

// Background View
- (void)view:(UIView *)view singleTapDetected:(UITouch *)touch {
    // Translate touch location to image view location
    CGFloat touchX = [touch locationInView:view].x;
    CGFloat touchY = [touch locationInView:view].y;
    touchX *= 1/self.zoomScale;
    touchY *= 1/self.zoomScale;
    touchX += self.contentOffset.x;
    touchY += self.contentOffset.y;
    [self handleSingleTap:CGPointMake(touchX, touchY)];
}
- (void)view:(UIView *)view doubleTapDetected:(UITouch *)touch {
    // Translate touch location to image view location
    CGFloat touchX = [touch locationInView:view].x;
    CGFloat touchY = [touch locationInView:view].y;
    touchX *= 1/self.zoomScale;
    touchY *= 1/self.zoomScale;
    touchX += self.contentOffset.x;
    touchY += self.contentOffset.y;
    [self handleDoubleTap:CGPointMake(touchX, touchY)];
}


@end
