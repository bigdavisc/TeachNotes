//
//  CustomSignupViewController.m
//  TeachNotes With Parse
//
//  Created by Davis Carlson on 2014-06-05.
//  Copyright (c) 2014 Davis Carlson. All rights reserved.
//

#import "CustomSignupViewController.h"
#import <QuartzCore/QuartzCore.h>
@interface CustomSignupViewController ()
@property (nonatomic, strong) UIImageView *fieldsBackground;
@end

@implementation CustomSignupViewController
@synthesize fieldsBackground;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.signUpView setLogo:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"teachnoteslogo.png"]]];
    [self.signUpView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"backgroundLG.png"]]];
    fieldsBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SUBG.png"]];
    [self.signUpView insertSubview:fieldsBackground atIndex:1];
    [self.signUpView.usernameField setTextColor:[UIColor whiteColor]];
    [self.signUpView.passwordField setTextColor:[UIColor whiteColor]];
    [self.signUpView.emailField setTextColor:[UIColor whiteColor]];
    
}
-(void)viewWillLayoutSubviews {
    [self.signUpView.usernameField setFrame:CGRectMake(35.0f, 125.0f, 250.0f, 50.0f)];
    [self.signUpView.passwordField setFrame:CGRectMake(35.0f, 175.0f, 250.0f, 50.0f)];
    [self.fieldsBackground setFrame:CGRectMake(150.0f, 230.0f, 240.0f, 150.0f)];
}

@end
