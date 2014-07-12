//
//  MarkLocationAlertViewHandler.m
//  wayback
//
//  Created by Cory Neale on 11/07/2014.
//  Copyright (c) 2014 Cory Neale. All rights reserved.
//

#import "MarkLocationAlertViewHandler.h"

#import "MarkLocationViewController.h"

@implementation MarkLocationAlertViewHandler

#pragma mark - Init

- (id) initWithDelegate:(MarkLocationViewController *)delegate
{
    self = [super init];
    if(self)
    {
        _delegate = delegate;
    }
    return self;
}

#pragma mark - class methods

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
                [_delegate clearButtonAction];
                break;
            case 0:
            default:
                break;
        }
    }
}

@end
