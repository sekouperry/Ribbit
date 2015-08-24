//
//  CameraViewController.m
//  Ribbit
//
//  Created by Lemuel Ambie-Barango on 2015-07-10.
//  Copyright (c) 2015 Lemuel Barango. All rights reserved.
//

#import "CameraViewController.h"
#import "MSCellAccessory.h"
#import <MobileCoreServices/UTCoreTypes.h>

@interface CameraViewController ()

@end

@implementation CameraViewController

UIColor *disclosureUIColor;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.recepients = [[NSMutableArray alloc] init];
    self.currentUser = [PFUser currentUser];
    disclosureUIColor = [UIColor colorWithRed:0.553 green:0.439 blue:0.718 alpha:1.0];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.image == nil && [self.videoFilePath length] == 0) {
        PFRelation *friendsRelation = [self.currentUser relationForKey:@"friends"];
        [[friendsRelation query] findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (error) {
                NSLog(@"Error %@ %@", error, [error userInfo]);
            } else {
                self.currentUserFriends = objects;
                [self.tableView reloadData];
            }
        }];
        
        self.imagePicker = [[UIImagePickerController alloc] init];
        self.imagePicker.delegate = self;
        self.imagePicker.allowsEditing = NO;
        self.imagePicker.videoMaximumDuration = 10;
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        } else {
            self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        self.imagePicker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:self.imagePicker.sourceType];
        [self presentViewController:self.imagePicker animated:NO completion:nil];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.currentUserFriends count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    PFUser *user = [self.currentUserFriends objectAtIndex:indexPath.row];
    cell.textLabel.text = user.username;
    
    if ([self.recepients containsObject:user.objectId]) {
        cell.accessoryView = [MSCellAccessory accessoryWithType:FLAT_CHECKMARK color:disclosureUIColor];
    } else {
        cell.accessoryView = nil;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    PFUser *user = [self.currentUserFriends objectAtIndex:indexPath.row];
    
    if (cell.accessoryView != nil) {
        cell.accessoryView = nil;
        [self.recepients removeObject:user.objectId];
    }else {
        cell.accessoryView = [MSCellAccessory accessoryWithType:FLAT_CHECKMARK color:disclosureUIColor];
        [self.recepients addObject:user.objectId];
    }
    
}

#pragma mark - Image Picker Controler Delegate

- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:NO completion:nil];
    [self.tabBarController setSelectedIndex:0];
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        self.image = [info objectForKey:UIImagePickerControllerOriginalImage];
        if(self.imagePicker.sourceType == UIImagePickerControllerSourceTypeCamera) {
            //save image
            UIImageWriteToSavedPhotosAlbum(self.image, nil, nil, nil);
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        NSURL *imagePickerURL = [info objectForKey:UIImagePickerControllerMediaURL];
        self.videoFilePath = [imagePickerURL path];
        if(self.imagePicker.sourceType == UIImagePickerControllerSourceTypeCamera) {
            //save video
            if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(self.videoFilePath)) {
                UISaveVideoAtPathToSavedPhotosAlbum(self.videoFilePath, nil, nil, nil);
            }
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - Segue methods

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}


#pragma mark - View controller methods
- (IBAction)sendMessage:(id)sender {
    if (self.image == nil && self.videoFilePath.length == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Try again" message:@"Please select an image or video to share" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertView show];
        [self presentViewController:self.imagePicker animated:NO completion:nil];
    } else {
        [self uploadMessage];
        [self.tabBarController setSelectedIndex:0];
    }
    
}

- (IBAction)cancelMessage:(id)sender {
    [self resetMessage];
    [self.tabBarController setSelectedIndex:0];
}

- (void)resetMessage {
    self.image = nil;
    self.videoFilePath = nil;
    [self.recepients removeAllObjects];
}

- (void) uploadMessage {
    NSData *fileData;
    NSString *fileName;
    NSString *fileType;
    
    if (self.image != nil) {
        UIImage *newImage = [self resizeImage:self.image toWidth:320.0f andHeight:480.0f];
        fileData = UIImagePNGRepresentation(newImage);
        fileName = @"image.png";
        fileType = @"image";
    } else {
        fileData = [NSData dataWithContentsOfFile:self.videoFilePath];
        fileName = @"video.mov";
        fileType = @"video";
    }
    
    PFFile *file = [PFFile fileWithName:fileName data:fileData];
    [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
        if (error) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error occured" message:@"An error occured in uploading your message. Please try again." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alertView show];
        } else {
            PFObject *message = [PFObject objectWithClassName:@"Messages"];
            [message setObject:file forKey:@"messageFile"];
            [message setObject:fileType forKey:@"fileType"];
            [message setObject:self.recepients forKey:@"recepients"];
            [message setObject:[self.currentUser objectId] forKey:@"senderId"];
            [message setObject:[self.currentUser username] forKey:@"senderUsername"];
            [message saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
                if (error) {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error occured" message:@"An error occured in uploading your message. Please try again." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                    [alertView show];
                } else {
                    [self resetMessage];
                }
            }];
        }
    }];
}

-(UIImage *) resizeImage:(UIImage *)image toWidth:(float)width andHeight:(float)height {
    CGSize newSize = CGSizeMake(width, height);
    CGRect newRectangle = CGRectMake(0, 0, width, height);
    UIGraphicsBeginImageContext(newSize);
    [self.image drawInRect:newRectangle];
    UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resizedImage;
}

@end
