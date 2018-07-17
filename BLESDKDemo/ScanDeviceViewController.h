//
//  ScanDeviceViewController.h
//  RestonSDKDemo
//
//  Created by San on 2017/7/25.
//  Copyright © 2017年 medica. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BluetoothManager/BluetoothManager.h>

@protocol ScanDeviceDelegate <NSObject>

- (void)didSelectPeripheal:(SLPPeripheralInfo *)peripheralInfo;

@end

@interface ScanDeviceViewController : UIViewController

@property (nonatomic,weak) id<ScanDeviceDelegate> delegate;

@end
