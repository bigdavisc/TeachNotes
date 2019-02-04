//
//  ClassDetailViewController.m
//  TeachNotes With Parse
//
//  Created by Davis Carlson on 2014-06-08.
//  Copyright (c) 2014 Davis Carlson. All rights reserved.
//

#import "ClassDetailViewController.h"

@interface ClassDetailViewController () {
    BOOL _bannerIsVisible;
}

@end

@implementation ClassDetailViewController
@synthesize popoverController;
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.jpg"]];
    // Do any additional setup after loading the view.
    [timesTable setDelegate:self];
    [timesTable setDataSource:self];
    notes.layer.borderColor = [[UIColor blackColor] CGColor];
    notes.layer.borderWidth = 2.0f;
    lessonView.layer.borderColor = [[UIColor blackColor] CGColor];
    lessonView.layer.borderWidth = 1.0f;

    self.canDisplayBannerAds = YES;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    notes.delegate = self;

    
    lessonPlansAvailable.hidden = YES;
    self.title = self.detailClass;
    notes.hidden = YES;
    notesHereLabel.hidden = YES;
    save.hidden = YES;
    printClass.hidden = YES;
    lessonViewTitle.hidden = YES;
    lessonView.hidden = YES;
    addNotesButton.hidden = YES;
    [self getAllTimes];

    startEnd.text = [NSString stringWithFormat:@"%@ - %@", self.detailStart, self.detailEnd];
    teacherName.text = self.detailTeacherName;
    
    //----------------------------------------------------------------------------------------
    
    PFUser *user = [PFUser currentUser];
    PFQuery *query = [PFQuery queryWithClassName:@"Classes"];
    [query getObjectInBackgroundWithId:self.detailObjectID block:^(PFObject *object, NSError *error) {
        if (![object[@"primaryTeacher"] isEqualToString:user.objectId]) {
            shareClass.hidden = YES;
        }
    }];
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
        CGPoint scrollPoint = CGPointMake(0.0, 300.0);
        
        [scrollView setContentOffset:scrollPoint animated:YES];
    
}

- (void)textViewDidEndEditing:(UITextView *)textView {

    [scrollView setContentOffset:CGPointZero animated:YES];
  
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

-(void)getAllTimes {
    
    queryTimes = [PFQuery queryWithClassName:@"ClassNotes"];
    [queryTimes whereKey:@"classID" equalTo:self.detailObjectID];
    [queryTimes whereKey:@"deleted" equalTo:@NO];
    [queryTimes findObjectsInBackgroundWithBlock:^(NSArray *objectsT, NSError *error) {
        if (!error) {
            objectTimesArray = [[NSMutableArray alloc] initWithArray:objectsT];
            NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:TRUE];
            [objectTimesArray sortUsingDescriptors:[NSMutableArray arrayWithObject:sortDescriptor]];
            [timesTable reloadData];
            
            if (indexOfSelectedRow) {
                [timesTable selectRowAtIndexPath:indexOfSelectedRow animated:NO scrollPosition:UITableViewScrollPositionNone];
            }
        }
    }];

}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [objectTimesArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Times";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    PFObject *post = [objectTimesArray objectAtIndex:indexPath.row];
    [cell.textLabel setText:[post objectForKey:@"date"]];
    return cell;
}

-(IBAction)addNewNotes:(id)sender {
    ActionSheetDatePicker *datePicker = [[ActionSheetDatePicker alloc] initWithTitle:@"Set The Class Date" datePickerMode:UIDatePickerModeDate selectedDate:[NSDate date] target:self action:@selector(addTheNewNote:) origin:sender];
    
    [datePicker showActionSheetPicker];

}

