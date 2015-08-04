//
//  DHJSONTests.m
//  DHFoundation
//
//  Created by Dave Hardiman on 04/08/2015.
//
//

@import MIQTestingFramework;
#import "NSObject+JSONSerialise.h"

@interface DHJSONTests : XCTestCase

@end

@implementation DHJSONTests

- (void)testItIsPossibleToConvertAnObjectToAJSONString {
    NSDictionary *testObject = @{ @"test" : @"testing" };
    expect(testObject.JSONString).to.equal(@"{\"test\":\"testing\"}");
}

- (void)testItIsPossibleToConvertAnObjectToJSONData {
    NSDictionary *testObject = @{ @"test" : @"testing" };
    expect(testObject.JSONData).to.equal([@"{\"test\":\"testing\"}" dataUsingEncoding:NSUTF8StringEncoding]);
}

@end
