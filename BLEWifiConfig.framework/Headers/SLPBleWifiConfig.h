//
//  SLPBleWifiConfig.h
//  SDK
//
//  Created by Martin on 2018/1/25.
//  Copyright © 2018年 Martin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BluetoothManager/BluetoothManager.h>

@class CBPeripheral;
@interface SLPBleWifiConfig : NSObject

- (void)configPeripheral:(CBPeripheral *)peripheral deviceType:(SLPDeviceTypes)deviceType
           serverAddress:(NSString *)address port:(NSInteger)port
                wifiName:(NSString *)name
                password:(NSString *)password
              completion:(void(^)(BOOL succeed, id data))completion;

- (void)configPeripheral:(CBPeripheral *)peripheral deviceType:(SLPDeviceTypes)deviceType
                wifiName:(NSString *)name
                password:(NSString *)password
              completion:(void(^)(BOOL succeed, id data))completion;


@end
