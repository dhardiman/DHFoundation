//
//  NSData+JSONDeserialise.m
//  DHFoundation
//
//  Created by David Hardiman on 27/09/2012.
//  Copyright (c) 2012 David Hardiman. All rights reserved.
//

#import "NSData+JSONDeserialise.h"

@implementation NSData (JSONDeserialise)

- (id)objectFromJSONData {
    return [NSJSONSerialization JSONObjectWithData:self
                                           options:kNilOptions
                                             error:nil];
}

- (id)mutableObjectFromJSONData {
    return [NSJSONSerialization JSONObjectWithData:self
                                           options:NSJSONReadingMutableContainers
                                             error:nil];
}

@end

@implementation NSString (JSONDeserialise)

- (id)objectFromJSONString {
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    return [data objectFromJSONData];
}

@end