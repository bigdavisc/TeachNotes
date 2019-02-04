//
//  AccountViewController.m
//  TeachNotes With Parse
//
//  Created by Davis Carlson on 2014-06-06.
//  Copyright (c) 2014 Davis Carlson. All rights reserved.
//

#import "AccountViewController.h"

@interface AccountViewController ()

@end

@implementation AccountViewController

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
    // Do any additional setup after loading the view.

    username.text = [[PFUser currentUser]username];
    self.navigationController.navigationBarHidden = NO;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(IBAction)goHome:(id)sender {
    UIViewController *home = [self.storyboard instantiateViewControllerWithIdentifier:@"Home"];
    home.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:home animated:YES completion:nil];
}

-(IBAction)logOut:(id)sender {
    
    if ([PFUser currentUser]) {
        [PFUser logOut];
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }

}
-(IBAction)saveUser:(id)sender {
    
    PFUser *currentUser = [PFUser currentUser];
    PFQuery *query = [PFUser query];
    [query whereKey:@"username" equalTo:username.text];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        NSLog(@"%lu",(unsigned long)[objects count]);
        
        if ([username.text isEqual:currentUser.username]){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"You haven't made a change to your username" delegate:self cancelButtonTitle:@"Done" otherButtonTitles:nil];
            // optional - add more buttons:
            [alert show];
        } else if ([objects count] == 1) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"A user already has that username" delegate:self cancelButtonTitle:@"Try Again" otherButtonTitles:nil];
            // optional - add more buttons:
            [alert show];
        } else if ([objects count] < 1) {
            [[PFUser currentUser] setUsername:username.text];
            [[PFUser currentUser] saveInBackground];
            [self.view endEditing:YES];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Complete" message:@"Your username has been sucessfully changed" delegate:self cancelButtonTitle:@"Done" otherButtonTitles:nil];
            // optional - add more buttons:
            [alert show];
        }
    }];
}
-(IBAction)savePass:(id)sender {
    [[PFUser currentUser] setPassword:password.text];
    [[PFUser currentUser] saveInBackground];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Complete" message:@"Your Password Has Been Sucessfully Changed" delegate:self cancelButtonTitle:@"Done" otherButtonTitles:nil];
    // optional - add more buttons:
    [alert show];
}
@end
