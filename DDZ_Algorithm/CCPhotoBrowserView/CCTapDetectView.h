//
//  CCTapDetectView.h
//  CocoVoice
//
//  Created by PeterZhou on 14-5-8.
//
//

#import <UIKit/UIKit.h>
@protocol CCTapDetectingViewDelegate;

@interface CCTapDetectView : UIView

@property (nonatomic, weak) id <CCTapDetectingViewDelegate> tapDelegate;

@end

@protocol CCTapDetectingViewDelegate <NSObject>

@optional

- (void)view:(UIView *)view singleTapDetected:(UITouch *)touch;
- (void)view:(UIView *)view doubleTapDetected:(UITouch *)touch;
- (void)view:(UIView *)view tripleTapDetected:(UITouch *)touch;

@end