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
    
    // 2. 扫描周边设备
    // Services：是服务的UUID，而且是个数据，如果不穿，默认扫描全部服务
    [self.mgr scanForPeripheralsWithServices:nil options:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // 9. 断开连接
    [self.mgr stopScan];
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
}

/*
 当发现外围设备时，会调用的方法
 */
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI {
    // 3. 记录扫描到的设备
    if (![self.peripheralArray containsObject:peripheral]) {
        NSLog(@"name: %@", peripheral.name);
        [self.peripheralArray addObject:peripheral];
    }
    
    // 隐藏的步骤：你应该搞一个列表给用户选择，让用户自己选择要连接到哪一个设备
}

#pragma mark - CBPeripheralDelegate
/*
 此方法是连接到外设时会调用的代理方法
 */
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    // 6. 扫描服务 --> 可以传入UUID
    // 传空，代表扫描所有服务
    [peripheral discoverServices:nil];
//    [peripheral discoverServices:@[[CBUUID UUIDWithString:@"uuid"]]];
}

/*
 外设的代理方法 当发现到服务的时候回调用
 */
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
    // 7. 获取指定的服务，然后根据此服务来查找特征
    for (CBService *service in peripheral.services) {
        // 加入我们的服务的UUID是"123"
        if ([service.UUID.UUIDString isEqualToString:@"123"]) {
            // 如果UUID一致，则开始扫描特征
            [peripheral discoverCharacteristics:nil forService:service];
        }
    }
}

/*
 外设的代理方法 当发现到特征的时候会调用
 */
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {
    // 8. 获取指定的特征，然后根据此特征，才能根据自己的需求进行数据交互处理
    // characteristics：服务的数组中，会包含在一个Characteristics的数组
    for (CBCharacteristic *characteristic in service.characteristics) {
        // 如果获取到了指定的特征，则可以进行数据交互处理
        // 读取数据
//        [peripheral readValueForCharacteristic:<#(nonnull CBCharacteristic *)#>];
        // 发送数据
//        [peripheral writeValue:<#(nonnull NSData *)#> forCharacteristic:<#(nonnull CBCharacteristic *)#> type:<#(CBCharacteristicWriteType)#>];
    }
}

/*
 接收数据回调
 */
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForDescriptor:(CBDescriptor *)descriptor error:(NSError *)error {
    
}

/*
 发送数据回调
 */
- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForDescriptor:(CBDescriptor *)descriptor error:(NSError *)error {
    
}
@end
