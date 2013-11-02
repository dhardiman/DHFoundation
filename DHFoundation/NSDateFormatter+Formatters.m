//
//  NSDateFormatter+Formatters.m
//  DHFoundation
//
//  Created by David Hardiman on 17/07/2013.
//  Copyright (c) 2013 David Hardiman. All rights reserved.
//

#import "NSDateFormatter+Formatters.h"
#import <objc/runtime.h>
#import "NSCache+Subscripting.h"

static void *DHDateFormatterCacheKey = &DHDateFormatterCacheKey;

@implementation NSDateFormatter (Formatters)

+ (NSDateFormatter *)dateFormatterForFormat:(NSString *)format {
    return [self dateFormatterForFormat:format cache:YES];
}

+ (NSCache *)formatterCache {
    NSCache *formatterCache = objc_getAssociatedObject(self, DHDateFormatterCacheKey);
    if (!formatterCache) {
        formatterCache = [[NSCache alloc] init];
        objc_setAssociatedObject(self, DHDateFormatterCacheKey, formatterCache, OBJC_ASSOCIATION_RETAIN);
    }
    return formatterCache;
}

+ (NSDateFormatter *)dateFormatterForFormat:(NSString *)format cache:(BOOL)shouldCache {
    return [self dateFormatterForFormat:format locale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"] cache:shouldCache];
}

+ (NSDateFormatter *)dateFormatterForFormat:(NSString *)format locale:(NSLocale *)locale cache:(BOOL)shouldCache {
    NSDateFormatter *formatter = self.formatterCache[format];
    if (!formatter) {
        formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = format;
        if (shouldCache) {
            self.formatterCache[format] = formatter;
        }
    }
    formatter.locale = locale;
    return formatter;
}

@end
