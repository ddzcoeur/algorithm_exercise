//
//  CCTapDetectView.m
//  CocoVoice
//
//  Created by PeterZhou on 14-5-8.
//
//

#import "CCTapDetectView.h"

@implementation CCTapDetectView

- (void)dealloc{
    self.tapDelegate = nil;
}

- (id)init {
	if ((self = [super init])) {
		self.userInteractionEnabled = YES;
	}
	return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [touches anyObject];
	NSUInteger tapCount = touch.tapCount;
	switch (tapCount) {
		case 1:
			[self handleSingleTap:touch];
			break;
		case 2:
			[self handleDoubleTap:touch];
			break;
		case 3:
			[self handleTripleTap:touch];
			break;
		default:
			break;
	}
	[[self nextResponder] touchesEnded:touches withEvent:event];
}

- (void)handleSingleTap:(UITouch *)touch {
	if ([_tapDelegate respondsToSelector:@selector(view:singleTapDetected:)]&&_tapDelegate)
		[_tapDelegate view:self singleTapDetected:touch];
}

- (void)handleDoubleTap:(UITouch *)touch {
	if ([_tapDelegate respondsToSelector:@selector(view:doubleTapDetected:)]&&_tapDelegate)
		[_tapDelegate view:self doubleTapDetected:touch];
}

- (void)handleTripleTap:(UITouch *)touch {
	if ([_tapDelegate respondsToSelector:@selector(view:tripleTapDetected:)]&&_tapDelegate)
		[_tapDelegate view:self tripleTapDetected:touch];
}


@end
