//
//  LJDefaultViewController.h
//  Logger
//
//  Created by Mitra Raman on 10/25/13.
//  Copyright (c) 2013 yeung.steph. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LJDefaultViewController : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *myHours;
@property (strong, nonatomic) IBOutlet UILabel *partnerHours;
- (IBAction)selectPartner:(id)sender;
- (IBAction)logHours:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *selectPartnerButton;

@end
