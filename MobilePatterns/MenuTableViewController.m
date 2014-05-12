//
//  MenuTableViewController.m
//  MobilePatterns
//
//  Created by Joseph Anderson on 4/28/14.
//  Copyright (c) 2014 yoshyosh. All rights reserved.
//

#import "MenuTableViewController.h"
#import "MenuTableViewCell.h"

@interface MenuTableViewController ()
@property (strong, nonatomic) IBOutlet UITableView *menuTableView;
@property (nonatomic) NSArray *menuTableItems;

@end

@implementation MenuTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.menuTableView.dataSource = self;
    self.menuTableView.delegate = self;
    
    self.menuTableItems = [[NSArray alloc] initWithObjects:@"RECENTLY ADDED", @"CALENDAR", @"CAMERA CONTROLLER", @"COACH MARKS", @"COMMENT COMPOSE", @"COMPOSE SCREENS", @"CUSTOM NAVIGATION", @"DETAIL VIEWS", @"EMPTY DATA SETS", @"FEEDS", @"LISTS", @"LOG IN", @"MAPS", @"GALLERIES", @"POPOVERS", @"SEARCH", @"SETTINGS", @"SIGN UP FLOWS", @"SPLASH SCREENS", @"STATS", @"TIMELINES", @"USER PROFILES", @"WALKTHROUGHS", nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.menuTableItems.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCell"];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"MenuTableViewCell" bundle:nil] forCellReuseIdentifier:@"myCell"]; //What exactly is happening here
        cell = [tableView dequeueReusableCellWithIdentifier:@"myCell"];
    }
    
    cell.menuLabel.text = [NSString stringWithFormat:@"%@", self.menuTableItems[indexPath.row]];
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here, for example:
    // Create the next view controller.
    //<#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    NSLog(@"Selected at row %ld", (long)indexPath.row);
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    //[self.navigationController pushViewController:detailViewController animated:YES];
}


@end
