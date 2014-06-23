//
//  MainViewController.h
//  MobilePatterns
//
//  Created by Joseph Anderson on 4/18/14.
//  Copyright (c) 2014 yoshyosh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuTableViewController.h"

@interface MainViewController : UIViewController <UIPageViewControllerDataSource, UIPageViewControllerDelegate,UIGestureRecognizerDelegate, MenuTableViewControllerDelegate>
@property (nonatomic) UIPageViewController *pageViewController;
@end
