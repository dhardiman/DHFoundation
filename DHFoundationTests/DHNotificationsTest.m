//
//  DHNotificationsTest.m
//  DHCoreTestBase
//
//  Created by David Hardiman on 15/07/2013.
//  Copyright (c) 2013 David Hardiman. All rights reserved.
//
#import <MIQTestingFramework/MIQTestingFramework.h>
#import "DHFoundation.h"

TEST_CASE(DHNotificationsTest)

Test(ItIsPossibleToReceiveANotification) {
    __block BOOL test = NO;
    [self.dh_notificationStore addObserverForName:@"TestNotification" usingBlock:^(NSNotification *note) {
        test = YES;
    }];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TestNotification" object:nil userInfo:nil];
    expect(test).to.beTruthy();
}

Test(NotificationBlocksDeRegisterAtDeallocation){
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

END_TEST_CASE
