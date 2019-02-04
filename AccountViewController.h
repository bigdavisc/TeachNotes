//
//  AccountViewController.h
//  TeachNotes With Parse
//
//  Created by Davis Carlson on 2014-06-06.
//  Copyright (c) 2014 Davis Carlson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
@interface AccountViewController : UIViewController {
    IBOutlet UITextField *username;
    IBOutlet UITextField *password;
}

-(IBAction)goHome:(id)sender;
@end
