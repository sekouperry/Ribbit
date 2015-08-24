//
//  InboxTableViewController.h
//  Ribbit
//
//  Created by Lemuel Ambie-Barango on 2015-07-01.
//  Copyright (c) 2015 Lemuel Barango. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <MediaPlayer/MediaPlayer.h>

@interface InboxTableViewController : UITableViewController

@property (nonatomic, strong) NSArray *messages;
@property (nonatomic, strong) PFObject *selectedMessage;
@property (nonatomic, strong) MPMoviePlayerController *moviePlayer;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

- (IBAction)logout:(id)sender;

@end
