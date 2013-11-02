//
//  DHAppDelegate.m
//  DHCoreTestBase
//
//  Created by David Hardiman on 15/07/2013.
//  Copyright (c) 2013 David Hardiman. All rights reserved.
//

#import "DHAppDelegate.h"

#import "DHMasterViewController.h"

@implementation DHAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.

    DHMasterViewController *masterViewController = [[DHMasterViewController alloc] initWithNibName:@"DHMasterViewController" bundle:nil];
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:masterViewController];
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
    return YES;
}

@end
