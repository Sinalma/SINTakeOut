//
//  SINQRCodeShowController.h
//  QRCode
//
//  Created by apple on 22/04/2017.
//  Copyright © 2017 sinalma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SINQRCodeShowController : UIViewController

/** 条形码信息 */
@property (nonatomic,strong) NSString *Bar_code;
/** 二维码信息 */
@property (nonatomic,strong) NSString *QR_code;

@end
