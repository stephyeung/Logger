//
//  LJFriendViewController.m
//  Logger
//
//  Created by Stephanie Yeung on 10/26/13.
//  Copyright (c) 2013 yeung.steph. All rights reserved.
//

#import "LJFriendViewController.h"
#import "LJTableViewCell.h"

@interface LJFriendViewController ()
@property (nonatomic, strong) NSArray *users;
@property (nonatomic, strong) PFUser *selectedPartner;
@end

@implementation LJFriendViewController

static NSString * const cellIdentifier = @"LJTableViewCell";

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

+ (PFQuery *)queryForTable
{
    PFQuery *query = [PFUser query];
    query.cachePolicy = kPFCachePolicyNetworkElseCache;
    return query;
}

- (void)loadUsers
{
    PFQuery *query = [[self class] queryForTable];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        self.users = objects;
        [self.refreshControl endRefreshing];
    }];
}

- (void)cancelPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)selectPressed:(id)sender
{
    PFUser *currentUser = [PFUser currentUser];
    if (!currentUser[@"partner"]) {
        currentUser[@"partner"] = self.selectedPartner;
        [currentUser saveInBackground];
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self tableViewDidRequestRefresh];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView registerClass:[LJTableViewCell class] forCellReuseIdentifier:cellIdentifier];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                     style:UIBarButtonItemStylePlain
                                                                    target:self
                                                                    action:@selector(cancelPressed:)];
    UIBarButtonItem *selectButton = [[UIBarButtonItem alloc] initWithTitle:@"Select"
                                                                      style:UIBarButtonItemStyleDone
                                                                     target:self
                                                                     action:@selector(selectPressed:)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    self.navigationItem.rightBarButtonItem = selectButton;
    [self loadUsers];
}

- (void)setUsers:(NSArray *)users
{
    _users = users;
    [self.tableView reloadData];
}

- (void)tableViewDidRequestRefresh
{
    [self loadUsers];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.users.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    PFUser *user = [self.users objectAtIndex:indexPath.row];
    NSString *username = [user objectForKey:@"username"];
    cell.textLabel.text = username;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedPartner = self.users[indexPath.row];
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
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
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

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];

    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
 
 */

@end
