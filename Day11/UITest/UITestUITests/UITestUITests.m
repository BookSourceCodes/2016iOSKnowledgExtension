//
//  UITestUITests.m
//  UITestUITests
//
//  Created by 覃团业 on 2020/1/31.
//  Copyright © 2020 覃团业. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface UITestUITests : XCTestCase

@end

@implementation UITestUITests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.

    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;

    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testExample {
    // UI tests must launch the application that they test.
    XCUIApplication *app = [[XCUIApplication alloc] init];
    [app launch];

    // 1. 鼠标放到这里
    // 2. 点击下方的红色录制按钮
    // 3. 停止时再次点击红色按钮
    
    XCUIElement *element = [[[[[app childrenMatchingType:XCUIElementTypeWindow] elementBoundByIndex:0] childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element;
    [[[[element childrenMatchingType:XCUIElementTypeButton] matchingIdentifier:@"Button"] elementBoundByIndex:0] tap];
    [[[[element childrenMatchingType:XCUIElementTypeButton] matchingIdentifier:@"Button"] elementBoundByIndex:1] tap];
    [app/*@START_MENU_TOKEN@*/.buttons[@"Second"]/*[[".segmentedControls.buttons[@\"Second\"]",".buttons[@\"Second\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/ tap];
    [app/*@START_MENU_TOKEN@*/.buttons[@"First"]/*[[".segmentedControls.buttons[@\"First\"]",".buttons[@\"First\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/ tap];
    [[element childrenMatchingType:XCUIElementTypeTextField].element tap];
    
    XCUIElement *fKey = app/*@START_MENU_TOKEN@*/.keys[@"f"]/*[[".keyboards.keys[@\"f\"]",".keys[@\"f\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/;
    [fKey tap];
    [app/*@START_MENU_TOKEN@*/.keys[@"j"]/*[[".keyboards.keys[@\"j\"]",".keys[@\"j\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/ tap];
    
    XCUIElement *gKey = app/*@START_MENU_TOKEN@*/.keys[@"g"]/*[[".keyboards.keys[@\"g\"]",".keys[@\"g\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/;
    [gKey tap];
    [fKey tap];
    [gKey tap];
    [gKey tap];
    [gKey tap];
    [gKey tap];
    [app/*@START_MENU_TOKEN@*/.buttons[@"Return"]/*[[".keyboards",".buttons[@\"return\"]",".buttons[@\"Return\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/ tap];
    
            
    // Use recording to get started writing UI tests.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testLaunchPerformance {
    if (@available(macOS 10.15, iOS 13.0, tvOS 13.0, *)) {
        // This measures how long it takes to launch your application.
        [self measureWithMetrics:@[XCTOSSignpostMetric.applicationLaunchMetric] block:^{
            [[[XCUIApplication alloc] init] launch];
        }];
    }
}

@end
