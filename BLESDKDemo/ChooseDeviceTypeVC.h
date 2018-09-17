//
//  ChooseDeviceTypeVC.h
//  BLESDKDemo
//
//  Created by Martin on 14/9/18.
//  Copyright © 2018年 medica. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChooseDeviceTypeVC : UIViewController

@end

@interface DeviceInfo: NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) int deviceType;

+ (DeviceInfo *)deviceInfoWith:(NSString *)title deviceType:(int)deviceType;
@end
