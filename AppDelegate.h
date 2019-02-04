//
//  AppDelegate.h
//  TeachNotes With Parse
//
//  Created by Davis Carlson on 2014-06-05.
//  Copyright (c) 2014 Davis Carlson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import <Parse/Parse.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, UIAlertViewDelegate> {
    NSString *code;
    NSString *className;
    NSString *teacherName;
}

@property (strong, nonatomic) UIWindow *window;


@end

