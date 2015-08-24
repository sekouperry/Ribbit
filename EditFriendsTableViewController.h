//
//  EditFriendsTableViewController.h
//  Ribbit
//
//  Created by Lemuel Ambie-Barango on 2015-07-09.
//  Copyright (c) 2015 Lemuel Barango. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface EditFriendsTableViewController : UITableViewController

@property(nonatomic, strong) NSArray *allUsers;
@property (nonatomic, strong) NSMutableArray *currentUserFriends;
@property (nonatomic, strong) PFUser *currentUser;

-(BOOL)isFriend:(PFUser *)user;

@end
