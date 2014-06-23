//
//  CollectionPageViewController.h
//  MobilePatterns
//
//  Created by Joseph Anderson on 6/22/14.
//  Copyright (c) 2014 yoshyosh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuTableViewController.h"

@interface CollectionPageViewController : UIPageViewController <UIPageViewControllerDataSource, UIPageViewControllerDelegate, MenuTableViewControllerDelegate>

@property (nonatomic) CollectionPageViewController *collectionPageViewController;
@property (nonatomic) UIPageViewController *pageViewController;
@property (nonatomic) NSMutableArray *arrayOfPatterns;
@property (nonatomic) NSArray *arrayPatternNames;

@end
