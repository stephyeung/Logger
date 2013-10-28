//
//  LJDefaultViewController.m
//  Logger
//
//  Created by Mitra Raman on 10/25/13.
//  Copyright (c) 2013 yeung.steph. All rights reserved.
//

#import <Parse/Parse.h>
#import "LJDefaultViewController.h"
#import "LJFriendViewController.h"
#import "LJLogHoursViewController.h"

@interface LJDefaultViewController () <PFLogInViewControllerDelegate,
                                        PFSignUpViewControllerDelegate>

@end

@implementation LJDefaultViewController

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
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)selectPartner:(id)sender {
    LJFriendViewController *friendVC = [[LJFriendViewController alloc] initWithNibName:@"LJFriendViewController" bundle:nil];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:friendVC];
    [self presentViewController:navController animated:YES completion:nil];
}

- (void)displayPartnerHours:(PFUser *)user {
    int hours = [[user objectForKey:@"hours"] intValue];
    self.partnerHours.text = [NSString stringWithFormat:@"%d", hours];
}

- (void)userHasPartner
{
    PFUser *currentUser = [PFUser currentUser];
    PFUser *partner = [currentUser objectForKey:@"partner"];
    if (!partner) {
        self.partnerHours.hidden = YES;
        self.selectPartnerButton.hidden = NO;
    } else {
        self.partnerHours.hidden = NO;
        self.selectPartnerButton.hidden = YES;
        [self displayPartnerHours:partner];
    }
}

- (void)displayUserHours
{
    PFUser *currentUser = [PFUser currentUser];
    int hours = [[currentUser objectForKey:@"hours"] intValue];
    self.myHours.text = [NSString stringWithFormat:@"%d", hours];
}

- (void)populateDataForUser
{
    [self userHasPartner];
    [self displayUserHours];
}

- (void)setUserData
{
    PFUser *currentUser = [PFUser currentUser];
    [currentUser setObject:[NSNumber numberWithInt:0] forKey:@"hours"];
    [currentUser saveInBackground];
}

- (IBAction)logHours:(id)sender
{
    LJLogHoursViewController *logHoursVC = [[LJLogHoursViewController alloc] initWithNibName:@"LJLogHoursViewController" bundle:nil];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:logHoursVC];
    [self presentViewController:navController animated:YES completion:nil];
}

/*****************************************************************
 *                          LOGIN VIEW                           *
 *****************************************************************/

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (![PFUser currentUser]) {
        // Customize the Log In View Controller
        PFLogInViewController *logInViewController = [[PFLogInViewController alloc] init];
        logInViewController.delegate = self;
        
        // Create the sign up view controller
        PFSignUpViewController *signUpViewController = [[PFSignUpViewController alloc] init];
        [signUpViewController setDelegate:self]; // Set ourselves as the delegate
        
        // Assign our sign up controller to be displayed from the login controller
        [logInViewController setSignUpController:signUpViewController];
        
        // Present the log in view controller
        [self presentViewController:logInViewController animated:YES completion:nil];
    }
    else {
        [self populateDataForUser];
    }
}

#pragma mark -
#pragma mark PFLoginViewControllerDelegate

// Sent to the delegate to determine whether the log in request should be submitted to the server.
- (BOOL)logInViewController:(PFLogInViewController *)logInController
shouldBeginLogInWithUsername:(NSString *)username
                   password:(NSString *)password
{
    // Check if both fields are completed
    if (username && password && username.length != 0 && password.length != 0) {
        return YES; // Begin login process
    }
    
    [[[UIAlertView alloc] initWithTitle:@"Missing Information"
                                message:@"Make sure you fill out all of the information!"
                               delegate:nil
                      cancelButtonTitle:@"ok"
                      otherButtonTitles:nil] show];
    return NO; // Interrupt login process
}

// Sent to the delegate when a PFUser is logged in.
- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user
{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self populateDataForUser];
}

// Sent to the delegate when the log in attempt fails.
- (void)logInViewController:(PFLogInViewController *)logInController didFailToLogInWithError:(NSError *)error {
    NSLog(@"Failed to log in...");
}

// Sent to the delegate when the log in screen is dismissed.
- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark PFSignUpViewControllerDelegate
// Sent to the delegate to determine whether the sign up request should be submitted to the server.
- (BOOL)signUpViewController:(PFSignUpViewController *)signUpController
           shouldBeginSignUp:(NSDictionary *)info
{
    BOOL informationComplete = YES;
    
    // loop through all of the submitted data
    for (id key in info) {
        NSString *field = [info objectForKey:key];
        if (!field || field.length == 0) { // check completion
            informationComplete = NO;
            break;
        }
    }
    
    // Display an alert if a field wasn't completed
    if (!informationComplete) {
        [[[UIAlertView alloc] initWithTitle:@"Missing Information"
                                    message:@"Make sure you fill out all of the information!"
                                   delegate:nil
                          cancelButtonTitle:@"ok"
                          otherButtonTitles:nil] show];
    }
    
    return informationComplete;
}

// Sent to the delegate when a PFUser is signed up.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user
{
    [self dismissViewControllerAnimated:YES completion:nil]; // Dismiss the PFSignUpViewController
    [self populateDataForUser];
    [self setUserData];
}

// Sent to the delegate when the sign up attempt fails.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didFailToSignUpWithError:(NSError *)error
{
    NSLog(@"Failed to sign up...");
}

// Sent to the delegate when the sign up screen is dismissed.
- (void)signUpViewControllerDidCancelSignUp:(PFSignUpViewController *)signUpController {
    NSLog(@"User dismissed the signUpViewController");
}

@end
