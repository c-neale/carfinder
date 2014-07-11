//
//  VersionCheckAlertViewHandler.m
//  wayback
//
//  Created by Cory Neale on 11/07/2014.
//  Copyright (c) 2014 Cory Neale. All rights reserved.
//

#import "VersionCheckAlertViewHandler.h"

@implementation VersionCheckAlertViewHandler

#pragma mark - class methods

- (void) displayVersionAlert
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"New Version"
                                                    message:@"There is a new version, get it from the App Store!"
                                                   delegate:self
                                          cancelButtonTitle:@"Not now"
                                          otherButtonTitles:@"Get it", nil];
    
    [alert show];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
  
    DebugLog(@"---------------in the delegate function!");
    
//    NSString * bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
//    NSString * urlString = [NSString stringWithFormat:@"itms://itunes.com/apps/id/%@", bundleIdentifier];
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
    
    // for future reference: linking to the developer's app pages
    //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms://itunes.com/apps/developername"]];//
    //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.com/apps/DevelopmentCompanyLLC"]];
    
    
    /*
     switch(buttonIndex)
     {
     case 0:
     break;
     case 1:
     break;
     }*/
}

@end
