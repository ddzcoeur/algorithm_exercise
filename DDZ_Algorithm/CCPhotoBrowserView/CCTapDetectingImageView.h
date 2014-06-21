//
//  CCTapDetectingImageView.h
//  CocoVoice
//
//  Created by PeterZhou on 14-5-8.
//
//

#import <UIKit/UIKit.h>

@protocol CCTapDetectingImageViewDelegate;

@interface CCTapDetectingImageView : UIImageView

@property (nonatomic, weak) id <CCTapDetectingImageViewDelegate> tapDelegate;

@end

@protocol CCTapDetectingImageViewDelegate <NSObject>

@optional

- (void)imageView:(UIImageView *)imageView singleTapDetected:(UITouch *)touch;
- (void)imageView:(UIImageView *)imageView doubleTapDetected:(UITouch *)touch;
- (void)imageView:(UIImageView *)imageView tripleTapDetected:(UITouch *)touch;

@end