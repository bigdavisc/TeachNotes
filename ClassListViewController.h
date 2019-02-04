//
//  ClassListViewController.h
//  TeachNotes With Parse
//
//  Created by Davis Carlson on 2014-06-06.
//  Copyright (c) 2014 Davis Carlson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "AddClassViewController.h"
#import "Reachability.h"
#import "ClassDetailViewController.h"
@interface ClassListViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource> {
    NSMutableArray *classNames;
    NSMutableArray *teacherNames;
    NSMutableArray *objectsArray;
    NSMutableArray *objectIDs;
    PFQuery *query;
    UIRefreshControl *refreshControl;
    
    UIActivityIndicatorView *activityIndicator;
    
    IBOutlet UITableView *table;
}
-(void)getAllClasses;
-(void)reloadTheTable;
@end
