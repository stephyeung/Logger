//
//  LJLogHoursViewController.h
//  Logger
//
//  Created by Mitra Raman on 10/27/13.
//  Copyright (c) 2013 yeung.steph. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LJLogHoursViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (strong, nonatomic) IBOutlet UITextField *numberOfHours;
- (IBAction)submitHours:(id)sender;
@end
