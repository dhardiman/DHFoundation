//
//  DHNotificationsTest.m
//  DHCoreTestBase
//
//  Created by David Hardiman on 15/07/2013.
//  Copyright (c) 2013 David Hardiman. All rights reserved.
//
@import MIQTestingFramework;
#import "DHFoundation.h"

@interface DHNotificationsTest : XCTestCase

@end
@implementation DHNotificationsTest

- (void)testItIsPossibleToReceiveANotification {
    __block BOOL test = NO;
    [self.dh_notificationStore addObserverForName:@"TestNotification" usingBlock:^(NSNotification *note) {
        test = YES;
    }];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TestNotification" object:nil userInfo:nil];
    expect(test).to.beTruthy();
}

- (void)testItIsPossibleToReceiveMultipleNotifications {
    __block BOOL test = NO;
    [self.dh_notificationStore addObserversForNames:@[ @"TestNotification", @"TestNotification1" ] usingBlock:^(NSNotification *note) {
        test = YES;
    }];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TestNotification" object:nil userInfo:nil];
    expect(test).to.beTruthy();
    test = false;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TestNotification1" object:nil userInfo:nil];
    expect(test).to.beTruthy();
}

- (void)testItIsPossibleToReceiveANotificationForASpecificObject {
    __block BOOL test = NO;
    [self.dh_notificationStore addObserverForName:@"TestNotification" object:self usingBlock:^(NSNotification *note) {
        test = YES;
    }];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TestNotification" object:nil userInfo:nil];
    expect(test).to.beFalsy();
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TestNotification" object:self userInfo:nil];
    expect(test).to.beTruthy();
}

- (void)testItIsPossibleToReceiveMultipleNotificationsForASpecificObject {
    __block BOOL test = NO;
    [self.dh_notificationStore addObserversForNames:@[ @"TestNotification", @"TestNotification1" ] object:self queue:NSOperationQueue.currentQueue usingBlock:^(NSNotification *note) {
        test = YES;
    }];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TestNotification" object:nil userInfo:nil];
    expect(test).to.beFalsy();
    test = false;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TestNotification1" object:nil userInfo:nil];
    expect(test).to.beFalsy();
    test = false;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TestNotification" object:self userInfo:nil];
    expect(test).to.beTruthy();
    test = false;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TestNotification1" object:self userInfo:nil];
    expect(test).to.beTruthy();
}

- (void)testNotificationBlocksDeRegisterAtDeallocation {
    __block BOOL test = NO;
    @autoreleasepool {
        NSObject *object = [[NSObject alloc] init];
        [object.dh_notificationStore addObserverForName:@"TestNotification" usingBlock:^(NSNotification *note) {
            test = YES;
        }];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"TestNotification" object:nil userInfo:nil];
        expect(test).to.beTruthy();
        test = NO;
        object = nil;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TestNotification" object:nil userInfo:nil];
    expect(test).to.beFalsy();
}

@end
