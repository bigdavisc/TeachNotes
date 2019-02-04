//
//  AppDelegate.m
//  TeachNotes With Parse
//
//  Created by Davis Carlson on 2014-06-05.
//  Copyright (c) 2014 Davis Carlson. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>
@interface AppDelegate ()
            

@end

@implementation AppDelegate
            

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [Parse setApplicationId:@"""
                  clientKey:@""];
    
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    [application registerForRemoteNotificationTypes:
     UIRemoteNotificationTypeBadge |
     UIRemoteNotificationTypeAlert |
     UIRemoteNotificationTypeSound];
    
    return YES;
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    // Display text
    if ([PFUser currentUser]) {
    code = [[url host] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //----------------------------------------------------------------------------------------
        PFQuery *query = [PFQuery queryWithClassName:@"Classes"];
        
        [query getObjectInBackgroundWithId:code block:^(PFObject *object, NSError *error) {
            if (!object) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"That is not a Valid Class Code. Please Try Again" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
                // optional - add more buttons:
                [alert show];
            } else {
        
        
    [query getObjectInBackgroundWithId:code block:^(PFObject *object, NSError *error) {
        teacherName = object[@"teacherName"];
        className = object[@"classname_number"];
        
        NSString *message = [NSString stringWithFormat:@"Would You Like To Add The Class:\n\nName: %@\nTeacher: %@\n\n To Your Class List?",className,teacherName];
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Add Class" message:message delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
        alertView.tag = 1;
        [alertView show];
    }];
  }
}];
    } else {
       UIAlertView *alertView2 = [[UIAlertView alloc]initWithTitle:@"Error" message:@"You Are Not Currently Logged In. Please Log In or Sign Up to Use This Class Code" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView2 show];
    }
    return YES;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([alertView tag] == 1) {
    if (buttonIndex == 1) {
        PFQuery *query = [PFQuery queryWithClassName:@"Classes"];
        
        [query getObjectInBackgroundWithId:code block:^(PFObject *object, NSError *error) {
            if (!object) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"That is not a Valid Class Code. Please Try Again" delegate:self cancelButtonTitle:@"Try Again" otherButtonTitles:nil];
                // optional - add more buttons:
                [alert show];
            } else {
                [object addObject:[[PFUser currentUser] objectId] forKey:@"addedTeachers"];
                [object saveInBackground];
            }
        }];
        
    }
  }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    if (currentInstallation.badge != 0) {
        currentInstallation.badge = 0;
        [currentInstallation saveEventually];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)newDeviceToken {
    // Store the deviceToken in the current installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:newDeviceToken];
    [currentInstallation saveInBackground];
}
- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [PFPush handlePush:userInfo];
}
@end
