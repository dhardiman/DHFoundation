//
//  NSCache+Subscripting.h
//  DHFoundation
//
//  Created by David Hardiman on 17/06/2013.
//  Copyright (c) 2013 David Hardiman. All rights reserved.
//

/**
 Adds subscripting support to NSCache
 */
@interface NSCache (Subscripting)

/**
 Return a value for the subscript key
 */
- (id)objectForKeyedSubscript:(id)key;

/**
 Set a value for the subscript key
 */
- (void)setObject:(id)obj forKeyedSubscript:(id)key;

@end
