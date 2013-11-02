//
//  DHDetailViewController.h
//  DHCoreTestBase
//
//  Created by David Hardiman on 15/07/2013.
//  Copyright (c) 2013 David Hardiman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DHDetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
