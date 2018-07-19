//
//  ConfigureWiFiViewController.m
//  WiFiSDKDemo
//
//  Created by San on 2018/1/25.
//  Copyright © 2018年 medica. All rights reserved.
//

#import "ConfigureWiFiViewController.h"
#import "ScanDeviceViewController.h"
#import <BLEWifiConfig/SLPBleWifiConfig.h>
#import "MBProgressHUD.h"

@interface ConfigureWiFiViewController ()<ScanDeviceDelegate,UITextFieldDelegate>
{
    SLPPeripheralInfo *currentPer;
    SLPBleWifiConfig *con;
}
@property (nonatomic,weak) IBOutlet UILabel *titleLabel;
@property (nonatomic,weak) IBOutlet UILabel *label1;
@property (nonatomic,weak) IBOutlet UILabel *label2;
@property (nonatomic,weak) IBOutlet UILabel *label3;
@property (nonatomic,weak) IBOutlet UILabel *label4;
@property (nonatomic,weak) IBOutlet UILabel *label5;
@property (nonatomic,weak) IBOutlet UILabel *label6;
@property (nonatomic,weak) IBOutlet UILabel *label7;
@property (nonatomic,weak) IBOutlet UILabel *label8;
@property (nonatomic,weak) IBOutlet UITextField *textfield1;
@property (nonatomic,weak) IBOutlet UITextField *textfield2;
@property (nonatomic,weak) IBOutlet UITextField *textfield3;
@property (nonatomic,weak) IBOutlet UITextField *textfield4;
@property (nonatomic,weak) IBOutlet UIButton *configureBT;
@property (nonatomic,weak) IBOutlet  UIView *view1;

@end

@implementation ConfigureWiFiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setUI];
    
    con= [[SLPBleWifiConfig alloc]init];
}


- (void)setUI
{
    self.titleLabel.text = NSLocalizedString(@"device_name_z300", nil);
    self.label1.text = NSLocalizedString(@"step1", nil);
    self.label2.text = NSLocalizedString(@"select_device", nil);
    self.label3.text = NSLocalizedString(@"select_device", nil);
//    self.label4.text = @"设备连接的WiFi";
    self.label5.text = NSLocalizedString(@"step3", nil);
    self.label6.text = NSLocalizedString(@"select_wifi", nil);
    self.label7.text = NSLocalizedString(@"step2", nil);
    self.label8.text = NSLocalizedString(@"设备要连接的地址和端口", nil);
    
    [self.configureBT setTitle:NSLocalizedString(@"pair_wifi", nil) forState:UIControlStateNormal];
    self.configureBT.layer.cornerRadius =25.0f;
    
    self.view1.layer.cornerRadius = 4.0f;
    self.view1.layer.borderColor = [UIColor colorWithRed:195/255.0 green:203/255.0f blue:214/255.0f alpha:1.0].CGColor;
    self.view1.layer.borderWidth = 1.0f;
    
    self.textfield1.placeholder = NSLocalizedString(@"input_wifi_name", nil);
    self.textfield2.placeholder = NSLocalizedString(@"input_wifi_psw", nil);
    
    [self refreshServerAddressAndPort];

    self.textfield1.delegate = self;
    self.textfield2.delegate = self;
    self.textfield3.delegate=self;
    self.textfield4.delegate=self;
//    self.textfield1.text = @"medica_2";
//    self.textfield2.text = @"11221122";
}

- (void)refreshServerAddressAndPort
{
    self.textfield3.text = [self backAddressFromID];
    self.textfield4.text = [NSString stringWithFormat:@"%ld",(long)[self backPortFromID]];
}

- (IBAction)pushToSelectDeviceView:(id)sender {
     [self resignTextfiled];
    ScanDeviceViewController *scanVC = [[ScanDeviceViewController alloc]initWithNibName:@"ScanDeviceViewController" bundle:nil];
    scanVC.delegate = self;
    [self.navigationController pushViewController:scanVC animated:YES];
}

- (IBAction)configureAction:(id)sender {
    
    if (![SLPBLESharedManager blueToothIsOpen]) {
        NSString *message = NSLocalizedString(@"reminder_connect_ble", nil);
        UIAlertView *alertview =[[ UIAlertView alloc]initWithTitle:nil message:message delegate:self cancelButtonTitle:NSLocalizedString(@"btn_ok", nil) otherButtonTitles: nil];
        [alertview show];
        return ;
    }
    if (!self.label4.text.length) {
        NSString *message = NSLocalizedString(@"select_device", nil);
        UIAlertView *alertview =[[ UIAlertView alloc]initWithTitle:nil message:message delegate:self cancelButtonTitle:NSLocalizedString(@"btn_ok", nil) otherButtonTitles: nil];
        [alertview show];
        return ;
    }
    if (!self.textfield1.text.length) {
        NSString *message = NSLocalizedString(@"input_wifi_name", nil);
        UIAlertView *alertview =[[ UIAlertView alloc]initWithTitle:nil message:message delegate:self cancelButtonTitle:NSLocalizedString(@"btn_ok", nil) otherButtonTitles: nil];
        [alertview show];
        return ;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [con configPeripheral:currentPer.peripheral deviceType:SLPDeviceType_WIFIReston serverAddress:self.textfield3.text port:self.textfield4.text.integerValue wifiName:self.textfield1.text password:self.textfield2.text completion:^(BOOL succeed, id data) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSString *result=@"";
        if (succeed) {
            NSLog(@"send succeed!");
            result = NSLocalizedString(@"reminder_configuration_success", nil);
//            SLPDeviceInfo *deviceInfo= (SLPDeviceInfo *)data;
//            result =[NSString stringWithFormat:@"deviceId=%@,version=%@",deviceInfo.deviceID,deviceInfo.version];
        }
        else
        {
            NSLog(@"send failed!");
            result = NSLocalizedString(@"reminder_configuration_fail", nil);
        }
        
        UIAlertView *alertview =[[ UIAlertView alloc]initWithTitle:nil message:result delegate:self cancelButtonTitle:NSLocalizedString(@"btn_ok", nil) otherButtonTitles: nil];
        [alertview show];
    }];
}


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.5 animations:^{
        CGRect rect=self.view.frame;
        CGFloat y_value=rect.origin.y-210;
        rect.origin.y=y_value;
        self.view.frame=rect;
    }];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect rect=self.view.frame;
        CGFloat y_value=rect.origin.y+210;
        rect.origin.y=y_value;
        self.view.frame=rect;
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

- (NSString * )backAddressFromID
{
    return @"120.24.169.204";
}

- (NSInteger )backPortFromID
{
    return 9010;
}
#pragma mark -ScanDeviceDelegate
- (void)didSelectPeripheal:(SLPPeripheralInfo *)peripheralInfo
{
    self.label4.text = peripheralInfo.name;
    currentPer = peripheralInfo;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self resignTextfiled];
}

- (void)resignTextfiled
{
    if (self.textfield1.isEditing) {
        [self.textfield1 resignFirstResponder];
    }
    if (self.textfield2.isEditing) {
        [self.textfield2 resignFirstResponder];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
