//
//  PageViewController.h
//  TeachNotes
//
//  Created by Davis Carlson on 2014-06-10.
//  Copyright (c) 2014 Davis Carlson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PageViewController : UIViewController <UIPageViewControllerDataSource> {
    IBOutlet UIView *pageControl;
}
@property (strong, nonatomic) UIPageViewController *pageController;

@end
