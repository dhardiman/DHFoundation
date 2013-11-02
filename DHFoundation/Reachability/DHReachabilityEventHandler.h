//
//  DHReachabilityEventHandler.h
//  DHFoundation
//
//  Copyright (c) 2013 David Hardiman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DHReachability.h"

typedef void(^DHReachabilityChanged)(DHReachabilityStatus status);

@interface DHReachabilityEventHandler : NSObject

/**
 Block callback for reachability changed notifications
 */
@property (nonatomic, copy) DHReachabilityChanged changed;

@property (nonatomic, readonly, strong) DHReachability *reachability;

@end


@interface NSObject (Reachability)

/**
 Returns the reachability handler
 */
@property (nonatomic, strong, readonly) DHReachabilityEventHandler *dh_reachability;

@end