//
//  ViewController.h
//  TeachNotes With Parse
//
//  Created by Davis Carlson on 2014-06-05.
//  Copyright (c) 2014 Davis Carlson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import <Parse/Parse.h>
#import "CustomLoginViewController.h"
#import "CustomSignupViewController.h"
#import "Reachability.h"
#import "PageChildViewController.h"

@interface ViewController : UIViewController <PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate, ADBannerViewDelegate> {
    IBOutlet UIButton *classes;
    IBOutlet UIButton *account;
    IBOutlet UILabel *welcome;
    IBOutlet UILabel *indexTest;
}

@property (nonatomic, strong) IBOutlet UILabel *welcomeLabel;

- (IBAction)logOutButtonTapAction:(id)sender;


@end

