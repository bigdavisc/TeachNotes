//
//  PageChildViewController.h
//  TeachNotes
//
//  Created by Davis Carlson on 2014-06-10.
//  Copyright (c) 2014 Davis Carlson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PageViewController.h"
@interface PageChildViewController : UIViewController {
    IBOutlet UIButton *skip;
    IBOutlet UIImageView *imgView;
}

@property (assign, nonatomic) NSInteger index;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) UIImage *img;

@end
