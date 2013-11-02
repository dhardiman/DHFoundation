//
//  NSObject+Cast.m
//  DHFoundation
//
//  Created by David Hardiman on 19/08/2012.
//

#import "NSObject+Cast.h"

@implementation NSObject (Cast)

+ (instancetype)cast:(id)from {
    if ([from isKindOfClass:self]) {
        return from;
    }
    return nil;
}

@end