//
//  AddClassViewController.h
//  TeachNotes With Parse
//
//  Created by Davis Carlson on 2014-06-06.
//  Copyright (c) 2014 Davis Carlson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "ClassListViewController.h"
#import "ZBarSDK.h"

@interface AddClassViewController : UIViewController <UITextFieldDelegate, UIAlertViewDelegate, ZBarReaderDelegate> {
    IBOutlet UITextField *teacherName;
    IBOutlet UITextField *teacherEmail;
    IBOutlet UITextField *teacherClassName;
    IBOutlet UITextField *classCode;
    IBOutlet UILabel *endLabel;
    IBOutlet UIDatePicker *timePickerEnd;
    IBOutlet UIDatePicker *timePickerStart;
    
    UIActivityIndicatorView *activityIndicator;
    
    NSString *startTimePickerString;
    NSString *endTimePickerString;
    
    NSString *barcode;
}
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@end

