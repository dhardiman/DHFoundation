//
//  UIViewController+DHPrepareSegue.m
//
//  Created by David Hardiman on 01/04/2014.
//  Copyright (c) 2014 David Hardiman. All rights reserved.
//

#import "UIViewController+DHPrepareSegue.h"
#import <objc/message.h>

@implementation UIViewController (DHPrepareSegue)

- (void)dh_prepareSegueWithIdentifier:(NSString *)segueIdentifier
            destinationViewController:(UIViewController *)destination
                 sourceViewController:(UIViewController *)source
                               sender:(id)sender {
    SEL selector = NSSelectorFromString(segueIdentifier);
    if ([self respondsToSelector:selector]) {
        NSArray *selectorSections = [[segueIdentifier componentsSeparatedByString:@":"] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.length > 0"]];
        NSInteger numberOfColons = [segueIdentifier rangeOfString:@":"].location != NSNotFound ? selectorSections.count : 0;
        NSString *lastSelectorSection = selectorSections.lastObject;
        BOOL wantsSender = [lastSelectorSection rangeOfString:@"sender" options:NSCaseInsensitiveSearch].location != NSNotFound;
        if (numberOfColons > (2 + wantsSender)) {
            @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"More than 2 parameters is not supported" userInfo:nil];
        }
        switch (numberOfColons) {
            case 0: {
                void (*segueMethod)(id, SEL) = (void (*)(id, SEL))objc_msgSend;
                segueMethod(self, selector);
                break;
            }
            case 1: {
                void (*segueMethod)(id, SEL, id) = (void (*)(id, SEL, id))objc_msgSend;
                segueMethod(self, selector, wantsSender ? sender : destination);
                break;
            }
            case 2: {
                void (*segueMethod)(id, SEL, UIViewController *, id) = (void (*)(id, SEL, UIViewController *, id))objc_msgSend;
                segueMethod(self, selector, destination, wantsSender ? sender : source);
                break;
            }
            default: {
                void (*segueMethod)(id, SEL, UIViewController *, UIViewController *, id) = (void (*)(id, SEL, UIViewController *, UIViewController *, id))objc_msgSend;
                segueMethod(self, selector, destination, source, sender);
                break;
            }
        }
    }
}

@end
