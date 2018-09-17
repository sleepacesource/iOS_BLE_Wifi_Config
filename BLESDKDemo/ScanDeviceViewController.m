//
//  ScanDeviceViewController.m
//  RestonSDKDemo
//
//  Created by San on 2017/7/25.
//  Copyright © 2017年 medica. All rights reserved.
//

#import "ScanDeviceViewController.h"

//#import "Tool.h"

@interface ScanDeviceViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *deviceArray;
}
@property (weak, nonatomic) IBOutlet UIButton *refreshButton;
@property (weak, nonatomic) IBOutlet UITableView *myTableview;
@property (nonatomic,strong) NSMutableArray *deviceList;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@end

@implementation ScanDeviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setUI];
}

- (void)setUI
{
    self.myTableview.delegate=self;
    self.myTableview.dataSource=self;
    deviceArray =[[NSMutableArray alloc]initWithCapacity:0];
    self.label1.text=NSLocalizedString(@"search_device", nil);
    self.label2.text=NSLocalizedString(@"select_device_id", nil);
    self.label3.text=NSLocalizedString(@"refresh_deviceid_list", nil);
    self.textView.layer.borderWidth=1.0f;
    self.textView.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.textView.layer.cornerRadius=2.0f;
    
    BOOL isOpen=[SLPBLESharedManager blueToothIsOpen];
    [self performSelector:@selector(pressRefresh:) withObject:nil afterDelay:1.0f];
    [self openBle];
}


- (void)openBle
{
    if (![SLPBLESharedManager blueToothIsOpen]) {
        NSString *message = NSLocalizedString(@"require_ble", nil);
        UIAlertView *alertview =[[ UIAlertView alloc]initWithTitle:nil message:message delegate:self cancelButtonTitle:NSLocalizedString(@"btn_ok", nil) otherButtonTitles: nil];
        [alertview show];
        return ;
    }
}

- (IBAction)back:(id)sender {
    [SLPBLESharedManager stopAllPeripheralScan];
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewWillAppear:(BOOL)animated
{
//    self.navigationController.navigationBar.hidden=NO;
    
}


- (IBAction)pressRefresh:(id)sender
{
//    if (![Tool bleIsOpenShowToTextview:self.textView]) {
//        return ;
//    }
//
    [SLPBLESharedManager stopAllPeripheralScan];
    if (deviceArray) {
        [deviceArray removeAllObjects];
    }
    [SLPBLESharedManager scanBluetoothWithTimeoutInterval:10.0 completion:^(SLPBLEScanReturnCodes code, NSInteger handleID, SLPPeripheralInfo *peripheralInfo) {
        NSLog(@"scan device>>:%@",peripheralInfo.name);
        int i=0;
        while (i<deviceArray.count) {
            SLPPeripheralInfo *devInfo=(SLPPeripheralInfo*)[deviceArray objectAtIndex:i++];
            if (devInfo.name&&[devInfo.name isEqualToString:peripheralInfo.name]) {
                return ;
            }
        }
        if (peripheralInfo.name&&peripheralInfo.name.length) {
            [deviceArray addObject:peripheralInfo];
            [self.myTableview reloadData];
        }
    }];
}

- (void)selectDevice:(NSIndexPath *)indexPath
{
    [SLPBLESharedManager stopAllPeripheralScan];
    SLPPeripheralInfo *deviceInfo=(SLPPeripheralInfo*)deviceArray[indexPath.row];
    if (self.delegate&&[self.delegate respondsToSelector:@selector(didSelectPeripheal:)]) {
        [self.delegate didSelectPeripheal:deviceInfo];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark -UITableViewDelegate & UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return deviceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellWithIdentifier = @"cellWithIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellWithIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellWithIdentifier];
    }
    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.backgroundColor = [UIColor clearColor];
    SLPPeripheralInfo *deviceInfo=(SLPPeripheralInfo*)deviceArray[indexPath.row];
    cell.textLabel.text=deviceInfo.name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self selectDevice:indexPath];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
