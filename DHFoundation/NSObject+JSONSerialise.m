//
//  NSObject+JSONSerialise.m
//  DHFoundation
//
//  Created by David Hardiman on 27/09/2012.
//  Copyright (c) 2012 David Hardiman. All rights reserved.
//

#import "NSObject+JSONSerialise.h"

@implementation NSObject (JSONSerialise)

- (NSString *)JSONString {
    NSData *data = [self JSONData];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

- (NSData *)JSONData {
    return [NSJSONSerialization dataWithJSONObject:self
                                           options:kNilOptions
                                             error:nil];
}

@end
