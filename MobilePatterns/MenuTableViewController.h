//
//  MenuTableViewController.h
//  MobilePatterns
//
//  Created by Joseph Anderson on 4/28/14.
//  Copyright (c) 2014 yoshyosh. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MenuTableViewControllerDelegate <NSObject>

- (void)replaceWithTaggedItems:(NSArray *)arrayOfTaggedPatterns;

@end

@interface MenuTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, weak) id <MenuTableViewControllerDelegate> delegate;
@end
