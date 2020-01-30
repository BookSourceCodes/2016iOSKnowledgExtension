//
//  ViewController.m
//  CoreBluetoothBT
//
//  Created by 覃团业 on 2020/1/29.
//  Copyright © 2020 覃团业. All rights reserved.
//

#import "ViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>

@interface ViewController () <CBCentralManagerDelegate, CBPeripheralDelegate>

/*
 中央管理者
 */
@property (nonatomic, strong) CBCentralManager *mgr;
/*
 扫描到的外围设备的数据数组
 */
@property (nonatomic, strong) NSMutableArray *peripheralArray;
@property (nonatomic, strong) CBPeripheral *peripheral;
@property (nonatomic, strong) CBCharacteristic * characteristic;

@end

@implementation ViewController

- (NSMutableArray *)peripheralArray {
    if (_peripheralArray == nil) {
        _peripheralArray = [NSMutableArray array];
    }
    return _peripheralArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1. 建立中央管理者
    // queue：如果传空，就代表着在主队列
    self.mgr = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // 9. 断开连接
    [self.mgr stopScan];
    if (self.peripheral != nil) {
        [self.mgr cancelPeripheralConnection:self.peripheral];
        self.peripheral = nil;
        self.characteristic = nil;
    }
}

/*
连接扫描到的设备 ---> 此方法是咱们自己写的，用户当选中了设备时，应该调用此方法
*/
- (void)connectPeripheral:(CBPeripheral *)peripheral {
    // 4. 连接外围设备
    [self.mgr connectPeripheral:peripheral options:nil];
    
    // 5. 设置外围设备的代理 --> 一旦连接外设，那么将有外设来管理服务和特征的处理
    peripheral.delegate = self;
}

#pragma mark - CBCentralManagerDelegate
/*
 必须调用的代理方法
 */
- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    NSLog(@"state: %zd", central.state);
    /*
     CBManagerStateUnknown = 0,
     CBManagerStateResetting,
     CBManagerStateUnsupported,
     CBManagerStateUnauthorized,
     CBManagerStatePoweredOff,
     CBManagerStatePoweredOn,
     */
    switch (central.state) {
        case CBManagerStatePoweredOn:
            // 2. 扫描周边设备
            // 一定要在这里调用扫描方法，否则无法扫描到设备
            // Services：是服务的UUID，而且是个数据，如果不传，默认扫描全部服务
            [self.mgr scanForPeripheralsWithServices:nil options:nil];
            break;
            
        case CBManagerStatePoweredOff:
            break;
            
        case CBManagerStateUnauthorized:
            break;
            
        case CBManagerStateUnsupported:
            break;
            
        case CBManagerStateResetting:
            break;
            
        default: // CBManagerStateUnknown
            break;
    }
    
}

/*
 当发现外围设备时，会调用的方法
 */
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI {
    // 3. 记录扫描到的设备
    if (![self.peripheralArray containsObject:peripheral]) {
        NSLog(@"name: %@, rssi: %@", peripheral.name, RSSI);
        [self.peripheralArray addObject:peripheral];
    }
    
    // 隐藏的步骤：你应该搞一个列表给用户选择，让用户自己选择要连接到哪一个设备
    if (self.peripheral == nil && [@"覃团业的 iPad" isEqualToString:peripheral.name]) {
        if (peripheral.state == CBPeripheralStateDisconnected) {
            [self connectPeripheral:peripheral];
        }
    }
}

#pragma mark - CBPeripheralDelegate
/*
 此方法是连接到外设时会调用的代理方法
 */
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    NSLog(@"连接成功%@", peripheral.name);
    self.peripheral = peripheral;
    // 6. 扫描服务 --> 可以传入UUID
    // 传空，代表扫描所有服务
    [peripheral discoverServices:nil];
//    [peripheral discoverServices:@[[CBUUID UUIDWithString:@"uuid"]]];
}

/*
 外设的代理方法 当发现到服务的时候回调用
 */
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
    NSLog(@"发现%@设备的服务", peripheral.name);
    // 7. 获取指定的服务，然后根据此服务来查找特征
    for (CBService *service in peripheral.services) {
        NSLog(@"%@设备的服务UUID：%@", peripheral.name, service.UUID.UUIDString);
        // 加入我们的服务的UUID是"123"
        if ([service.UUID.UUIDString isEqualToString:@"9FA480E0-4967-4542-9390-D343DC5D04AE"]) {
            // 如果UUID一致，则开始扫描特征
            [peripheral discoverCharacteristics:nil forService:service];
        }
    }
}

/*
 外设的代理方法 当发现到特征的时候会调用
 */
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {
    NSLog(@"发现%@设备的特征", peripheral.name);
    // 8. 获取指定的特征，然后根据此特征，才能根据自己的需求进行数据交互处理
    // characteristics：服务的数组中，会包含在一个Characteristics的数组
    for (CBCharacteristic *characteristic in service.characteristics) {
        NSLog(@"%@设备的特征UUID: %@", peripheral.name, characteristic.UUID.UUIDString);
        // 如果获取到了指定的特征，则可以进行数据交互处理
        // 读取数据
        if ([characteristic.UUID.UUIDString isEqualToString:@"AF0BADB1-5B99-43CD-917A-A77BC549E3CC"]) {
            self.characteristic = characteristic;
            [peripheral readValueForCharacteristic:characteristic];
            [peripheral setNotifyValue:YES forCharacteristic:characteristic];
        }
    }
    
    // 发送数据
    if (self.characteristic != nil) {
        UIImage *image = [UIImage imageNamed:@"Sphere"];
        NSData *data = UIImageJPEGRepresentation(image, 1.0);
        [self.peripheral writeValue:data forCharacteristic:self.characteristic type:CBCharacteristicWriteWithResponse];
    }
}

/*
 接收数据回调
 */
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    if (error) {
        NSLog(@"接收数据失败： %@", error);
    }
    NSLog(@"接收到的数据: %@", characteristic.value);
}

/*
 发送数据回调
 */
- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    if (error) {
        NSLog(@"发送数据失败: %@", error);
    }
}

@end
