//
//  NSDate+Rails.m
//
//  Copyright 2010 David Hardiman. All rights reserved.
//

#import "NSDate+Rails.h"

@implementation NSDate(Rails)

- (NSDateComponents *)gregorianCalendarComponents {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorian components:(NSSecondCalendarUnit | NSMinuteCalendarUnit
                                                          | NSHourCalendarUnit | NSDayCalendarUnit
                                                          | NSWeekdayCalendarUnit | NSWeekdayOrdinalCalendarUnit
                                                          | NSWeekCalendarUnit | NSMonthCalendarUnit
                                                          | NSYearCalendarUnit | NSEraCalendarUnit) fromDate:self];
    return components;
}


- (BOOL)isAfter:(NSDate *)other {
    if (other == nil) {
        return YES; //A real date must be after a nil date
    }
    return [self compare:other] == NSOrderedDescending;
}

- (BOOL)isBefore:(NSDate *)other {
    return [self compare:other] == NSOrderedAscending;
}

- (BOOL)isInLastHour {
    return ([[NSDate date] timeIntervalSinceDate:self] < 3600);
}

- (BOOL)isToday {
    NSDateComponents *comps = [self gregorianCalendarComponents];
    NSDateComponents *nowComponents = [[NSDate date] gregorianCalendarComponents];

    if ([comps day] != [nowComponents day] ||
        [comps month] != [nowComponents month] ||
        [comps year] != [nowComponents year] ||
        [comps era] != [comps era]) {
        return NO;
    }

    return YES;
}

- (NSInteger)minutesAgo {
    NSInteger timeInterval = [[NSNumber numberWithDouble:[[NSDate date] timeIntervalSinceDate:self]] integerValue];

    return timeInterval / 60;
}

+ (NSDate *)dateFromString:(NSString *)input withFormatter:(NSDateFormatter *)formatter {
    if (!formatter) {
        return nil;
    }
    NSDate *result = [formatter dateFromString:input];
    if (!result) {
        NSError *error = nil;
        if (![formatter getObjectValue:&result forString:input range:nil error:&error]) {
            NSLog(@"Couldn't parse date: %@", error);
        }
    }
    return result;
}

@end
