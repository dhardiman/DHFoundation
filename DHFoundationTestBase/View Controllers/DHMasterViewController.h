//
//  DHMasterViewController.h
//  DHCoreTestBase
//
//  Created by David Hardiman on 15/07/2013.
//  Copyright (c) 2013 David Hardiman. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DHDetailViewController;

@interface DHMasterViewController : UITableViewController

@property (strong, nonatomic) DHDetailViewController *detailViewController;

@end
