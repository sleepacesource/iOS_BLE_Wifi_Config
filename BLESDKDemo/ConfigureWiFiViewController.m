//
//  ConfigureWiFiViewController.m
//  WiFiSDKDemo
//
//  Created by San on 2018/1/25.
//  Copyright © 2018年 medica. All rights reserved.
//

#import "ConfigureWiFiViewController.h"
#import "ScanDeviceViewController.h"
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
@property (nonatomic,weak) IBOutlet UITextField *textfield1;
@property (nonatomic,weak) IBOutlet UITextField *textfield2;
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
    self.titleLabel.text = [self title];
    self.label1.text = NSLocalizedString(@"step1", nil);
    self.label2.text = NSLocalizedString(@"select_device", nil);
    self.label3.text = NSLocalizedString(@"select_device", nil);
//    self.label4.text = @"设备连接的WiFi";
    self.label5.text = NSLocalizedString(@"step2", nil);
    self.label6.text = NSLocalizedString(@"select_wifi", nil);
    
    [self.configureBT setTitle:NSLocalizedString(@"pair_wifi", nil) forState:UIControlStateNormal];
    self.configureBT.layer.cornerRadius =25.0f;
    
    self.view1.layer.cornerRadius = 4.0f;
    self.view1.layer.borderColor = [UIColor colorWithRed:195/255.0 green:203/255.0f blue:214/255.0f alpha:1.0].CGColor;
    self.view1.layer.borderWidth = 1.0f;
    
    self.textfield1.placeholder = NSLocalizedString(@"input_wifi_name", nil);
    self.textfield2.placeholder = NSLocalizedString(@"input_wifi_psw", nil);
    
    self.textfield1.delegate = self;
    self.textfield2.delegate = self;
    
//    self.textfield1.text = @"medica_2";
//    self.textfield2.text = @"11221122";
}

- (NSString *)title {
    NSString *title = @"";
    switch (self.deviceType) {
        case SLPDeviceType_WIFIReston:
            title = NSLocalizedString(@"device_name_z300", nil);
            break;
        case SLPDeviceType_Sal:
            title = NSLocalizedString(@"SA1001", nil);
            break;
        case SLPDeviceType_EW201W:
            title = NSLocalizedString(@"EW201W", nil);
            break;
        default:
            break;
    }
    return title;
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
    [con configPeripheral:currentPer.peripheral deviceType:self.deviceType serverAddress:self.serverAddress port:self.port wifiName:self.textfield1.text password:self.textfield2.text completion:^(BOOL succeed, id data) {
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
        CGFloat y_value=rect.origin.y-120;
        rect.origin.y=y_value;
        self.view.frame=rect;
    }];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect rect=self.view.frame;
        CGFloat y_value=rect.origin.y+120;
        rect.origin.y=y_value;
        self.view.frame=rect;
    }];
}

- (IBAction)back:(id)sender {
    if (currentPer.peripheral) {
        [SLPBLESharedManager disconnectPeripheral:currentPer.peripheral timeout:0 completion:nil];
    }
    [self.navigationController popViewControllerAnimated:YES];
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
