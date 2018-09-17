# iOS_BLE_Wifi_Config
ble wifi config

编译依赖库文件

libc++.lib

BLEWifiConfig.framework

BluetoothManager.framework

SLPCommon.framework

链接设置：

-force_load $(SRCROOT)/BluetoothManager.framework/BluetoothManager

-foce_load $(SRCROOT)/BLEWifiConfig.framework/BLEWifiConfig

