//
//  DHReachabilityTests.m
//  DHFoundation
//
//  Created by Dave Hardiman on 04/08/2015.
//
//

@import MIQTestingFramework;
@import DHFoundation;

@interface DHReachabilityEventHandler (Private)
@property (nonatomic, strong) DHReachability *reachability;
@end

@interface DHReachabilityTests : XCTestCase

@end

@implementation DHReachabilityTests

- (void)testObjectsHaveAReachabilityHandler {
    NSObject *object = [[NSObject alloc] init];
    expect(object.dh_reachability).notTo.beNil();
    expect(object.dh_reachability).to.beIdenticalTo(object.dh_reachability);
}

- (void)testItNotifiesWhenReachabilityChanges {
    id mockReachability = OCMClassMock(DHReachability.class);
    NSObject *object = [[NSObject alloc] init];
    object.dh_reachability.reachability = mockReachability;
    OCMStub([mockReachability currentReachabilityStatus]).andReturn(DHReachabilityStatusWiFi);
    __block DHReachabilityStatus receivedStatus = DHReachabilityStatusNotReachable;
    object.dh_reachability.changed = ^(DHReachabilityStatus status) {
        receivedStatus = status;
    };
    [[NSNotificationCenter defaultCenter] postNotificationName:DHReachabilityChangedNotification object:mockReachability];
    expect(receivedStatus).to.equal(DHReachabilityStatusWiFi);
}

- (void)testItIgnoresChangeNotificationsFromOtherReachabilityObjects {
    id mockReachability = OCMClassMock(DHReachability.class);
    NSObject *object = [[NSObject alloc] init];
    object.dh_reachability.reachability = mockReachability;
    OCMStub([mockReachability currentReachabilityStatus]).andReturn(DHReachabilityStatusWiFi);
    __block BOOL blockCalled = NO;
    object.dh_reachability.changed = ^(DHReachabilityStatus status) {
        blockCalled = YES;
    };
    [[NSNotificationCenter defaultCenter] postNotificationName:DHReachabilityChangedNotification object:nil];
    expect(blockCalled).to.beFalsy();
}

@end
