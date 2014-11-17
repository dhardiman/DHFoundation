//
//  DHConfigurationTests.m
//  DHFoundation
//
//  Created by David Hardiman on 21/03/2014.
//  Copyright (c) 2012 David Hardiman. All rights reserved.
//
#import <MIQTestingFramework/MIQTestingFramework.h>
#import "DHConfiguration.h"

@interface DHConfiguration ()
@property (nonatomic, strong) NSDictionary *configPlist;
@end

@interface DHTestConfiguration : DHConfiguration
@property (nonatomic, readonly) NSString *testString;
@property (nonatomic, readonly) NSNumber *testNumber;
@property (nonatomic, readonly) NSURL *testURL;
@property (nonatomic, readonly) BOOL testBOOL;
@property (nonatomic, readonly) CGFloat testFloat;
@property (nonatomic, readonly) NSInteger testInt;
@property (nonatomic, readonly) NSString *testPrefix;
@end

TEST_CASE(DHConfigurationTests)

- (void)setUp {
    [super setUp];
    DHTestConfiguration.sharedConfiguration.propertyPrefix = @"DH";
}

- (void)tearDown {
    [super tearDown];
}

Test(ThereIsASharedConfiguration) {
    DHConfiguration *sharedConfiguration = DHConfiguration.sharedConfiguration;
    expect(sharedConfiguration).notTo.beNil();
    expect(sharedConfiguration).to.equal(DHConfiguration.sharedConfiguration);
}

Test(EachConfigurationClassHasItsOwnSharedInstance) {
    DHConfiguration *sharedConfiguration = DHConfiguration.sharedConfiguration;
    DHTestConfiguration *sharedTestConfiguration = DHTestConfiguration.sharedConfiguration;
    expect(sharedConfiguration).notTo.beIdenticalTo(sharedTestConfiguration);
}

Test(ItLoadsTheConfigFile) {
    expect(DHConfiguration.sharedConfiguration.configPlist).notTo.beNil();
    expect(DHTestConfiguration.sharedConfiguration.configPlist).notTo.beNil();
}

Test(ItIsPossibleToLoadAString) {
    expect(DHTestConfiguration.sharedConfiguration.testString).to.equal(@"A test string");
}

Test(ItIsPossibleToLoadANumber) {
    expect(DHTestConfiguration.sharedConfiguration.testNumber).to.equal(@3);
}

Test(ItIsPossibleToLoadAURL) {
    expect(DHTestConfiguration.sharedConfiguration.testURL).to.equal([NSURL URLWithString:@"http://www.google.com/"]);
}

Test(ItIsPossibleToLoadABool) {
    expect(DHTestConfiguration.sharedConfiguration.testBOOL).to.beTruthy();
}

Test(ItIsPossibleToLoadAFloat) {
    expect(DHTestConfiguration.sharedConfiguration.testFloat).to.equal(3.14);
}

Test(ItIsPossibleToLoadAInt) {
    expect(DHTestConfiguration.sharedConfiguration.testInt).to.equal(3);
}

Test(ItIsPossibleToSpecifyAPrefix) {
    expect(DHTestConfiguration.sharedConfiguration.testPrefix).to.equal(@"Prefix string");
}

END_TEST_CASE

@implementation DHTestConfiguration
@dynamic testString;
@dynamic testNumber;
@dynamic testURL;
@dynamic testBOOL;
@dynamic testFloat;
@dynamic testInt;
@dynamic testPrefix;

- (NSString *)configFileName {
    return @"TestConfig";
}

@end
