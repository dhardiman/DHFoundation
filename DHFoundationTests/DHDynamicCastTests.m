//
//  DHDynamicCastTests.m
//  DHFoundation
//
//  Created by Dave Hardiman on 04/08/2015.
//
//

@import MIQTestingFramework;
#import "NSObject+Cast.h"

@interface DHDynamicCastObject : NSObject

@end

@interface DHDynamicCastTests : XCTestCase

@end

@implementation DHDynamicCastTests

- (void)testItCastsAnObjectCorrectly {
    id object = [[DHDynamicCastObject alloc] init];
    expect([DHDynamicCastObject cast:object]).to.beKindOf(DHDynamicCastObject.class);
}

- (void)testItReturnsNilForAnInvalidCast {
    id object = [[NSObject alloc] init];
    expect([DHDynamicCastObject cast:object]).to.beNil();
}

@end

@implementation DHDynamicCastObject
@end
