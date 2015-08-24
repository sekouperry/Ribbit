//
//  EditFriendsTableViewController.m
//  Ribbit
//
//  Created by Lemuel Ambie-Barango on 2015-07-09.
//  Copyright (c) 2015 Lemuel Barango. All rights reserved.
//

#import "EditFriendsTableViewController.h"
#import "MSCellAccessory.h"

@interface EditFriendsTableViewController ()

@end

@implementation EditFriendsTableViewController

UIColor *disclosureColor;

- (void)viewDidLoad {
    [super viewDidLoad];
    disclosureColor = [UIColor colorWithRed:0.553 green:0.439 blue:0.718 alpha:1.0];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.currentUser = [PFUser currentUser];
    PFQuery *query = [PFUser query];
    [query addAscendingOrder:@"username"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
        if (error) {
            NSLog(@"Error %@ %@", error, [error userInfo]);
        } else {
            self.allUsers = objects;
            [self.tableView reloadData];
        }
    }];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.allUsers count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    PFUser *user = [self.allUsers objectAtIndex:indexPath.row];
    cell.textLabel.text = user.username;
    
    if([self isFriend:user]) {
        cell.accessoryView = [MSCellAccessory accessoryWithType:FLAT_CHECKMARK color:disclosureColor];
    } else {
        cell.accessoryView = nil;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    PFUser *user = [self.allUsers objectAtIndex:indexPath.row];
    PFRelation *friendsRelation = [self.currentUser relationForKey:@"friends"];
    
    if ([self isFriend:user]) {
        cell.accessoryView = nil;
        for (PFUser *friend in self.currentUserFriends) {
            if ([friend.objectId isEqualToString:user.objectId]) {
                [self.currentUserFriends removeObject:friend];
                break;
            }
        }
        [friendsRelation removeObject:user];
    }
    else {
        cell.accessoryView = [MSCellAccessory accessoryWithType:FLAT_CHECKMARK color:disclosureColor];
        [self.currentUserFriends addObject:user];
        [friendsRelation addObject:user];
    }
    [self.currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error) {
            NSLog(@"Error %@ %@", error, [error userInfo]);
        }
    }];
   
}

-(BOOL) isFriend:(PFUser *)user {
    for (PFUser *friend in self.currentUserFriends) {
        if ([friend.objectId isEqualToString:user.objectId]) {
            return YES;
        }
    }
    return NO;
}

@end
