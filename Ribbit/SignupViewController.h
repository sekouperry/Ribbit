//
//  SignupViewController.h
//  Ribbit
//
//  Created by Lemuel Ambie-Barango on 2015-07-02.
//  Copyright (c) 2015 Lemuel Barango. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignupViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
- (IBAction)signup:(id)sender;
- (IBAction)dismiss:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;

@end
