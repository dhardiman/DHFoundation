//
//  testingframeworks.h
//  testingframeworks
//
//  Created by David Hardiman on 13/02/2013.
//  Copyright (c) 2013 Mobile IQ. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifdef __OBJC__
#define EXP_SHORTHAND
#import "Expecta.h"
#define LRMOCKY_SUGAR
#import "LRMocky.h"
#import "OCMock.h"
#import "OHHTTPStubs.h"
#import "MIQCoreDataTestBase.h"

#define TEST_CASE_WITH_SUBCLASS(name, subclass) \
@interface name : subclass \
@end \
@implementation name \

#define TEST_CASE(name) TEST_CASE_WITH_SUBCLASS(name, SenTestCase)

#define END_TEST_CASE \
@end
#endif

#define Test(x) - (void)test##x