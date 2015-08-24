//
//  FriendsTableViewController.m
//  Ribbit
//
//  Created by Lemuel Ambie-Barango on 2015-07-09.
//  Copyright (c) 2015 Lemuel Barango. All rights reserved.
//

#import "FriendsTableViewController.h"
#import "EditFriendsTableViewController.h"
#import "GravatarUrlBuilder.h"

@interface FriendsTableViewController ()

@end

@implementation FriendsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.currentUser = [PFUser currentUser];
    PFRelation *friendsRelation = [self.currentUser relationForKey:@"friends"];
    [[friendsRelation query] findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"Error %@ %@", error, [error userInfo]);
        } else {
            self.currentUserFriends = objects;
            [self.tableView reloadData];
        }
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.currentUserFriends count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    PFUser *user = [self.currentUserFriends objectAtIndex:indexPath.row];
    cell.textLabel.text = user.username;
    cell.imageView.image = [UIImage imageNamed:@"icon_person"];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        NSString *email = [user email];
        NSURL *gravatarURL = [GravatarUrlBuilder getGravatarUrl:email];
        NSData *imageData = [NSData dataWithContentsOfURL:gravatarURL];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (imageData != nil) {
                cell.imageView.image = [UIImage imageWithData:imageData];
            }
            [cell setNeedsLayout];
        });
    });
    
    return cell;
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"showEditFriends"]) {
        EditFriendsTableViewController *viewController = (EditFriendsTableViewController *)segue.destinationViewController;
        viewController.currentUserFriends = [NSMutableArray arrayWithArray:self.currentUserFriends];
    }
}

@end
