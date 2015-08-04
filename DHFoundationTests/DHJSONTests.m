//
//  DHJSONTests.m
//  DHFoundation
//
//  Created by Dave Hardiman on 04/08/2015.
//
//

@import MIQTestingFramework;
#import "NSObject+JSONSerialise.h"
#import "NSData+JSONDeserialise.h"

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

- (void)testItIsPossibleToConvertAJSONStringToADictionary {
    NSDictionary *testObject = @"{\"test\":\"testing\"}".objectFromJSONString;
    expect(testObject).to.equal(@{ @"test" : @"testing" });
}

- (void)testItIsPossibleToConvertJSONDataToAnObject {
    NSDictionary *testObject = [@"{\"test\":\"testing\"}" dataUsingEncoding:NSUTF8StringEncoding].objectFromJSONData;
    expect(testObject).to.equal(@{ @"test" : @"testing" });
}

- (void)testItIsPossibleToConvertJSONDataToAMutableObject {
    NSMutableDictionary *testObject = [@"{\"test\":\"testing\"}" dataUsingEncoding:NSUTF8StringEncoding].mutableObjectFromJSONData;
    expect(testObject).to.equal(@{ @"test" : @"testing" }.mutableCopy);
}

@end
