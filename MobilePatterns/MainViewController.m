//
//  MainViewController.m
//  MobilePatterns
//
//  Created by Joseph Anderson on 4/18/14.
//  Copyright (c) 2014 yoshyosh. All rights reserved.
//

#import "MainViewController.h"
#import "PatternViewController.h"
#import "PatternPageViewController.h"
#import "UIImageView+AFNetworking.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSData *jsonData = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://mobile-patterns.com/api/v1/patterns?app=Secret&sort=newest&limit=5"]];
    NSError *error = nil;
    NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
    
    NSData *jsonDataAppNames = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://mobile-patterns.com/api/v1/patterns?apps"]];
    NSDictionary *dataAppNameDictionary = [NSJSONSerialization JSONObjectWithData:jsonDataAppNames options:0 error:&error];
    NSArray *appNameArray = [dataAppNameDictionary objectForKey:@"patterns"];
    for (NSDictionary* dictionary in appNameArray) {
        
    }
    self.arrayOfPatterns = [dataDictionary objectForKey:@"patterns"];
    //Need to return array of patterns and grab the names of all the apps
    //Then construct another URL and request those apps for each section
                                                          
                                                          
    self.collectionPageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationVertical options:nil];
    self.collectionPageViewController.dataSource = self;
    self.collectionPageViewController.view.frame = self.view.bounds;

    PatternPageViewController *initialPageViewController = [self pageViewControllerAtIndex:0];
    NSArray *collectionViewControllers = [NSArray arrayWithObject:initialPageViewController];
    
    [self.collectionPageViewController setViewControllers:collectionViewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    [self addChildViewController:self.collectionPageViewController];
    [self.view addSubview:self.collectionPageViewController.view];
    [self.collectionPageViewController didMoveToParentViewController:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    if ([viewController isKindOfClass:[PatternViewController class]]) {
        NSUInteger index = [(PatternViewController *)viewController index];
        
        if (index == 0) {
            return nil;
        }
        
        index--;
        
        return [self viewControllerAtIndex:index];
    } else {
        NSUInteger index = [(PatternPageViewController *)viewController index];

        if (index == 0) {
        return nil;
        }
        
        index--;
        return [self pageViewControllerAtIndex:index];
    }
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    if ([viewController isKindOfClass:[PatternViewController class]]) {
        NSUInteger index = [(PatternViewController *)viewController index];
        
        if (index == 4) {
            return nil;
        }
        
        index++;
        return [self viewControllerAtIndex:index];
    } else {
        NSUInteger index = [(PatternPageViewController *)viewController index];

        if (index == 4) {
        return nil;
        }

        index++;
        return [self pageViewControllerAtIndex:index];
    }
    
}

- (PatternViewController *)viewControllerAtIndex:(NSUInteger)index {
    
    PatternViewController *patternViewController = [[PatternViewController alloc] init];
    patternViewController.index = index;
    NSDictionary *pattern = self.arrayOfPatterns[index];
    NSString *urlPrefix = pattern[@"image"][@"prefix"];
    NSString *urlSize = pattern[@"image"][@"sizes"][0];
    NSString *urlSuffix = pattern[@"image"][@"suffix"];
    NSString *imageUrl = [NSString stringWithFormat:@"%@%@%@", urlPrefix, urlSize, urlSuffix];
    //Crucial line for weird urls
    NSString *webUrl = [imageUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *patternImageUrl = [NSURL URLWithString:webUrl];
    patternViewController.imageURL = patternImageUrl;
    return patternViewController;
    
}

- (PatternPageViewController *)pageViewControllerAtIndex:(NSUInteger)index {
    PatternPageViewController *patternPageViewController = [[PatternPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    patternPageViewController.index = index;
    //Set new array to get values from for photos
    patternPageViewController.dataSource = self;
    patternPageViewController.view.frame = self.view.bounds;
    
    PatternViewController *initialViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    
    [patternPageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    return patternPageViewController;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
