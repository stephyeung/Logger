//
//  LJLogHoursViewController.m
//  Logger
//
//  Created by Mitra Raman on 10/27/13.
//  Copyright (c) 2013 yeung.steph. All rights reserved.
//

#import <Parse/Parse.h>
#import "LJLogHoursViewController.h"
#import "LJDefaultViewController.h"

@interface LJLogHoursViewController ()
@property (assign, nonatomic) BOOL keyboardIsShowing;
@end

@implementation LJLogHoursViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)keyboardUp
{
    self.keyboardIsShowing = YES;
}

- (void)tap:(UITapGestureRecognizer *)recognizer
{
    if (self.keyboardIsShowing) {
        [self.numberOfHours resignFirstResponder];
    }
    self.keyboardIsShowing = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.numberOfHours setKeyboardType:UIKeyboardTypeNumberPad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardUp) name:UIKeyboardWillShowNotification object:nil];
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self.view addGestureRecognizer:tapRecognizer];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)submitHours:(id)sender
{
    PFUser *currentUser = [PFUser currentUser];
    int hours = [self.numberOfHours.text intValue];
    int storedHours = [[currentUser objectForKey:@"hours"] intValue];
    int totalHours = storedHours + hours;
    [currentUser setObject:[NSNumber numberWithInt:totalHours] forKey:@"hours"];
    [currentUser saveInBackground];
    LJDefaultViewController *defaultVC = [[LJDefaultViewController alloc] initWithNibName:@"LJDefaultViewController" bundle:nil];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:defaultVC];
    [self presentViewController:navController animated:YES completion:nil];
}
@end
