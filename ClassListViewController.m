//
//  ClassListViewController.m
//  TeachNotes With Parse
//
//  Created by Davis Carlson on 2014-06-06.
//  Copyright (c) 2014 Davis Carlson. All rights reserved.
//

#import "ClassListViewController.h"

@interface ClassListViewController ()

@end

@implementation ClassListViewController


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
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
    [self getAllClasses];
}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    activityIndicator.transform = CGAffineTransformMakeScale(1.5, 1.5);
	activityIndicator.frame = CGRectMake(0.0, 0.0, 150.0, 100.0);
	activityIndicator.center = self.view.center;
    [activityIndicator.layer setCornerRadius:8];
    activityIndicator.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8f];
    [self.view addSubview:activityIndicator];
    [activityIndicator startAnimating];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self.tableView reloadData];
    self.navigationController.navigationBarHidden = NO;
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];
    self.navigationController.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.jpg"]];
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
-(IBAction)reloadClasses:(id)sender {
    [self getAllClasses];
    [self.tableView reloadData];
}
- (void)refresh:(UIRefreshControl *)refreshControl {

    [self reloadClasses:self];
}
-(IBAction)goHome:(id)sender {
    UIViewController *home = [self.storyboard instantiateViewControllerWithIdentifier:@"Home"];
    home.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:home animated:YES completion:nil];
}
-(IBAction)test:(id)sender {
    UIViewController *addNew = [self.storyboard instantiateViewControllerWithIdentifier:@"addnew"];
    addNew.modalPresentationStyle = UIModalPresentationFormSheet;
    addNew.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:addNew animated:YES completion:nil];

}

-(void)getAllClasses {
    NSString *UserID = [[PFUser currentUser] objectId];
    query = [PFQuery queryWithClassName:@"Classes"];
    [query whereKey:@"UserID" equalTo:UserID];
    PFQuery *query2 = [PFQuery queryWithClassName:@"Classes"];
    [query2 whereKey:@"primaryTeacher" equalTo:UserID];
    PFQuery *query3 = [PFQuery queryWithClassName:@"Classes"];
    [query3 whereKey:@"addedTeachers" equalTo:UserID];
    
    PFQuery *query4 = [PFQuery orQueryWithSubqueries:@[query,query2,query3]];
    [query4 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            objectsArray = [[NSMutableArray alloc] initWithArray:objects];
            [self.tableView reloadData];
            [self performSelector:@selector(stopAnimating) withObject:self afterDelay:1.0];
            
        }
        
    }];
    [refreshControl endRefreshing];
}

-(void)reloadTheTable {
    [self getAllClasses];
    [self.tableView reloadData];
}

-(void)stopAnimating {
    [activityIndicator stopAnimating];
    [activityIndicator removeFromSuperview];
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
    return [objectsArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Classes";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor clearColor];
    PFObject *post = [objectsArray objectAtIndex:indexPath.row];
    [cell.textLabel setText:[post objectForKey:@"classname_number"]];
    [cell.detailTextLabel setText:[post objectForKey:@"teacherName"]];
    return cell;
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        PFObject *post = [objectsArray objectAtIndex:indexPath.row];
        PFUser *user = [PFUser currentUser];
        [query getObjectInBackgroundWithId:post.objectId block:^(PFObject *object, NSError *error) {
            if ([object[@"primaryTeacher"] isEqualToString:user.objectId]) {
                PFObject *object = [PFObject objectWithoutDataWithClassName:@"Classes"
                                                                   objectId:post.objectId];
                [object deleteInBackground];
                
                PFQuery *query2 = [PFQuery queryWithClassName:@"ClassNotes"];
                [query2 whereKey:@"classID" equalTo:post.objectId];
                
                [query2 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                    for (PFObject *objects2 in objects) {
                        [objects2 deleteInBackground];
                    }
                }];
            } else {
                PFQuery *queryLocal = [PFQuery queryWithClassName:@"Classes"];
                [queryLocal getObjectInBackgroundWithId:post.objectId block:^(PFObject *object, NSError *error) {
                    [object removeObject:user.objectId forKey:@"addedTeachers"];
                    [object saveInBackground];
                }];
            }
                }];
                
                [objectsArray removeObjectAtIndex:indexPath.row];
            }
        
[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:YES];
        
        [self performSelector:@selector(reloadTheTable) withObject:self afterDelay:1.0];
        
    
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetailClass"]) {
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
        PFObject *post = [objectsArray objectAtIndex:indexPath.row];
        NSString *classObjectID = post.objectId;
        NSString *className = [post objectForKey:@"classname_number"];
        NSString *userID = [post objectForKey:@"UserID"];
        NSString *teachName = [post objectForKey:@"teacherName"];
        NSString *start = [post objectForKey:@"startTime"];
        NSString *end = [post objectForKey:@"endTime"];
        NSString *teachEmail = [post objectForKey:@"teacherEmail"];
        [[segue destinationViewController] setDetailObjectID:classObjectID];
        [[segue destinationViewController] setDetailClass:className];
        [[segue destinationViewController] setDetailUserID:userID];
        [[segue destinationViewController] setDetailEnd:end];
        [[segue destinationViewController] setDetailStart:start];
        [[segue destinationViewController] setDetailTeacherName:teachName];
        [[segue destinationViewController] setDetailTeacherEmail:teachEmail];
    }
}




@end