-(void)addTheNewNote:(NSDate *)newDate {
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MMMM dd, yyyy"];
    NSString *dateString = [NSString stringWithString:[dateFormat stringFromDate:newDate]];
    
    PFObject *newNote = [PFObject objectWithClassName:@"ClassNotes"];
    newNote[@"date"] = dateString;
    newNote[@"userID"] = self.detailUserID;
    newNote[@"classID"] = self.detailObjectID;
    newNote[@"deleted"] = @NO;
    [newNote saveInBackground];
    [self performSelector:@selector(getTheData) withObject:self afterDelay:1.0];
    [self performSelector:@selector(reloadTheData) withObject:self afterDelay:1.0];
    
}
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Hi");
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
        [self userSelectedRow:indexPath];
    
    PFObject *post = [objectTimesArray objectAtIndex:indexPath.row];
    NSString *Objectid = [post objectId];
    indexOfSelectedRow =[NSIndexPath indexPathForRow:indexPath.row inSection:0];
    
    
    notes.hidden = NO;
    notesHereLabel.hidden = NO;
    save.hidden = NO;

    //printClass.hidden = NO;
    
    PFUser *user = [PFUser currentUser];
    PFQuery *query = [PFQuery queryWithClassName:@"Classes"];
    [query getObjectInBackgroundWithId:self.detailObjectID block:^(PFObject *object, NSError *error) {
        if ([object[@"primaryTeacher"] isEqualToString:user.objectId]) {
            lessonViewTitle.hidden = NO;
            lessonView.hidden = NO;
            lessonViewTitle.text = @"Type Your Lesson Plans Below";
            lessonView.editable = YES;
            lessonView.backgroundColor = [UIColor whiteColor];
        } else {
            
            PFQuery *query = [PFQuery queryWithClassName:@"ClassNotes"];
            [query getObjectInBackgroundWithId:Objectid block:^(PFObject *object, NSError *error) {
                if ([object[@"lessonPlan"] isEqualToString:@""] || ![object objectForKey:@"lessonPlan"]) {
                    lessonView.hidden = YES;
                    lessonPlansAvailable.hidden = NO;
                    addLessonPlanButton.hidden = YES;
                } else {
                    lessonViewTitle.hidden = NO;
                    lessonView.hidden = NO;
                    lessonViewTitle.text = @"Here Are Todays Lesson Plans";
                    lessonView.editable = NO;
                }
            }];
            
        }
    }];
    save.hidden = NO;
}

- (void)userSelectedRow:(NSIndexPath *)indexPath {
    PFObject *post2 = [objectTimesArray objectAtIndex:indexPath.row];
    notes.text = [post2 objectForKey:@"notes"];
    lessonView.text = [post2 objectForKey:@"lessonPlan"];
}

-(IBAction)saveAndSend:(id)sender {
    PFQuery *query = [PFQuery queryWithClassName:@"Classes"];
    [query getObjectInBackgroundWithId:self.detailObjectID block:^(PFObject *object, NSError *error) {
            PFQuery *querySave = [PFQuery queryWithClassName:@"ClassNotes"];
            NSIndexPath *index = timesTable.indexPathForSelectedRow;
            PFObject *post = [objectTimesArray objectAtIndex:index.row];
            NSString *Objectid = [post objectId];
            [querySave getObjectInBackgroundWithId:Objectid block:^(PFObject *notesObject, NSError *error) {
                notesObject[@"notes"] = notes.text;
                notesObject[@"lessonPlan"] = lessonView.text;
                [notesObject saveInBackground];
                  }];
            
            [self.view endEditing:YES];
            
            activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
            activityIndicator.transform = CGAffineTransformMakeScale(1.5, 1.5);
            activityIndicator.frame = CGRectMake(0.0, 0.0, 150.0, 100.0);
            activityIndicator.center = self.view.center;
            [activityIndicator.layer setCornerRadius:8];
            activityIndicator.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8f];
            [self.view addSubview:activityIndicator];
            [activityIndicator startAnimating];
            
            [self performSelector:@selector(reloadTheTable) withObject:self afterDelay:1.0];

    }];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    
