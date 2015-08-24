//
//  FriendsTableViewController.h
//  Ribbit
//
//  Created by Lemuel Ambie-Barango on 2015-07-09.
//  Copyright (c) 2015 Lemuel Barango. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface FriendsTableViewController : UITableViewController

@property (nonatomic, strong) NSArray *currentUserFriends;
@property (nonatomic, strong) PFUser *currentUser;

@end
