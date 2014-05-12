//
//  TestViewController.m
//  MobilePatterns
//
//  Created by Joseph Anderson on 4/29/14.
//  Copyright (c) 2014 yoshyosh. All rights reserved.
//

#import "TestViewController.h"
#import "MenuTableViewController.h"

@interface TestViewController ()
@property (nonatomic) UIView *testView;

@end

@implementation TestViewController

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
    
    self.testView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 568)];
    self.testView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.testView];
    
    UIScreenEdgePanGestureRecognizer *screenGestureRecognizer = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(panFromLeftEdge:)];
    screenGestureRecognizer.edges = UIRectEdgeLeft;
    [self.view addGestureRecognizer:screenGestureRecognizer];
    
    UIScreenEdgePanGestureRecognizer *screenGestureRecognizerRight = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(panFromRightEdge:)];
    screenGestureRecognizerRight.edges = UIRectEdgeRight;
    [self.view addGestureRecognizer:screenGestureRecognizerRight];
    //Multi gesture for right and left vs just using velocity to determine right or left
}

- (void)panFromLeftEdge:(UIScreenEdgePanGestureRecognizer *)panGesture {
    CGPoint point = [panGesture locationInView:self.view];
    if (panGesture.state == UIGestureRecognizerStateBegan) {
        NSLog(@"Started!!");
    } else if (panGesture.state == UIGestureRecognizerStateChanged){
        CGRect frame = CGRectMake(point.x, point.x/3, 320 - point.x/2.5, 568 - (2*point.x)/3);
        self.testView.frame = frame;
    } else if (panGesture.state == UIGestureRecognizerStateEnded){
        NSLog(@"ended");
        //If past a certain point animate to OPEN state
        //Else animate back to closed state
        if (point.x > 100) {
            [self animateMenuOpen];
        } else {
            [self animateMenuBack];
        }
    }
}

- (void)panFromRightEdge:(UIScreenEdgePanGestureRecognizer *)panGesture {
    CGPoint point = [panGesture locationInView:self.view];
    if (panGesture.state == UIGestureRecognizerStateBegan) {
        NSLog(@"Started!!");
    } else if (panGesture.state == UIGestureRecognizerStateChanged){
        CGRect frame = CGRectMake(point.x, point.x/3, 320 - point.x/2.5, 568 - (2*point.x)/3);
        self.testView.frame = frame;
    } else if (panGesture.state == UIGestureRecognizerStateEnded){
        NSLog(@"ended");
        //If past a certain point animate to OPEN state
        //Else animate back to closed state
            [self animateMenuBack];
    }
}

- (void)animateMenuBack {
    [UIView animateWithDuration:.5 animations:^{
        CGRect frame = CGRectMake(0, 0, 320, 568);
        self.testView.frame = frame;
    } completion:nil];
}

- (void)animateMenuOpen {
    [UIView animateWithDuration:.5 animations:^{
        CGRect frame = CGRectMake(280, 100, 207, 368);
        self.testView.frame = frame;
    } completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
