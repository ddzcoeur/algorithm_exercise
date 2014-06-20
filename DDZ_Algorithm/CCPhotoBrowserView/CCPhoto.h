//
//  CCPhoto.h
//  CocoVoice
//
//  Created by PeterZhou on 14-5-14.
//
//

#import <Foundation/Foundation.h>

@interface CCPhoto : NSObject

@property (nonatomic, strong) UIImage *prevImage;
@property (nonatomic, strong) NSString *fullImageUrl;
@property (nonatomic, strong) UIImage *originImage;

@end
