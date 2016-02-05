//
//  DHConfigurationTests.m
//  DHFoundation
//
//  Created by David Hardiman on 21/03/2014.
//  Copyright (c) 2012 David Hardiman. All rights reserved.
//
#import <MIQTestingFramework/MIQTestingFramework.h>
#import "DHConfiguration.h"
@import ObjectiveC.runtime;

@interface DHConfiguration ()
@property (nonatomic, strong) NSDictionary *configPlist;
@end

@interface DHTestConfiguration : DHConfiguration
@property (nonatomic, readonly) NSString *testString;
@property (nonatomic, readonly) NSNumber *testNumber;
@property (nonatomic, readonly) NSURL *testURL;
@property (nonatomic, readonly) BOOL testBOOL;
@property (nonatomic, readonly) double testDouble;
@property (nonatomic, readonly) float testFloat;
@property (nonatomic, readonly) NSInteger testInt;
@property (nonatomic, readonly) NSString *testPrefix;
@property (nonatomic, readonly) NSTimeInterval testTimeInterval;
@property (nonatomic, readonly, getter=isTestIsPrefix) BOOL testIsPrefix;
@end

@interface DHTestReloadableConfiguration : DHConfiguration
@property (nonatomic, strong) NSDictionary *sourceDictionary;
@property (nonatomic, readonly) NSInteger testNumber;
@end

@interface DHTestCustomTypeSupportConfiguration : DHTestReloadableConfiguration
@property (nonatomic, readonly) UIColor *testColour;
@end

@interface DHConfigurationTests : XCTestCase
@end
@implementation DHConfigurationTests

- (void)setUp {
    [super setUp];
    DHTestConfiguration.sharedConfiguration.configBundle = [NSBundle bundleForClass:self.class];
    DHTestConfiguration.sharedConfiguration.propertyPrefix = @"DH";
}

- (void)tearDown {
    [super tearDown];
}

- (void)testThereIsASharedConfiguration {
    DHConfiguration *sharedConfiguration = DHConfiguration.sharedConfiguration;
    expect(sharedConfiguration).notTo.beNil();
    expect(sharedConfiguration).to.equal(DHConfiguration.sharedConfiguration);
}

- (void)testEachConfigurationClassHasItsOwnSharedInstance {
    DHConfiguration *sharedConfiguration = DHConfiguration.sharedConfiguration;
    DHTestConfiguration *sharedTestConfiguration = DHTestConfiguration.sharedConfiguration;
    expect(sharedConfiguration).notTo.beIdenticalTo(sharedTestConfiguration);
}

- (void)testItLoadsTheConfigFile {
    DHConfiguration.sharedConfiguration.configBundle = [NSBundle bundleForClass:self.class];
    expect(DHConfiguration.sharedConfiguration.configPlist).notTo.beNil();
    expect(DHTestConfiguration.sharedConfiguration.configPlist).notTo.beNil();
}

- (void)testItIsPossibleToLoadAString {
    expect(DHTestConfiguration.sharedConfiguration.testString).to.equal(@"A test string");
}

- (void)testItIsPossibleToLoadANumber {
    expect(DHTestConfiguration.sharedConfiguration.testNumber).to.equal(@3);
}

- (void)testItIsPossibleToLoadAURL {
    expect(DHTestConfiguration.sharedConfiguration.testURL).to.equal([NSURL URLWithString:@"http://www.google.com/"]);
}

- (void)testItIsPossibleToLoadABool {
    expect(DHTestConfiguration.sharedConfiguration.testBOOL).to.beTruthy();
}

- (void)testItIsPossibleToLoadAFloat {
    expect(DHTestConfiguration.sharedConfiguration.testFloat).to.equal(3.14);
}

- (void)testItIsPossibleToLoadADouble {
    expect(DHTestConfiguration.sharedConfiguration.testDouble).to.equal(6.28);
}

- (void)testItIsPossibleToLoadATimeInterval {
    expect(DHTestConfiguration.sharedConfiguration.testTimeInterval).to.beCloseToWithin(0.3, 0.0000001);
}

- (void)testItIsPossibleToLoadAInt {
    expect(DHTestConfiguration.sharedConfiguration.testInt).to.equal(3);
}

- (void)testItIsPossibleToSpecifyAPrefix {
    expect(DHTestConfiguration.sharedConfiguration.testPrefix).to.equal(@"Prefix string");
}

- (void)testItHandlesAGetterWithAnIsPrefix {
    expect([DHTestConfiguration.sharedConfiguration isTestIsPrefix]).to.beTruthy();
}

- (void)testItIsPossibleToReloadTheDictionary {
    DHTestReloadableConfiguration.sharedConfiguration.sourceDictionary = @{ @"testNumber" : @4 };
    expect(DHTestReloadableConfiguration.sharedConfiguration.testNumber).to.equal(4);
    DHTestReloadableConfiguration.sharedConfiguration.sourceDictionary = @{ @"testNumber" : @3 };
    [DHTestReloadableConfiguration.sharedConfiguration reloadConfig];
    expect(DHTestReloadableConfiguration.sharedConfiguration.testNumber).to.equal(3);
}

- (void)testItIsPossibleToCreateAConfigurationWithCustomTypeSupport {
    DHTestCustomTypeSupportConfiguration.sharedConfiguration.sourceDictionary = @{ @"testColour" : @0.5 };
    expect(DHTestCustomTypeSupportConfiguration.sharedConfiguration.testColour).to.equal([UIColor colorWithWhite:0.5 alpha:1.0]);
}

@end

@implementation DHTestConfiguration
@dynamic testString;
@dynamic testNumber;
@dynamic testURL;
@dynamic testBOOL;
@dynamic testFloat;
@dynamic testDouble;
@dynamic testInt;
@dynamic testPrefix;
@dynamic testTimeInterval;
@dynamic testIsPrefix;

- (NSString *)configFileName {
    return @"TestConfig";
}

@end

@implementation DHTestReloadableConfiguration
@dynamic testNumber;
- (NSDictionary *)loadDictionary {
    return self.sourceDictionary;
}

@end

@implementation DHTestCustomTypeSupportConfiguration
@dynamic testColour;

+ (BOOL)canResolveInstanceMethod:(SEL)sel forType:(const char *)type {
    if (strcmp(type, "T@\"UIColor\"") == 0) {
        return class_addMethod(self, sel, (IMP)dh_colourGetter, @encode(UIColor * (*)(DHTestCustomTypeSupportConfiguration *, SEL)));
    }
    return NO;
}

static UIColor *dh_colourGetter(DHTestCustomTypeSupportConfiguration *self, SEL _cmd) {
    CGFloat value = (CGFloat)[dh_objectGetter(self, _cmd) floatValue];
    UIColor *colour = [UIColor colorWithWhite:value alpha:1.0];
    return colour;
}

@end