if ([buttonTitle isEqualToString:@"Save"]) {
    PFQuery *querySave = [PFQuery queryWithClassName:@"ClassNotes"];
    NSIndexPath *index = timesTable.indexPathForSelectedRow;
    PFObject *post = [objectTimesArray objectAtIndex:index.row];
    NSString *Objectid = [post objectId];
    [querySave getObjectInBackgroundWithId:Objectid block:^(PFObject *notesObject, NSError *error) {
        notesObject[@"notes"] = notes.text;
        notesObject[@"lessonPlan"] = lessonView.text;
        [notesObject saveInBackground];
    }];
    
    [self.view endEditing:YES];
    
    activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    activityIndicator.transform = CGAffineTransformMakeScale(1.5, 1.5);
	activityIndicator.frame = CGRectMake(0.0, 0.0, 150.0, 100.0);
	activityIndicator.center = self.view.center;
    [activityIndicator.layer setCornerRadius:8];
    activityIndicator.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8f];
    [self.view addSubview:activityIndicator];
    [activityIndicator startAnimating];
    
    [self performSelector:@selector(reloadTheTable) withObject:self afterDelay:1.0];
    
}
//---------
if ([buttonTitle isEqualToString:@"Save and Send"]) {
    
    PFQuery *querySave = [PFQuery queryWithClassName:@"ClassNotes"];
    NSIndexPath *index = timesTable.indexPathForSelectedRow;
    PFObject *post = [objectTimesArray objectAtIndex:index.row];
    NSString *dateString = [post objectForKey:@"date"];
    NSString *Objectid = [post objectId];
    [querySave getObjectInBackgroundWithId:Objectid block:^(PFObject *notesObject, NSError *error) {
        notesObject[@"notes"] = notes.text;
        [notesObject saveInBackground];
    }];
    
    [self.view endEditing:YES];
    
    NSString *emailTitle = [NSString stringWithFormat:@"Class Notes For %@",dateString];
    // Email Content
    NSString *messageBody = [NSString stringWithFormat:@"%@,\n Here was the Lesson Plan from the %@ class on %@:\n\n %@. \n\n Here are the notes for this class. \n\n %@ \n\nThank You For Using TeachNotes",self.detailTeacherName,self.detailClass,dateString,lessonView.text, notes.text];
    // To address
    NSArray *toRecipents = [NSArray arrayWithObject:self.detailTeacherEmail];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    [mc setToRecipients:toRecipents];
    
    // Present mail view controller on screen
    [self presentViewController:mc animated:YES completion:NULL];
    
    [self performSelector:@selector(reloadTheTable) withObject:self afterDelay:1.0];
}
    //-------------
}
- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}
-(void)reloadTheTable {
    [self getAllTimes];
    [activityIndicator stopAnimating];
    [activityIndicator removeFromSuperview];
    
}
-(void)reselectRow {
    [timesTable selectRowAtIndexPath:indexOfSelectedRow animated:YES scrollPosition:UITableViewScrollPositionNone];
}

-(void)reloadTheData {
    [timesTable reloadData];

}
-(void)getTheData {
    [self getAllTimes];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        PFObject *post = [objectTimesArray objectAtIndex:indexPath.row];
        NSString *Objectid = [post objectId];
        PFQuery *query = [PFQuery queryWithClassName:@"ClassNotes"];
        [query getObjectInBackgroundWithId:Objectid block:^(PFObject *object, NSError *error) {
            object[@"deleted"] = @YES;
            [object saveInBackground];
        }];
        [objectTimesArray removeObjectAtIndex:indexPath.row];
        [timesTable deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:YES];
        [self performSelector:@selector(getTheData) withObject:self afterDelay:1.0];
        
    }
}


