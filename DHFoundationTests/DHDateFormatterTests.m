//
//  DHDateFormatterTests.m
//  DHFoundation
//
//  Created by David Hardiman on 17/07/2013.
//  Copyright (c) 2013 David Hardiman. All rights reserved.
//
#import <MIQTestingFramework/MIQTestingFramework.h>
#import "NSDateFormatter+Formatters.h"

TEST_CASE(DHDateFormatterTests)

Test(WeCanCreateADateFormatter) {
    NSDateFormatter *formatter = [NSDateFormatter dateFormatterForFormat:@"yyyy-MM-dd"];
    expect(formatter).notTo.beNil();
    expect(formatter.dateFormat).to.equal(@"yyyy-MM-dd");
    expect(formatter.locale.localeIdentifier).to.equal(@"en_US_POSIX");
}

Test(WeCanCacheADateFormatter) {
    NSDateFormatter *formatter = [NSDateFormatter dateFormatterForFormat:@"yyyy-MM-dd" cache:YES];
    expect(formatter).notTo.beNil();
    expect(formatter.dateFormat).to.equal(@"yyyy-MM-dd");
    NSDateFormatter *formatter1 = [NSDateFormatter dateFormatterForFormat:@"yyyy-MM-dd" cache:YES];
    expect(formatter1).to.beIdenticalTo(formatter);
}

Test(WeReceiveACachedFormatterIfItExistsEvenIfWeDontAskForItToBeCached) {
    NSDateFormatter *formatter = [NSDateFormatter dateFormatterForFormat:@"yyyy-MM-dd" cache:YES];
    expect(formatter).notTo.beNil();
    expect(formatter.dateFormat).to.equal(@"yyyy-MM-dd");
    NSDateFormatter *formatter1 = [NSDateFormatter dateFormatterForFormat:@"yyyy-MM-dd" cache:NO];
    expect(formatter1).to.beIdenticalTo(formatter);
}

Test(WeCanExplicitlySetTheLocaleOfTheDateFormatterIfRequired) {
    NSDateFormatter *formatter = [NSDateFormatter dateFormatterForFormat:@"yyyy-MM-dd" locale:[[NSLocale alloc] initWithLocaleIdentifier:@"fr"] cache:YES];
    expect(formatter.locale.localeIdentifier).to.equal(@"fr");
}

END_TEST_CASE
