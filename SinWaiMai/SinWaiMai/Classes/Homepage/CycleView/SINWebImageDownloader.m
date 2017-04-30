//
//  SINWebImageDownloader.m
//  SINCycleView
//
//  Created by apple on 30/04/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//

#import "SINWebImageDownloader.h"
#import "SDWebImageDownloader.h"

static SINWebImageDownloader *_downloader;
@implementation SINWebImageDownloader
+ (instancetype)sharedDownloader
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _downloader = [[self alloc] init];
    });
    return _downloader;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _downloader = [super allocWithZone:zone];
    });
    return _downloader;
}

- (id)copyWithZone:(NSZone *)zone
{
    return _downloader;
}

- (void)downloadImageWithURL:(NSURL *)url completed:(SINWebImageDownloaderCompletedBlock)completedBlock
{
    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:url options:SDWebImageDownloaderHighPriority progress:nil completed:completedBlock];
}

@end
