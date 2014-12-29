//
//  AppDelegate.m
//  wayback
//
//  Created by Cory Neale on 29/05/2014.
//  Copyright (c) 2014 Cory Neale. All rights reserved.
//

#import "AppDelegate.h"

#import "MarkLocationViewController.h"

#import "GAI.h"

//#import "VersionCheck.h"
#import "Ratings.h"

@interface AppDelegate ()

@property (nonatomic, strong) DataModel * dataModel;

- (void) initGoogleAnalyticsWithId:(NSString *)trackingId;

@end

@implementation AppDelegate

#pragma mark - lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

    [self initGoogleAnalyticsWithId:@"UA-50634961-2"];
    
    // create the window.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // create an instance of the data model to hold our data.
    _dataModel = [[DataModel alloc] init];
    
    // create our starting view controller and pass it the model.
    MarkLocationViewController * markLocationVc = [[MarkLocationViewController alloc] initWithModel:_dataModel];
    
    // create a navigation controller with our root view controller and set it to the window.
    UINavigationController * navController = [[UINavigationController alloc] initWithRootViewController:markLocationVc];
    [[self window] setRootViewController:navController];
    
    //check to see if we have the latest version and prompt to upgrade...
//    VersionCheck * checker = [[VersionCheck alloc] init];
//    [checker newVersionForId:890275501];
    
    [Ratings SetupForAppId:@"890275501"];
    
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    [Ratings exitedForeground];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    [Ratings enteredForeground];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - helpers

// TODO: move this to a wrapper class.
- (void) initGoogleAnalyticsWithId:(NSString *)trackingId
{
    // this will stop google tracking data while debugging (without haveing to wrap/remove all the GAI calls)
#ifdef DEBUG
    [GAI sharedInstance].dryRun = YES;
#endif
    
    // Optional: automatically send uncaught exceptions to Google Analytics.
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    
    //#ifdef DEBUG
    // Optional: set Logger to VERBOSE for debug information.
    //    [[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelVerbose];
    //#else
    [[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelNone];
    //#endif
    
    // Initialize tracker. Replace with your tracking ID.
    [[GAI sharedInstance] trackerWithTrackingId:trackingId];
}

@end
