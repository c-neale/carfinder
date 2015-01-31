//
//  MarkLocationViewController+UIAlertViewDelegate.m
//  wayback
//
//  Created by Cory Neale on 31/01/2015.
//  Copyright (c) 2015 Cory Neale. All rights reserved.
//

#import "MarkLocationViewController+UIAlertViewDelegate.h"

@implementation MarkLocationViewController (UIAlertViewDelegate)

- (void) displayLocationServicesAlert
{
    NSString * errorTitle = @"Unable to find location";
    NSString * errorMessage = @"Unable to find your current location.  Please enable location services in the privacy settings and try again";
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:errorTitle
                                                     message:errorMessage
                                                    delegate:nil
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil];
    [alert show];
}

- (void) displayClearConfirmAlert
{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Are you sure?"
                                                     message:@"Are you sure you want to clear all?"
                                                    delegate:self
                                           cancelButtonTitle:@"No"
                                           otherButtonTitles:@"Yes", nil];
    
    [alert show];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // need to be sure which alert view we are working with.
    // although there is probably a better way of doing this.
    if([[alertView title]  isEqual: @"Are you sure?"])
    {
        // check which button was pressed and process it.
        switch (buttonIndex) {
            case 1:
                [self clearButtonAction];
                break;
            case 0:
            default:
                break;
        }
    }
}


@end
