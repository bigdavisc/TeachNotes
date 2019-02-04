//
//  AddClassViewController.m
//  TeachNotes With Parse
//
//  Created by Davis Carlson on 2014-06-06.
//  Copyright (c) 2014 Davis Carlson. All rights reserved.
//

#import "AddClassViewController.h"

@interface AddClassViewController () {
    ZBarReaderViewController *readerqr;
}

@end

@implementation AddClassViewController

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
    readerqr = [ZBarReaderViewController new];
    readerqr.readerDelegate = self;
    readerqr.showsHelpOnFail = NO;

    
    UIView * infoButton = [[[[[readerqr.view.subviews objectAtIndex:2] subviews] objectAtIndex:0] subviews] objectAtIndex:3];
    
    [infoButton setHidden:YES];
    ZBarImageScanner *scanner = readerqr.scanner;
    [scanner setSymbology: 0
                   config: ZBAR_CFG_ENABLE
                       to: 0];
    [scanner setSymbology: ZBAR_QRCODE
                   config: ZBAR_CFG_ENABLE
                       to: 1];
    
    // you can use this to support the simulator

}
-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    ClassListViewController *classList = [[ClassListViewController alloc] init];
    [classList reloadTheTable];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
-(IBAction)timePickerEnd:(id)sender {
    NSDate *time = timePickerEnd.date;
    NSDateFormatter *timeDF = [[NSDateFormatter alloc] init];
    [timeDF setDateFormat:@"hh:mm a"];
NSString *endTime = [NSString stringWithFormat:@"%@", [timeDF stringFromDate:time]];
    endTimePickerString = [NSString stringWithString:endTime];
}
-(IBAction)timePickerStart:(id)sender {
    NSDate *time = timePickerStart.date;
    NSDateFormatter *timeDF = [[NSDateFormatter alloc] init];
    [timeDF setDateFormat:@"hh:mm a"];
    NSString *startTime = [NSString stringWithFormat:@"%@", [timeDF stringFromDate:time]];
    startTimePickerString = [NSString stringWithString:startTime];
}
-(void)imagePickerController: (UIImagePickerController*) reader didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    //1
    id<NSFastEnumeration> results =
    [info objectForKey: ZBarReaderControllerResults];
    //2
    ZBarSymbol *symbol = nil;
    for (symbol in results) break;
    //3
    barcode = symbol.data;
    classCode.text = barcode;
    [reader dismissViewControllerAnimated:YES completion:nil];
    [self performSelector:@selector(addClassFromCode:) withObject:self afterDelay:0.5];
}

-(IBAction)scan {
    // present and release the controller
    [self presentViewController:readerqr
                       animated:YES completion:nil];
}


//---------------------------------------------------------------------------------------
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(IBAction)save:(id)sender {

        activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    activityIndicator.transform = CGAffineTransformMakeScale(1.5, 1.5);
	activityIndicator.frame = CGRectMake(0.0, 0.0, 150.0, 100.0);
	activityIndicator.center = self.view.center;
    [activityIndicator.layer setCornerRadius:8];
    activityIndicator.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8f];
    [self.view addSubview:activityIndicator];
    [activityIndicator startAnimating];
    NSString *name = teacherName.text;
    NSString *email = teacherEmail.text;
    NSString *className = teacherClassName.text;
    NSString *userID = [[PFUser currentUser] objectId];
    PFObject *newClass = [PFObject objectWithClassName:@"Classes"];

    newClass[@"teacherName"] = name;
    newClass[@"teacherEmail"] = email;
    newClass[@"classname_number"] = className;
    newClass[@"UserID"] = userID;
    newClass[@"primaryTeacher"] = userID;
    [newClass saveInBackground];
    ClassListViewController *ClassListViewObj = [[ClassListViewController alloc] init];
    [ClassListViewObj getAllClasses];
    [self performSelector:@selector(dismissActivity) withObject:self afterDelay:3.0];

}
-(void)dismissActivity {
    [activityIndicator stopAnimating];
    [activityIndicator removeFromSuperview];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)addClassFromCode:(id)sender {
    NSString *classCodeString = [NSString stringWithFormat:@"%@",classCode.text];
    PFQuery *query = [PFQuery queryWithClassName:@"Classes"];
    activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    activityIndicator.transform = CGAffineTransformMakeScale(1.5, 1.5);
	activityIndicator.frame = CGRectMake(0.0, 0.0, 150.0, 100.0);
	activityIndicator.center = self.view.center;
    [activityIndicator.layer setCornerRadius:8];
    activityIndicator.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8f];
    [self.view addSubview:activityIndicator];
    [activityIndicator startAnimating];
    [query getObjectInBackgroundWithId:classCodeString block:^(PFObject *object, NSError *error) {
        if (!object) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"That is not a Valid Class Code. Please Try Again" delegate:self cancelButtonTitle:@"Try Again" otherButtonTitles:nil];
            // optional - add more buttons:
            [alert show];
        } else {
                [object addObject:[[PFUser currentUser] objectId] forKey:@"addedTeachers"];
                [object saveInBackground];
            [self performSelector:@selector(dismissViewAddClass) withObject:self afterDelay:0.1];
        }
    }];
    
    
}
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self dismissViewAddClass];
    }
}

-(void)dismissViewAddClass {
    [activityIndicator stopAnimating];
    [activityIndicator removeFromSuperview];
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end


