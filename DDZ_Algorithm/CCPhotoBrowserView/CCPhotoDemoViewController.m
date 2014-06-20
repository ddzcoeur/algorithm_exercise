//
//  CCPhotoDemoViewController.m
//  Coco
//
//  Created by PeterZhou on 14-6-18.
//  Copyright (c) 2014年 Instanza Inc. All rights reserved.
//

#import "CCPhotoDemoViewController.h"


@interface CCPhotoDemoViewController ()

@property (nonatomic, strong) CCPhotoBrowserView *photoBrowser;

@end

@implementation CCPhotoDemoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.photoBrowser = [[CCPhotoBrowserView alloc] initWithFrame:self.view.bounds DataSource:self];
    [self.view addSubview:self.photoBrowser];
}

- (void)viewWillLayoutSubviews{
    self.photoBrowser.frame = self.view.bounds;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ccphotobrowserdelegate
- (int)numberOfImageInBrowserView:(CCPhotoBrowserView *)browserView{
    return 2;
}

- (CCPhoto *)imageForIndex:(int)imageIndex{
    if (imageIndex == 0) {
        CCPhoto *p = [[CCPhoto alloc] init];
        p.prevImage = kCommonImageBackgroundLoadingUIImg;
        p.fullImageUrl = @"http://fs0.139js.com/file/s_jpg_64dc0bffgw1dysmq1lyvmj.jpg";
        return p;
    }
    else{
        CCPhoto *p = [[CCPhoto alloc] init];
        p.originImage = kCommonTestUIImg;
        p.prevImage = kCommonImageBackgroundLoadingUIImg;
        p.fullImageUrl = @"http://ftp.ytbbs.com/attachments/album/201203/05/18414888t8au9o7qogpe89.jpg";
        return p;
    }
    return nil;
}

@end
