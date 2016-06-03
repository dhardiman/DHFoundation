//
//  NSCache+Subscripting.h
//  DHFoundation
//
//  Created by David Hardiman on 17/06/2013.
//  Copyright (c) 2013 David Hardiman. All rights reserved.
//
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Adds subscripting support to NSCache
 */
// clang-format off
@interface NSCache<KeyType, ObjectType> (Subscripting)

/**
 Return a value for the subscript key
 @param key The key to look for
 */
- (nullable ObjectType)objectForKeyedSubscript:(KeyType)key;

/**
 Set a value for the subscript key
 @param obj The object to store
 @param key The key to store against
 */
- (void)setObject:(ObjectType)obj forKeyedSubscript:(KeyType)key;

@end

// clang-format on

NS_ASSUME_NONNULL_END
