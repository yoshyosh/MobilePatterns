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
#import "CollectionPageViewController.h"

@interface MainViewController ()

- (PatternViewController *)viewControllerAtPageIndex:(NSUInteger)pageIndex patternIndex:(NSUInteger)patternIndex;
@property (nonatomic) MenuTableViewController *menuTableView;
@property (nonatomic) CollectionPageViewController *collectionPageViewController;
@property (nonatomic) UIView *panGestureInterceptView;
@property (nonatomic) UIPanGestureRecognizer *rightPanGestureMenu;

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
    
    [self.view addSubview:self.menuTableView.view];

    self.collectionPageViewController = [[CollectionPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationVertical options:nil];
    [self.view addSubview:self.collectionPageViewController.view];
    
    //Need to load the next pageViewController so that when we swipe up, it already exists
    
        self.panGestureInterceptView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 568)];
        self.panGestureInterceptView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:self.panGestureInterceptView];

        UIScreenEdgePanGestureRecognizer *edgePanGesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(edgePanActivateMenu:)];
        edgePanGesture.edges = UIRectEdgeLeft;
        [self.panGestureInterceptView addGestureRecognizer:edgePanGesture];

        self.rightPanGestureMenu = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(rightEdgePanCloseMenu:)];

    
    
// TODO: make sure that the app can handle having a nil self.arrayPatternNames, if self.arrayPatternNames == nil, check request/run request again, then run function that needs it on complete? Not exactly sure how to handle these states. Maybe its recursive, on completion run the function that needs arrayPatterns, that function always checks if nil first (prevents breakage but also shouldnt run at all since it is only called on complete. Possible checks for timeout here
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

@end
