//
//  ChooseDeviceTypeVC.m
//  BLESDKDemo
//
//  Created by Martin on 14/9/18.
//  Copyright © 2018年 medica. All rights reserved.
//

#import "ChooseDeviceTypeVC.h"
#import <BLEWifiConfig/SLPBleWifiConfig.h>
#import "SetServerViewController.h"

@interface ChooseDeviceTypeVC ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) NSArray<DeviceInfo *> *deviceInfoList;
@end

@implementation ChooseDeviceTypeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.titleLabel setText:@"Choose device"];
    self.deviceInfoList =
    @[
      [DeviceInfo deviceInfoWith:@"Z300" deviceType:SLPDeviceType_WIFIReston],
      [DeviceInfo deviceInfoWith:@"EW201W" deviceType:SLPDeviceType_EW201W],
      [DeviceInfo deviceInfoWith:@"SA1001" deviceType:SLPDeviceType_Sal],
      [DeviceInfo deviceInfoWith:@"M800" deviceType:SLPDeviceType_M800]
      ];
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.deviceInfoList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    DeviceInfo *info = [self.deviceInfoList objectAtIndex:indexPath.row];
    [cell.textLabel setText:info.title];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DeviceInfo *info = [self.deviceInfoList objectAtIndex:indexPath.row];
    SetServerViewController *vc = [[SetServerViewController alloc] initWithNibName:@"SetServerViewController" bundle:nil];
    vc.deviceType = info.deviceType;
    [self.navigationController pushViewController:vc animated:YES];
}
@end

@implementation DeviceInfo
+ (DeviceInfo *)deviceInfoWith:(NSString *)title deviceType:(int)deviceType {
    DeviceInfo *info = [DeviceInfo new];
    [info setTitle:title];
    [info setDeviceType:deviceType];
    return info;
}
@end
