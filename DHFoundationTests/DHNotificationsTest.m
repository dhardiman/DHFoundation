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

- (void)testItIsPossibleToDispatchNotificationsOnOtherQueues {
    __block BOOL test = NO;
    NSOperationQueue *testQueue = [[NSOperationQueue alloc] init];
    __block NSOperationQueue *receivedQueue = nil;
    [self.dh_notificationStore addObserversForNames:@[ @"TestNotification", @"TestNotification1" ] queue:testQueue usingBlock:^(NSNotification *note) {
        receivedQueue = NSOperationQueue.currentQueue;
        test = YES;
    }];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TestNotification" object:nil userInfo:nil];
    expect(test).will.beTruthy();
    expect(receivedQueue).to.equal(testQueue);
    test = false;
    receivedQueue = nil;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TestNotification1" object:nil userInfo:nil];
    expect(test).will.beTruthy();
    expect(receivedQueue).to.equal(testQueue);
    test = false;
    receivedQueue = nil;
    [self.dh_notificationStore addObserverForName:@"TestNotification2" queue:testQueue usingBlock:^(NSNotification *note) {
        receivedQueue = NSOperationQueue.currentQueue;
        test = YES;
    }];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TestNotification2" object:nil userInfo:nil];
    expect(test).will.beTruthy();
    expect(receivedQueue).to.equal(testQueue);
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

- (void)testItIsPossibleToRemoveAnObserver {
    __block BOOL test = NO;
    id observer = [self.dh_notificationStore addObserverForName:@"TestNotification" usingBlock:^(NSNotification *note) {
        test = YES;
    }];
    [self.dh_notificationStore removeObserver:observer];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TestNotification" object:nil userInfo:nil];
    expect(test).to.beFalsy();
}

- (void)testItIsPossibleToRemoveAnObserverByName {
    __block BOOL test = NO;
    [self.dh_notificationStore addObserverForName:@"TestNotification" usingBlock:^(NSNotification *note) {
        test = YES;
    }];
    [self.dh_notificationStore removeObserversForName:@"TestNotification"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TestNotification" object:nil userInfo:nil];
    expect(test).to.beFalsy();
}

- (void)testSubscripting {
    __block BOOL test = NO;
    [self.dh_notificationStore addObserverForName:@"TestNotification" usingBlock:^(NSNotification *note) {
        test = YES;
    }];
    [self.dh_notificationStore removeObserver:[self.dh_notificationStore[@"TestNotification"] firstObject]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TestNotification" object:nil userInfo:nil];
    expect(test).to.beFalsy();
}

@end
