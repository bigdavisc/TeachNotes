//
//  ClassDetailViewController.h
//  TeachNotes With Parse
//
//  Created by Davis Carlson on 2014-06-08.
//  Copyright (c) 2014 Davis Carlson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <iAd/iAd.h>
#import <MessageUI/MessageUI.h>
#import "ActionSheetDatePicker.h"
#import "CustomIOS7AlertView.h"

@interface ClassDetailViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate, MFMailComposeViewControllerDelegate, UITextViewDelegate, UIPopoverControllerDelegate, UIAlertViewDelegate, UIPrintInteractionControllerDelegate,ADBannerViewDelegate> {
    PFQuery *queryTimes;
    NSMutableArray *objectTimesArray;
    NSMutableArray *tableViewArray;
    IBOutlet UIActivityIndicatorView *activityIndicator;
    IBOutlet UITableView *timesTable;
    
    IBOutlet UIButton *addNotesButton;
    IBOutlet UIButton *addLessonPlanButton;
    IBOutlet UILabel *startEnd;
    IBOutlet UILabel *teacherName;
    IBOutlet UILabel *nameLabel;
    IBOutlet UILabel *timeLabel;
    IBOutlet UILabel *notesHereLabel;
    IBOutlet UILabel *lessonViewTitle;
    IBOutlet UITextView *notes;
    IBOutlet UITextView *lessonView;
    IBOutlet UIScrollView *scrollView;
    IBOutlet UIBarButtonItem *addClass;
    IBOutlet UIButton *shareClass;
    IBOutlet UIButton *printClass;
    IBOutlet UILabel *lessonPlansAvailable;
    IBOutlet ADBannerView *adViewBanner;
    
    IBOutlet UIButton *save;
    
    NSIndexPath *indexOfSelectedRow;
}
@property (strong, nonatomic) id detailStart;
@property (strong, nonatomic) id detailEnd;
@property (strong, nonatomic) id detailTeacherName;
@property (strong, nonatomic) id detailObjectID;
@property (strong, nonatomic) id detailClass;
@property (strong, nonatomic) id detailUserID;
@property (strong, nonatomic) id detailTeacherEmail;

@property (nonatomic, retain) IBOutlet UIPopoverController *popoverController;


@property(weak, nonatomic) UIView *activeTextView;

-(void)getAllTimes;

@end

