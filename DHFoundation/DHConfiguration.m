//
//  DHConfiguration.m
//  DHFoundation
//
//  Created by David Hardiman on 15/09/2013.
//  Copyright (c) 2012 David Hardiman. All rights reserved.
//

#import "DHConfiguration.h"
#import <CoreGraphics/CoreGraphics.h>
#import <objc/runtime.h>

@interface DHConfiguration ()
@property (nonatomic, strong) NSDictionary *configPlist;
@end

const char *dh_property_getTypeString(objc_property_t property);

@implementation DHConfiguration

+ (instancetype)sharedConfiguration {
    @synchronized(self) {
        id sharedManager = objc_getAssociatedObject(self, (__bridge const void *)(self));
        if (!sharedManager) {
            sharedManager = [[self alloc] init];
            objc_setAssociatedObject(self, (__bridge const void *)(self), sharedManager, OBJC_ASSOCIATION_RETAIN);
        }
        return sharedManager;
    }
}

- (NSString *)configFileName {
    return @"Config";
}

- (NSDictionary *)loadDictionary {
    NSString *configPath = [[NSBundle mainBundle] pathForResource:self.configFileName ofType:@"plist"];
    return [NSDictionary dictionaryWithContentsOfFile:configPath];
}

- (NSDictionary *)configPlist {
    if (!_configPlist) {
        _configPlist = [self loadDictionary];
    }
    return _configPlist;
}

- (void)reloadConfig {
    self.configPlist = nil;
}

+ (BOOL)resolveInstanceMethod:(SEL)sel {
    NSString *selString = NSStringFromSelector(sel);

    if ([selString rangeOfString:@":"].location == NSNotFound) {
        objc_property_t property = class_getProperty(self, selString.UTF8String);
        if (!property && [selString hasPrefix:@"is"]) {
            selString = [selString stringByReplacingOccurrencesOfString:@"is" withString:@""];
            NSRange firstLetterRange = NSMakeRange(0, 1);
            NSString *firstLetter = [selString substringWithRange:firstLetterRange];
            selString = [selString stringByReplacingCharactersInRange:firstLetterRange withString:firstLetter.lowercaseString];
            property = class_getProperty(self, selString.UTF8String);
            if (!property) {
                return NO;
            }
        }
        const char *value = dh_property_getTypeString(property);
        if (strcmp(value, "Tc") == 0 ||
            strcmp(value, "TB") == 0 /* 64Bit */) {
            return class_addMethod(self, sel, (IMP)dh_boolGetter, @encode(BOOL (*)(DHConfiguration *, SEL)));
        }
        if (strcmp(value, "Tf") == 0) {
            return class_addMethod(self, sel, (IMP)dh_floatGetter, @encode(float (*)(DHConfiguration *, SEL)));
        }
        if (strcmp(value, "Td") == 0) {
            return class_addMethod(self, sel, (IMP)dh_doubleGetter, @encode(double (*)(DHConfiguration *, SEL)));
        }
        if (strcmp(value, "Ti") == 0 ||
            strcmp(value, "Tq") == 0 /* 64Bit */) {
            return class_addMethod(self, sel, (IMP)dh_integerGetter, @encode(NSInteger (*)(DHConfiguration *, SEL)));
        }
        if (strcmp(value, "T@\"NSURL\"") == 0) {
            return class_addMethod(self, sel, (IMP)dh_urlGetter, @encode(NSURL * (*)(DHConfiguration *, SEL)));
        }
        if ([self canResolveInstanceMethod:sel forType:value]) {
            return YES;
        }
        return class_addMethod(self, sel, (IMP)dh_objectGetter, @encode(id (*)(DHConfiguration *, SEL)));
    }

    return [super resolveInstanceMethod:sel];
}

+ (BOOL)canResolveInstanceMethod:(SEL)sel forType:(const char *)type {
    return NO;
}

id dh_objectGetter(DHConfiguration *self, SEL _cmd) {
    NSString *propertyName = NSStringFromSelector(_cmd);
    id value = self.configPlist[NSStringFromSelector(_cmd)];
    if (!value && self.propertyPrefix) {
        NSString *firstLetter = [propertyName substringToIndex:1];
        if (![propertyName hasPrefix:@"iOS"]) { // There's only one property with iOS in it and it respects the lowercase i
            firstLetter = firstLetter.uppercaseString;
        }
        propertyName = [propertyName stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:firstLetter];
        propertyName = [NSString stringWithFormat:@"%@%@", self.propertyPrefix, propertyName];
        value = self.configPlist[propertyName];
    }
    return value;
}

static NSURL *dh_urlGetter(DHConfiguration *self, SEL _cmd) {
    NSString *urlString = dh_objectGetter(self, _cmd);
    return [NSURL URLWithString:urlString];
}

static BOOL dh_boolGetter(DHConfiguration *self, SEL _cmd) {
    return [dh_objectGetter(self, _cmd) boolValue];
}

static float dh_floatGetter(DHConfiguration *self, SEL _cmd) {
    return [dh_objectGetter(self, _cmd) floatValue];
}

static double dh_doubleGetter(DHConfiguration *self, SEL _cmd) {
    return [dh_objectGetter(self, _cmd) doubleValue];
}

static NSInteger dh_integerGetter(DHConfiguration *self, SEL _cmd) {
    return [dh_objectGetter(self, _cmd) integerValue];
}

@end

const char *dh_property_getTypeString(objc_property_t property) {
    const char *attrs = property_getAttributes(property);
    if (attrs == NULL) {
        return NULL;
    }

    static char buffer[256];
    const char *e = strchr(attrs, ',');
    if (e == NULL) {
        return NULL;
    }

    int len = (int)(e - attrs);
    memcpy(buffer, attrs, len);
    buffer[len] = '\0';

    return buffer;
}
