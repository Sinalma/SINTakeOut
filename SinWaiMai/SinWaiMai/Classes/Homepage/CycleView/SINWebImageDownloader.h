//
//  SINWebImageDownloader.h
//  SINCycleView
//
//  Created by apple on 30/04/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SINWebImageDownloaderCompletedBlock)(UIImage *image, NSData *data, NSError *error, BOOL finished);
@interface SINWebImageDownloader : NSObject

@property (nonatomic,assign) SINWebImageDownloaderCompletedBlock completeBlock;

+ (instancetype)sharedDownloader;

- (void)downloadImageWithURL:(NSURL *)url completed:(SINWebImageDownloaderCompletedBlock)completedBlock;

@end
