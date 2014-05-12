//
//  PatternViewController.h
//  MobilePatterns
//
//  Created by Joseph Anderson on 4/18/14.
//  Copyright (c) 2014 yoshyosh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PatternViewController : UIViewController
@property (nonatomic) NSInteger index;
@property (strong, nonatomic) IBOutlet UILabel *screenLabel;
@property (strong, nonatomic) IBOutlet UIImageView *screenImage;
@property (strong, nonatomic) IBOutlet UIView *previewView;
@property (strong, nonatomic) IBOutlet UILabel *appNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *tagsLabel;
@property (nonatomic) NSString *appName;
@property (nonatomic) NSString *tagString;
@property (nonatomic) NSURL *imageURL;
@end