- (CIImage *)createQRForString:(NSString *)qrString
{
    // Need to convert the string to a UTF-8 encoded NSData object
    NSData *stringData = [qrString dataUsingEncoding:NSUTF8StringEncoding];
    
    // Create the filter
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // Set the message content and error-correction level
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    [qrFilter setValue:@"H" forKey:@"inputCorrectionLevel"];
    
    // Send the image back
    return qrFilter.outputImage;
}
- (UIImage *)createNonInterpolatedUIImageFromCIImage:(CIImage *)image withScale:(CGFloat)scale
{
    // Render the CIImage into a CGImage
    CGImageRef cgImage = [[CIContext contextWithOptions:nil] createCGImage:image fromRect:image.extent];
    
    // Now we'll rescale using CoreGraphics
    UIGraphicsBeginImageContext(CGSizeMake(image.extent.size.width * scale, image.extent.size.width * scale));
    CGContextRef context = UIGraphicsGetCurrentContext();
    // We don't want to interpolate (since we've got a pixel-correct image)
    CGContextSetInterpolationQuality(context, kCGInterpolationNone);
    CGContextDrawImage(context, CGContextGetClipBoundingBox(context), cgImage);
    // Get the image out
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // Tidy up
    UIGraphicsEndImageContext();
    CGImageRelease(cgImage);
    return scaledImage;
}
- (IBAction)shareTheClass:(id)sender {
    NSString *message = [NSString stringWithFormat:@"Class Code:\n %@ \n\nHave the person you want to share this class with, enter this code in the \"Add A Class\" Menu or have them scan a QR Code",self.detailObjectID];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Share This Class" message:message delegate:self cancelButtonTitle:@"Done" otherButtonTitles:@"QR Code",nil];
    // optional - add more buttons:
    alert.tag = 1;
    [alert show];
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([alertView tag] == 1) {
        if (buttonIndex == 1) {
            // Disable the UI
            
            // Get the string
            NSString *stringToEncode = self.detailObjectID;
            
            // Generate the image
            CIImage *qrCode = [self createQRForString:stringToEncode];
            
            // Convert to an UIImage
            UIImage *qrCodeImg = [self createNonInterpolatedUIImageFromCIImage:qrCode withScale:4*[[UIScreen mainScreen] scale]];
            
            qrCodeImg = [UIImage imageWithData:UIImageJPEGRepresentation(qrCodeImg, 1.0)];
            CGImageRef rawImageRef=qrCodeImg.CGImage;
            //RGB color range to mask (make transparent)  R-Low, R-High, G-Low, G-High, B-Low, B-High
            const CGFloat colorMasking[6] = {222, 255, 222, 255, 222, 255};
            
            UIGraphicsBeginImageContext(qrCodeImg.size);
            CGImageRef maskedImageRef=CGImageCreateWithMaskingColors(rawImageRef, colorMasking);
            
            //iPhone translation
            CGContextTranslateCTM(UIGraphicsGetCurrentContext(), 0.0, qrCodeImg.size.height);
            CGContextScaleCTM(UIGraphicsGetCurrentContext(), 1.0, -1.0);
            
            CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, qrCodeImg.size.width, qrCodeImg.size.height), maskedImageRef);
            UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
            CGImageRelease(maskedImageRef);
            UIGraphicsEndImageContext();
            
            UIImageView* qrcodeImageView = [[UIImageView alloc] initWithImage:result];
            
            CustomIOS7AlertView *alertViewCustom = [[CustomIOS7AlertView alloc] init];
            
            qrcodeImageView.backgroundColor = [UIColor clearColor];
            
            [alertViewCustom setContainerView:qrcodeImageView];
            
            [alertViewCustom show];
        }
    }
}


-(IBAction)printDetail:(id)sender {
    NSIndexPath *index = timesTable.indexPathForSelectedRow;
    PFObject *post = [objectTimesArray objectAtIndex:index.row];
    NSString *Objectid = [post objectId];
    PFQuery *query = [PFQuery queryWithClassName:@"ClassNotes"];
    [query getObjectInBackgroundWithId:Objectid block:^(PFObject *object, NSError *error) {
    
        NSString *lessonPlan = object[@"lessonPlan"];
        NSString *notesText = object[@"notes"];
        
    NSMutableString *printBody = [NSMutableString stringWithFormat:@"Lesson Plan: %@\n\nClass Notes: %@",lessonPlan, notesText];
    [printBody appendFormat:@"\n\n\n\n\n\n\n\nPrinted From TeachNotes"];
    
    UIPrintInteractionController *pic = [UIPrintInteractionController sharedPrintController];
    pic.delegate = self;
    
    UIPrintInfo *printInfo = [UIPrintInfo printInfo];
    printInfo.outputType = UIPrintInfoOutputGeneral;
        printInfo.jobName = object[@"date"];
    pic.printInfo = printInfo;
    
    UISimpleTextPrintFormatter *textFormatter = [[UISimpleTextPrintFormatter alloc] initWithText:printBody];
    textFormatter.startPage = 0;
    textFormatter.contentInsets = UIEdgeInsetsMake(72.0, 72.0, 72.0, 72.0); // 1 inch margins
    textFormatter.maximumContentWidth = 6 * 72.0;
    pic.printFormatter = textFormatter;
    pic.showsPageRange = YES;
    
    void (^completionHandler)(UIPrintInteractionController *, BOOL, NSError *) =
    ^(UIPrintInteractionController *printController, BOOL completed, NSError *error) {
        if (!completed && error) {
            NSLog(@"Printing could not complete because of error: %@", error);
        }
    };
    
        [pic presentAnimated:YES completionHandler:completionHandler];
    }];
}


@end
