//
//  PageChildViewController.m
//  TeachNotes
//
//  Created by Davis Carlson on 2014-06-10.
//  Copyright (c) 2014 Davis Carlson. All rights reserved.
//

#import "PageChildViewController.h"

@interface PageChildViewController ()

@end

@implementation PageChildViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIPageControl *pageControlAppearance = [UIPageControl appearanceWhenContainedIn:[UIPageViewController class], nil];
    pageControlAppearance.pageIndicatorTintColor = [UIColor lightGrayColor];
    pageControlAppearance.currentPageIndicatorTintColor = [UIColor darkGrayColor];
    // Do any additional setup after loading the view.
    switch(self.index) {
        case 1:
            //do something;
            self.titleLabel.text = @"Welcome To TeachNotes";
            break;
        case 2:
            //do something;
            self.titleLabel.text = @"Add Your Classes";
            break;
        case 3:
            //do something;
            self.titleLabel.text = @"Each Day, Add Your Notes";
            break;
        case 4:
            //do something;
            self.titleLabel.text = @"Save and Send Your Notes";
            break;
        case 5:
            //do something;
            self.titleLabel.text = @"Thank You";
            break;
            
    }
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
-(IBAction)close:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
