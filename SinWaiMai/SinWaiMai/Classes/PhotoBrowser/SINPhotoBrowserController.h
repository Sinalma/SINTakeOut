//
//  SINPhotoBrowserController.h
//  SinWaiMai
//
//  Created by apple on 15/05/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//

typedef enum : NSUInteger {
    KPBGestureTap,
    KPBGestureDoubleTap,
    KPBGesturePinch,
    KPBGestureRotation,
    KPBGestureLongPress
} PBGestureTypes;

#import <UIKit/UIKit.h>

@interface SINPhotoBrowserController : UIViewController

@property (nonatomic,strong) NSArray *imageUrls;

@property (nonatomic,strong) NSArray *imageNames;

@property (nonatomic,assign) NSInteger index;

@property (nonatomic,strong) NSString *typeTitle;

/** 长按，具有保存到相册的功能 */
@property (nonatomic,assign) BOOL isSupportLongpress;
/** 旋转 */
@property (nonatomic,assign) BOOL isSupportRotation;
/** 捏合,默认只支持捏合手势，可取消*/
@property (nonatomic,assign) BOOL isSuportPinch;
/** 单击，复位 */
@property (nonatomic,assign) BOOL isSupportTap;
/** 双击，放大 */
@property (nonatomic,assign) BOOL isSupportDoubleTap;


@end
