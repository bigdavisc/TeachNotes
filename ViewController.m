//
//  ViewController.m
//  TeachNotes With Parse
//
//  Created by Davis Carlson on 2014-06-05.
//  Copyright (c) 2014 Davis Carlson. All rights reserved.
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>
@interface ViewController ()
            

@end

@implementation ViewController
            
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    
    if ([PFUser currentUser]) {
        self.canDisplayBannerAds = YES;
        self.welcomeLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Welcome %@!", nil), [[PFUser currentUser] username]];
        welcome.text = [NSString stringWithFormat:@"Welcome, %@",[[PFUser currentUser] username]];
    } else {
        self.welcomeLabel.text = NSLocalizedString(@"Not logged in", nil);
        welcome.text = [NSString stringWithFormat:@"Not Logged In"];
    }
    self.navigationController.navigationBarHidden = YES;
    
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    typedef enum
    {
        // Apple NetworkStatus Compatible Names.
        NotReachable     = 0,
        ReachableViaWiFi = 2,
        ReachableViaWWAN = 1
    } NetworkStatus;
    if (internetStatus == NotReachable) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Internet" message:@"Sorry, But there seems to be a problem with your internet connection. Some of your information will be unobtainable without internet. Please connect to unlock the full funtionality of this app" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        // optional - add more buttons:
        [alert show];
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.jpg"]];
    classes.layer.cornerRadius = 6.0f;
    account.layer.cornerRadius = 6.0f;
    classes.layer.shadowColor = [UIColor grayColor].CGColor;
    classes.layer.shadowOpacity = 0.8;
    classes.layer.shadowRadius = 12;
    classes.layer.shadowOffset = CGSizeMake(12.0f, 12.0f);
    account.layer.shadowColor = [UIColor grayColor].CGColor;
    account.layer.shadowOpacity = 0.8;
    account.layer.shadowRadius = 12;
    account.layer.shadowOffset = CGSizeMake(12.0f, 12.0f);

    
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // Check if user is logged in
    if (![PFUser currentUser]) {
        // Customize the Log In View Controller
        CustomLoginViewController *logInViewController = [[CustomLoginViewController alloc] init];
        logInViewController.delegate = self;
        logInViewController.fields = PFLogInFieldsUsernameAndPassword | PFLogInFieldsSignUpButton | PFLogInFieldsLogInButton | PFLogInFieldsPasswordForgotten;
        
        // Customize the Sign Up View Controller
        CustomSignupViewController *signUpViewController = [[CustomSignupViewController alloc] init];
        signUpViewController.delegate = self;
        signUpViewController.fields = PFSignUpFieldsDefault;
        logInViewController.signUpController = signUpViewController;
        
        // Present Log In View Controller
        logInViewController.modalPresentationStyle = UIModalPresentationFormSheet;
        signUpViewController.modalPresentationStyle = UIModalPresentationFormSheet;
        signUpViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self presentViewController:logInViewController animated:YES completion:NULL];
    }
    
}


#pragma mark - PFLogInViewControllerDelegate

// Sent to the delegate to determine whether the log in request should be submitted to the server.
- (BOOL)logInViewController:(PFLogInViewController *)logInController shouldBeginLogInWithUsername:(NSString *)username password:(NSString *)password {
    if (username && password && username.length && password.length) {
        return YES;
    }
    
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Missing Information", nil) message:NSLocalizedString(@"Make sure you fill out all of the information!", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
    return NO;
}

// Sent to the delegate when a PFUser is logged in.
- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
    [self dismissViewControllerAnimated:YES completion:NULL];
    [self viewWillAppear:YES];
}

// Sent to the delegate when the log in attempt fails.
- (void)logInViewController:(PFLogInViewController *)logInController didFailToLogInWithError:(NSError *)error {
    NSLog(@"Failed to log in...");

    [logInController.logInView.usernameField setTextColor:[UIColor redColor]];
    [logInController.logInView.passwordField setTextColor:[UIColor redColor]];
}

// Sent to the delegate when the log in screen is dismissed.
- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController {
    NSLog(@"User dismissed the logInViewController");
}


#pragma mark - PFSignUpViewControllerDelegate

// Sent to the delegate to determine whether the sign up request should be submitted to the server.
- (BOOL)signUpViewController:(PFSignUpViewController *)signUpController shouldBeginSignUp:(NSDictionary *)info {
    BOOL informationComplete = YES;
    for (id key in info) {
        NSString *field = [info objectForKey:key];
        if (!field || field.length == 0) {
            informationComplete = NO;
            break;
        }
    }
    
    if (!informationComplete) {
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Missing Information", nil) message:NSLocalizedString(@"Make sure you fill out all of the information!", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
    }
    
    return informationComplete;
}

// Sent to the delegate when a PFUser is signed up.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user {
    [self viewWillAppear:YES];
    [self dismissViewControllerAnimated:YES completion:NULL];
}

// Sent to the delegate when the sign up attempt fails.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didFailToSignUpWithError:(NSError *)error {
    NSLog(@"Failed to sign up...");
}

// Sent to the delegate when the sign up screen is dismissed.
- (void)signUpViewControllerDidCancelSignUp:(PFSignUpViewController *)signUpController {
    NSLog(@"User dismissed the signUpViewController");
}


#pragma mark - ()

- (IBAction)logOutButtonTapAction:(id)sender {
    if ([PFUser currentUser]) {
    [PFUser logOut];
        [self viewDidAppear:YES];
    }
}
-(void)loadTutorial {
    UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    
    viewController.modalPresentationStyle = UIModalPresentationFormSheet;
    
    [self presentViewController:viewController animated:YES completion:nil];
}

//-------------------------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------------------------

-(IBAction)review:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/app/id887935357"]];
}
-(IBAction)contact:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"mailto:teachnotes@daviscarlson.com"]];
}
@end
