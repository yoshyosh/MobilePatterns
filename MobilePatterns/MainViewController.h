//
//  MainViewController.h
//  MobilePatterns
//
//  Created by Joseph Anderson on 4/18/14.
//  Copyright (c) 2014 yoshyosh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController <UIPageViewControllerDataSource, UIPageViewControllerDelegate,UIGestureRecognizerDelegate>
@property (nonatomic) UIPageViewController *pageViewController;
@property (nonatomic) UIPageViewController *collectionPageViewController;
@property (nonatomic) NSMutableArray *arrayOfPatterns;
@property (nonatomic) NSArray *arrayPatternNames;
@end
