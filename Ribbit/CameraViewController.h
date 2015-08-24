//
//  CameraViewController.h
//  Ribbit
//
//  Created by Lemuel Ambie-Barango on 2015-07-10.
//  Copyright (c) 2015 Lemuel Barango. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface CameraViewController : UITableViewController <UINavigationControllerDelegate ,UIImagePickerControllerDelegate>

@property (nonatomic, strong) UIImagePickerController *imagePicker;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSString *videoFilePath;
@property (nonatomic, strong) PFUser *currentUser;
@property (nonatomic, strong) NSArray *currentUserFriends;
@property (nonatomic, strong) NSMutableArray *recepients;

- (void)uploadMessage;
- (void)resetMessage;
- (UIImage *) resizeImage:(UIImage *)image toWidth:(float) width andHeight:(float) height;

- (IBAction)sendMessage:(id)sender;
- (IBAction)cancelMessage:(id)sender;

@end
