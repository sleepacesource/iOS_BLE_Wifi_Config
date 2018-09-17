//
//  ConfigureWiFiViewController.h
//  WiFiSDKDemo
//
//  Created by San on 2018/1/25.
//  Copyright © 2018年 medica. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BLEWifiConfig/SLPBleWifiConfig.h>

@interface ConfigureWiFiViewController : UIViewController
@property (nonatomic, assign) SLPDeviceTypes deviceType;
@property (nonatomic, copy) NSString *serverAddress;
@property (nonatomic, assign) int port;
@end
