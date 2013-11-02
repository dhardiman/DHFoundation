//
//  NSCache+Subscripting.m
//  pressrun-ios-common
//
//  Created by David Hardiman on 17/06/2013.
//  Copyright (c) 2013 David Hardiman. All rights reserved.
//

#import "NSCache+Subscripting.h"

@implementation NSCache (Subscripting)

- (id)objectForKeyedSubscript:(id)key {
    return [self objectForKey:key];
}

- (void)setObject:(id)obj forKeyedSubscript:(id)key {
    [self setObject:obj forKey:key];
}

@end
