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
#import "Pattern.h"
#import "MenuTableViewController.h"

@interface MainViewController ()

- (PatternViewController *)viewControllerAtPageIndex:(NSUInteger)pageIndex patternIndex:(NSUInteger)patternIndex;
@property (nonatomic) MenuTableViewController *menuTableView;
@property (nonatomic) UIView *panGestureInterceptView;
@property (nonatomic) UIPanGestureRecognizer *rightPanGestureMenu;
@property (nonatomic) UIView *patternDescriptionView;
@property (nonatomic) UILabel *patternAppName;
@property (nonatomic) UILabel *patternTags;
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
    
    self.menuTableView = [[MenuTableViewController alloc] init];
    self.menuTableView.delegate = self;
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"blurbg"]];
    [imageView setFrame:self.menuTableView.view.frame];
    [self.view addSubview:imageView];
    [self.view addSubview:self.menuTableView.view];

    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://mobile-patterns.com/api/v1/apps"]];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSError *error = nil;
        NSDictionary *dataAppNameDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        self.arrayPatternNames = [Pattern allPatternNames:[dataAppNameDictionary objectForKey:@"apps"]];
        
        self.arrayOfPatterns = [NSMutableArray array];
        [self.arrayPatternNames enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            self.arrayOfPatterns[idx] = [NSMutableArray array];
        }];
        [self runSetup];
        //TUrn off UIActivityIndicator
    }];
    
// TODO: make sure that the app can handle having a nil self.arrayPatternNames, if self.arrayPatternNames == nil, check request/run request again, then run function that needs it on complete? Not exactly sure how to handle these states. Maybe its recursive, on completion run the function that needs arrayPatterns, that function always checks if nil first (prevents breakage but also shouldnt run at all since it is only called on complete. Possible checks for timeout here
    



}

// TODO: reload the pageViewControllers after the network request comes back, is this the best way?
- (void)runSetup {
    self.collectionPageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationVertical options:nil];
    self.collectionPageViewController.dataSource = self;
    self.collectionPageViewController.delegate = self;
    self.collectionPageViewController.view.frame = self.view.bounds;
    
    PatternPageViewController *initialPageViewController = [self pageViewControllerAtIndex:0];
    NSArray *collectionViewControllers = [NSArray arrayWithObject:initialPageViewController];
    
    [self.collectionPageViewController setViewControllers:collectionViewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    [self addChildViewController:self.collectionPageViewController];
    [self.view addSubview:self.collectionPageViewController.view];
    [self.collectionPageViewController didMoveToParentViewController:self];
    
    //Need to load the next pageViewController so that when we swipe up, it already exists
    
    self.panGestureInterceptView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 568)];
    self.panGestureInterceptView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.panGestureInterceptView];
    
    UIScreenEdgePanGestureRecognizer *edgePanGesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(edgePanActivateMenu:)];
    edgePanGesture.edges = UIRectEdgeLeft;
    [self.panGestureInterceptView addGestureRecognizer:edgePanGesture];
    
    self.rightPanGestureMenu = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(rightEdgePanCloseMenu:)];
    
    // Add subview of overlays whether they are tutorials or description
}

- (void)edgePanActivateMenu:(UIScreenEdgePanGestureRecognizer *)panGesture {
    CGPoint point = [panGesture locationInView:self.view];
    if (panGesture.state == UIGestureRecognizerStateBegan) {
        
    } else if (panGesture.state == UIGestureRecognizerStateChanged){
        CGRect frame = CGRectMake(point.x, 0, 320, 568);
        CGRect gesturePlaceholderFrame = CGRectMake(point.x, 0, 30, 568);
        self.collectionPageViewController.view.frame = frame;
        self.panGestureInterceptView.frame = gesturePlaceholderFrame;
    } else if (panGesture.state == UIGestureRecognizerStateEnded){
        //If past a certain point in the x direction
        [self animateMenuOpen];
        [self.panGestureInterceptView addGestureRecognizer:self.rightPanGestureMenu];
    }
}

- (void)rightEdgePanCloseMenu:(UIPanGestureRecognizer *)panGesture {
    CGPoint point = [panGesture locationInView:self.view];
    if (panGesture.state == UIGestureRecognizerStateBegan) {
        
    } else if (panGesture.state == UIGestureRecognizerStateChanged){
        CGRect frame = CGRectMake(point.x, 0, 320, 568);
        CGRect gesturePlaceholderFrame = CGRectMake(point.x, 0, 30, 568);
        self.collectionPageViewController.view.frame = frame;
        self.panGestureInterceptView.frame = gesturePlaceholderFrame;
    } else if (panGesture.state == UIGestureRecognizerStateEnded) {
        [self animateMenuClosed];
        [self.panGestureInterceptView removeGestureRecognizer:self.rightPanGestureMenu];
    }
}

- (void)animateMenuOpen {
    [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        CGRect frame = CGRectMake(290, 0, 320, 568);
        CGRect gesturePlaceholderFrame = CGRectMake(290, 0, 30, 568);
        self.collectionPageViewController.view.frame = frame;
        self.panGestureInterceptView.frame = gesturePlaceholderFrame;
    } completion:nil];
}

