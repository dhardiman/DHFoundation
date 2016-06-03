//
//  DHDateExtensionTests.m
//  DHFoundation
//
//  Created by Dave Hardiman on 04/08/2015.
//
//

@import MIQTestingFramework;
#import "NSDate+Rails.h"

@interface DHDateExtensionTests : XCTestCase

@end

@implementation DHDateExtensionTests

- (void)testDatesCanBeAfterOtherDates {
    NSDate *firstDate = NSDate.date;
    NSDate *secondDate = [firstDate dateByAddingTimeInterval:1];
    expect([firstDate isAfter:secondDate]).to.beFalsy();
    expect([secondDate isAfter:firstDate]).to.beTruthy();
}

- (void)testDatesCanBeBeforeOtherDates {
    NSDate *firstDate = NSDate.date;
    NSDate *secondDate = [firstDate dateByAddingTimeInterval:1];
    expect([firstDate isBefore:secondDate]).to.beTruthy();
    expect([secondDate isBefore:firstDate]).to.beFalsy();
}

- (void)testADateCanBeToday {
    NSDate *now = NSDate.date;
    expect(now.isToday).to.beTruthy();
    NSDate *yesterday = [now dateByAddingTimeInterval:-(60 * 60 * 24)];
    expect(yesterday.isToday).to.beFalsy();
    NSDate *tomorrow = [now dateByAddingTimeInterval:60 * 60 * 24];
    expect(tomorrow.isToday).to.beFalsy();
}

- (void)testADateNowsHowManyMinutesHavePassed {
    NSDate *now = NSDate.date;
    expect(now.minutesAgo).to.equal(0);
    NSDate *hourAgo = [now dateByAddingTimeInterval:-(60 * 60)];
    expect(hourAgo.minutesAgo).to.equal(60);
}

- (void)testItIsPossibleToParseADateFromAString {
    NSString *dateString = @"2015-08-04";
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSDate *date = [NSDate dateFromString:@"nonsense" withFormatter:formatter];
    expect(date).to.beNil();
    date = [NSDate dateFromString:dateString withFormatter:formatter];
    NSDateComponents *components = date.gregorianCalendarComponents;
    expect(components.year).to.equal(2015);
    expect(components.month).to.equal(8);
    expect(components.day).to.equal(4);
}

@end
