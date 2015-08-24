//
//  ImageViewController.h
//  Ribbit
//
//  Created by Lemuel Ambie-Barango on 2015-07-10.
//  Copyright (c) 2015 Lemuel Barango. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface ImageViewController : UIViewController

@property (nonatomic, strong) PFObject *message;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end
