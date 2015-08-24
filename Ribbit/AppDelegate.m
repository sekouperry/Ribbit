//
//  AppDelegate.m
//  Ribbit
//
//  Created by Lemuel Ambie-Barango on 2015-06-14.
//  Copyright (c) 2015 Lemuel Barango. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [NSThread sleepForTimeInterval:1];
    // Initialize Parse.
    [Parse setApplicationId:@"ue9Ns72htQj0sP7teHfri0lxVRvL5t2OA7GaZmAg"
                  clientKey:@"2KQQMH3HsoAok5WkZQnjLXvh64dHF7RHpqmPRI6J"];
    
    // [Optional] Track statistics around application opens.
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    [self customizeUserInterface];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Helper methods

-(void) customizeUserInterface {
    //customize nav bar
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UINavigationBar appearance]setBackgroundImage:[UIImage imageNamed:@"navBarBackground"] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    //customize tab bar
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    
    UITabBarController *tabBarController = (UITabBarController *) self.window.rootViewController;
    UITabBar *tabBar = tabBarController.tabBar;
    
    UITabBarItem *tabInbox = [tabBar.items objectAtIndex:0];
    UITabBarItem *tabFriends = [tabBar.items objectAtIndex:1];
    UITabBarItem *tabCamera = [tabBar.items objectAtIndex:2];
    
    tabInbox = [tabInbox initWithTitle:@"Inbox" image:[[UIImage imageNamed:@"inbox"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"inbox"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    tabFriends = [tabFriends initWithTitle:@"Friends" image:[[UIImage imageNamed:@"friends"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"friends"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    tabCamera = [tabCamera initWithTitle:@"Camera" image:[[UIImage imageNamed:@"camera"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"camera"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
}

@end