- (void)animateMenuClosed {
    [UIView animateWithDuration:0.4 animations:^{
        CGRect frame = CGRectMake(0, 0, 320, 568);
        CGRect gesturePlaceholderFrame = CGRectMake(0, 0, 30, 568);
        self.collectionPageViewController.view.frame = frame;
        self.panGestureInterceptView.frame = gesturePlaceholderFrame;
    } completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Creates the viewController or pageViewController before the current
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    // If swiping left and right
    if ([viewController isKindOfClass:[PatternViewController class]]) {
        NSUInteger index = [(PatternViewController *)viewController index];
        
        if (index == 0) {
            return nil;
        }
        
        index--;
        
        NSUInteger pageIndex = [(PatternPageViewController *)pageViewController index];
        return [self viewControllerAtPageIndex:pageIndex patternIndex:index];
    } else {
        //If swiping up and down, create new page view controller
        NSUInteger index = [(PatternPageViewController *)viewController index];

        if (index == 0) {
        return nil;
        }
        
        index--;
        return [self pageViewControllerAtIndex:index];
    }
}

//Creates the viewController after the currently viewed viewController
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    if ([viewController isKindOfClass:[PatternViewController class]]) {
        NSUInteger index = [(PatternViewController *)viewController index];
        NSUInteger pageIndex = [(PatternPageViewController *)pageViewController index];
        NSArray *countArray = self.arrayOfPatterns[pageIndex];
        
        //if swiping left and right create a new viewController
        if (index == (countArray.count - 1)) {
            return nil;
        }
        
        index++;
        
        
        return [self viewControllerAtPageIndex:pageIndex patternIndex:index];
    } else {
        //if swiping up and down create a new page view controller
        NSUInteger index = [(PatternPageViewController *)viewController index];
        if (index >= [self.arrayPatternNames count]) {
        return nil;
        }

        index++;
        return [self pageViewControllerAtIndex:index];
    }
    
}

// Creates a new pattern viewController
- (PatternViewController *)viewControllerAtPageIndex:(NSUInteger)pageIndex patternIndex:(NSUInteger)patternIndex {
    PatternViewController *patternViewController = [[PatternViewController alloc] init];
    patternViewController.index = patternIndex;
    Pattern *pattern = self.arrayOfPatterns[pageIndex][patternIndex];
    NSURL *patternImageUrl = [NSURL URLWithString:pattern.patternPicUrl];
    patternViewController.imageURL = patternImageUrl;
    patternViewController.appName = pattern.appName;
    NSString *tags = [pattern.tags componentsJoinedByString:@", "];
    patternViewController.tagString = tags;
    return patternViewController;
    
}

// Creates a PageViewController that holds an array of patterns
- (PatternPageViewController *)pageViewControllerAtIndex:(NSUInteger)index {
    PatternPageViewController *patternPageViewController = [[PatternPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    patternPageViewController.index = index;
    patternPageViewController.dataSource = self;
    patternPageViewController.delegate = self;
    patternPageViewController.view.frame = self.view.bounds;
    
    //Should this be in a method?
    NSArray *patterns = self.arrayOfPatterns[index];
    if (patterns.count == 0) {
        NSString *requestPatternsUrl = [Pattern buildPatternUrlRequest:self.arrayPatternNames[index]];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:requestPatternsUrl]];
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            NSError *error = nil;
            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            
            //Set newly loaded patterns from this index to array of patterns
            self.arrayOfPatterns[index] = [Pattern patternsWithArray:[dataDictionary objectForKey:@"patterns"]];
            PatternViewController *initialViewController = [self viewControllerAtPageIndex:index patternIndex:0];
            NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
            [patternPageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
        }];

    } else {
        PatternViewController *initialViewController = [self viewControllerAtPageIndex:index patternIndex:0];
        NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
        [patternPageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    }
    
    return patternPageViewController;
}

//When the page view controller fully transitions fade out the app type/tags preview overlay
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed {
    if (completed) {
        if ([pageViewController isKindOfClass:[PatternPageViewController class]]) {
            PatternViewController *viewController = [pageViewController.viewControllers lastObject];
            [self fadeOutPreviewView:viewController];
        } else {
            // I want to have a blank screen / loader until the new pageViewController is loaded
            PatternPageViewController *patternPageViewController = [pageViewController.viewControllers lastObject];
            PatternViewController *viewController = [patternPageViewController.viewControllers lastObject];
            [self fadeOutPreviewView:viewController];
        }
    }

}

- (void)fadeOutPreviewView:(PatternViewController *)viewController {
    viewController.previewView.alpha = 1.0;
    [UIView animateWithDuration:1.0 animations:^{
        viewController.previewView.alpha = 0.0;
    } completion:nil];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)replaceWithTaggedItems:(NSArray *)arrayOfTaggedPatterns {
    self.arrayOfPatterns[0] = arrayOfTaggedPatterns;
    
    //Refresh the pageview controller
    PatternPageViewController *initialPageViewController = [self pageViewControllerAtIndex:0];
    NSArray *collectionViewControllers = [NSArray arrayWithObject:initialPageViewController];
    
    [self.collectionPageViewController setViewControllers:collectionViewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
}

@end
