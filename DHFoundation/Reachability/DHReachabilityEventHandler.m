//
//  DHReachabilityEventHandler.m
//  DHFoundation
//
//  Copyright (c) 2013 David Hardiman. All rights reserved.
//

#import "DHReachabilityEventHandler.h"
#import "NSObject+Notifications.h"
#import "DHWeakSelf.h"
#import <objc/runtime.h>

@interface DHReachabilityEventHandler ()
@property (nonatomic, strong) DHReachability *reachability;
@end

@implementation DHReachabilityEventHandler

- (id)init {
    if (self = [super init]) {
        _reachability = [DHReachability reachabilityForInternetConnection];
        [_reachability startNotifier];
    }
    return self;
}

- (void)dealloc {
    [_reachability stopNotifier];
}

- (void)setChanged:(DHReachabilityChanged)reachabilityChanged {
    [self.dh_notificationStore removeObserversForName:DHReachabilityChangedNotification];
    DHWeak(self);
    [self.dh_notificationStore addObserverForName:DHReachabilityChangedNotification object:self.reachability usingBlock:^(NSNotification *note) {
        DHStrong(self);
        reachabilityChanged([self.reachability currentReachabilityStatus]);
    }];
}

@end

static void *DHReachabilityHandlerObject = &DHReachabilityHandlerObject;

@implementation NSObject (Reachability)

- (DHReachabilityEventHandler *)dh_reachability {
    DHReachabilityEventHandler *handler = objc_getAssociatedObject(self, DHReachabilityHandlerObject);

    if (handler == nil) {
        handler = [[DHReachabilityEventHandler alloc] init];
        objc_setAssociatedObject(self, DHReachabilityHandlerObject, handler, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }

    return handler;
}

@end