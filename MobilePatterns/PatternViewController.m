//
//  PatternViewController.m
//  MobilePatterns
//
//  Created by Joseph Anderson on 4/18/14.
//  Copyright (c) 2014 yoshyosh. All rights reserved.
//

#import "PatternViewController.h"
#import "UIImageView+AFNetworking.h"

@interface PatternViewController ()

@end

@implementation PatternViewController

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
    [self.screenImage setImageWithURL:self.imageURL];
    self.appNameLabel.text = self.appName;
    self.tagsLabel.text = self.tagString;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
