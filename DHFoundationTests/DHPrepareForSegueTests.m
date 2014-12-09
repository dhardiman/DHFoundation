//
//  DHPerformSelectorForSegueTests.m
//
//  Created by David Hardiman on 11/04/2014.
//  Copyright (c) 2014 David Hardiman. All rights reserved.
//
#import <MIQTestingFramework/MIQTestingFramework.h>
#import "UIViewController+DHPrepareSegue.h"

@interface DHTestViewController : UIViewController
- (void)testSegue;
- (void)testDestination:(UIViewController *)destination;
- (void)testDestination:(UIViewController *)destination source:(UIViewController *)source;
- (void)testDestination:(UIViewController *)destination source:(UIViewController *)source anyobject:(id)object;

- (void)testSender:(id)sender;
- (void)testDestination:(UIViewController *)destination sender:(id)sender;
- (void)testDestination:(UIViewController *)destination source:(UIViewController *)source sender:(id)sender;
- (void)testDestination:(UIViewController *)destination source:(UIViewController *)source sender:(id)sender anyobject:(id)object;
@end

TEST_CASE(DHPerformSelectorForSegueTests) {
    DHTestViewController *_testViewController;
    id _partialViewController;
}

- (void)setUp {
    [super setUp];
    _testViewController = [[DHTestViewController alloc] init];
    _partialViewController = PartialMock(_testViewController);
}

- (void)tearDown {
    _testViewController = nil;
    _partialViewController = nil;
    [super tearDown];
}

Test(AViewControllerRespondsToASegueWithNoColons) {
    [[_partialViewController expect] testSegue];

    [_testViewController dh_prepareSegueWithIdentifier:@"testSegue" destinationViewController:nil sourceViewController:nil sender:nil];

    [_partialViewController verify];
}

Test(AViewControllerRepondsToASegueWithOneColon) {
    UIViewController *destination = [[UIViewController alloc] init];
    [[_partialViewController expect] testDestination:destination];

    [_testViewController dh_prepareSegueWithIdentifier:@"testDestination:" destinationViewController:destination sourceViewController:nil sender:nil];

    [_partialViewController verify];
}

Test(AViewControllerRespondsToASegueWithTwoColons) {
    UIViewController *destination = [[UIViewController alloc] init];
    UIViewController *source = [[UIViewController alloc] init];
    [[_partialViewController expect] testDestination:destination source:source];

    [_testViewController dh_prepareSegueWithIdentifier:@"testDestination:source:" destinationViewController:destination sourceViewController:source sender:nil];

    [_partialViewController verify];
}

Test(AViewControllerDoesntRespondToThreeColonsIfNoSenderRequested) {
    expect(^{ [_testViewController dh_prepareSegueWithIdentifier:@"testDestination:source:anyobject:" destinationViewController:nil sourceViewController:nil sender:nil]; }).to.raise(NSInvalidArgumentException);
}

Test(TheSenderIsPassedForOneColonIfRequested) {
    NSObject *sender = [[NSObject alloc] init];
    [[_partialViewController expect] testSender:sender];

    [_testViewController dh_prepareSegueWithIdentifier:@"testSender:" destinationViewController:nil sourceViewController:nil sender:sender];

    [_partialViewController verify];
}

Test(TheSenderIsPassedForTwoColonsIfRequested) {
    NSObject *sender = [[NSObject alloc] init];
    UIViewController *destination = [[UIViewController alloc] init];
    [[_partialViewController expect] testDestination:destination sender:sender];

    [_testViewController dh_prepareSegueWithIdentifier:@"testDestination:sender:" destinationViewController:destination sourceViewController:nil sender:sender];

    [_partialViewController verify];
}

Test(TheSenderIsPassedForThreeColonsIfRequested) {
    UIViewController *destination = [[UIViewController alloc] init];
    UIViewController *source = [[UIViewController alloc] init];
    NSObject *sender = [[NSObject alloc] init];
    [[_partialViewController expect] testDestination:destination source:source sender:sender];

    [_testViewController dh_prepareSegueWithIdentifier:@"testDestination:source:sender:" destinationViewController:destination sourceViewController:source sender:sender];

    [_partialViewController verify];
}

Test(AViewControllerDoesntRespondToFourColons) {
    expect(^{ [_testViewController dh_prepareSegueWithIdentifier:@"testDestination:source:sender:anyobject:" destinationViewController:nil sourceViewController:nil sender:nil]; }).to.raise(NSInvalidArgumentException);
}

END_TEST_CASE

@implementation DHTestViewController

- (void)testSegue {
}
- (void)testDestination:(UIViewController *)destination {
}
- (void)testDestination:(UIViewController *)destination source:(UIViewController *)source {
}
- (void)testDestination:(UIViewController *)destination source:(UIViewController *)source anyobject:(id)object {
}

- (void)testSender:(id)sender {
}
- (void)testDestination:(UIViewController *)destination sender:(id)sender {
}
- (void)testDestination:(UIViewController *)destination source:(UIViewController *)source sender:(id)sender {
}
- (void)testDestination:(UIViewController *)destination source:(UIViewController *)source sender:(id)sender anyobject:(id)object {
}

@end
