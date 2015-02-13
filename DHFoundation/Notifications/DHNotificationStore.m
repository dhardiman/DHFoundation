//
//  DHNotificationStore.m
//
//  Created by Sebastian Skuse on 26/02/2013.
//  Copyright (c) 2013 Seb Skuse. All rights reserved.
//

/* From https://github.com/sebskuse/SCSNotificationStore
 Copyright (c) 2013 Seb Skuse (http://seb.skus.es/)
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 */

#import "DHNotificationStore.h"

@interface DHNotificationStore ()

/**
 Storage for notification objects. Stored as a dictionary, with
 the key set as the notification name, and the value as a mutable
 array of notification objects.
 */
@property (atomic, strong) NSMutableDictionary *observers;

@end

@implementation DHNotificationStore

- (id)init {
    if (self = [super init]) {
        _observers = [[NSMutableDictionary alloc] init];
    }

    return self;
}

- (id)addObserverForName:(NSString *)name usingBlock:(DHNotificationStoreBlock)block {
    return [self addObserverForName:name object:nil queue:nil usingBlock:block];
}

- (NSArray *)addObserversForNames:(NSArray *)names usingBlock:(DHNotificationStoreBlock)block {
    return [self addObserversForNames:names object:nil queue:nil usingBlock:block];
}

- (id)addObserverForName:(NSString *)name object:(id)obj usingBlock:(DHNotificationStoreBlock)block {
    return [self addObserverForName:name object:obj queue:nil usingBlock:block];
}

- (id)addObserverForName:(NSString *)name queue:(NSOperationQueue *)queue usingBlock:(DHNotificationStoreBlock)block {
    return [self addObserverForName:name object:nil queue:queue usingBlock:block];
}

- (NSArray *)addObserversForNames:(NSArray *)names queue:(NSOperationQueue *)queue usingBlock:(DHNotificationStoreBlock)block {
    return [self addObserversForNames:names object:nil queue:queue usingBlock:block];
}

- (id)addObserverForName:(NSString *)name object:(id)obj queue:(NSOperationQueue *)queue usingBlock:(DHNotificationStoreBlock)block {
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    id notification = [notificationCenter addObserverForName:name object:obj queue:queue usingBlock:block];

    NSMutableArray *objects = self.observers[name];

    if (objects == nil) {
        objects = [[NSMutableArray alloc] init];
    }

    [objects addObject:notification];

    self.observers[name] = objects;

    return notification;
}

- (NSArray *)addObserversForNames:(NSArray *)names object:(id)obj queue:(NSOperationQueue *)queue usingBlock:(DHNotificationStoreBlock)block {
    NSMutableArray *observers = [NSMutableArray arrayWithCapacity:names.count];
    [names enumerateObjectsUsingBlock:^(NSString *name, NSUInteger idx, BOOL *stop) {
        [observers addObject:[self addObserverForName:name object:obj queue:queue usingBlock:block]];
    }];
    return observers;
}

- (void)removeObserver:(id)observer {
    @synchronized(self.observers) {
        [[NSNotificationCenter defaultCenter] removeObserver:observer];

        for (NSString *observerName in self.observers) {
            if ([self.observers[observerName] containsObject:observer]) {
                [self.observers[observerName] removeObject:observer];
            }
        }
    }
}

- (void)removeObserversForName:(NSString *)name {
    @synchronized(self.observers) {
        if (![[self.observers allKeys] containsObject:name]) {
            return;
        }

        [self.observers[name] enumerateObjectsUsingBlock:^(id observer, NSUInteger idx, BOOL *stop) {
        [[NSNotificationCenter defaultCenter] removeObserver:observer];
        }];

        [self.observers[name] removeAllObjects];
    }
}

- (void)removeAllObservers {
    @synchronized(self.observers) {
        NSArray *allObservers = [self.observers.allValues valueForKeyPath:@"@unionOfArrays.self"];
        for (id observer in allObservers) {
            [[NSNotificationCenter defaultCenter] removeObserver:observer];
        }
        [self.observers removeAllObjects];
    }
}

- (id)objectForKeyedSubscript:(id)aKey {
    return self.observers[aKey];
}

- (void)dealloc {
    [self removeAllObservers];
}

@end
