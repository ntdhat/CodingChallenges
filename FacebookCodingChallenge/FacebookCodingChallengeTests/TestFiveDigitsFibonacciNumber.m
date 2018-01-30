//
//  TestFiveDigitsFibonacciNumber.m
//  FacebookCodingChallengeTests
//
//  Created by admin on 1/29/18.
//  Copyright © 2018 ntdhat. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "FiveDigitsFibonacciNumber.h"

@interface TestFiveDigitsFibonacciNumber : XCTestCase

@end

@implementation TestFiveDigitsFibonacciNumber

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)test_Create5DigitsFibonacci {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    NSString* last5_0 = [FiveDigitsFibonacciNumber last5DigitsFibonacci:0];
    NSString* last5_4 = [FiveDigitsFibonacciNumber last5DigitsFibonacci:4];
    NSString* last5_5 = [FiveDigitsFibonacciNumber last5DigitsFibonacci:5];
    NSString* last5_100 = [FiveDigitsFibonacciNumber last5DigitsFibonacci:100];
    NSString* last5_999 = [FiveDigitsFibonacciNumber last5DigitsFibonacci:999];
    NSString* last5_1000 = [FiveDigitsFibonacciNumber last5DigitsFibonacci:1000];
    NSString* last5_1001 = [FiveDigitsFibonacciNumber last5DigitsFibonacci:1001];
    NSString* last5_100000 = [FiveDigitsFibonacciNumber last5DigitsFibonacci:100000];
    
    XCTAssertTrue([last5_0 isEqualToString:@"0"]);
    XCTAssertTrue([last5_4 isEqualToString:@"3"]);
    XCTAssertTrue([last5_5 isEqualToString:@"5"]);
    XCTAssertTrue([last5_100 isEqualToString:@"15075"]);
    XCTAssertTrue([last5_999 isEqualToString:@"74626"]);
    XCTAssertTrue([last5_1000 isEqualToString:@"28875"]);
    XCTAssertTrue([last5_1001 isEqualToString:@"03501"]);
    XCTAssertTrue([last5_100000 isEqualToString:@"46875"]);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
        NSString* last5_100000 = [FiveDigitsFibonacciNumber last5DigitsFibonacci:100000];
        NSLog(@"Last 5 digits of 100000st fibonacci number: %@", last5_100000);
    }];
}

@end
