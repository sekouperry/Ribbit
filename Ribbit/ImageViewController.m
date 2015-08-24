//
//  ImageViewController.m
//  Ribbit
//
//  Created by Lemuel Ambie-Barango on 2015-07-10.
//  Copyright (c) 2015 Lemuel Barango. All rights reserved.
//

#import "ImageViewController.h"

@interface ImageViewController ()

@end

@implementation ImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *senderName = [self.message objectForKey:@"senderUsername"];
    PFFile *imageFile = [self.message objectForKey:@"messageFile"];
    NSURL *imageURL = [NSURL URLWithString:imageFile.url];
    NSData *data = [NSData dataWithContentsOfURL:imageURL];
    self.imageView.image = [UIImage imageWithData:data];
    NSString *title = [NSString stringWithFormat:@"Sent from %@", senderName];
    self.navigationItem.title = title;
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if ([self respondsToSelector:@selector(timeout)]) {
        [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(timeout) userInfo:nil repeats:NO];
    } else {
        NSLog(@"Error selector missing");
    }
}

#pragma mark - helper methods

-(void) timeout {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
