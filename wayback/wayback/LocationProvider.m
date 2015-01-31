//
//  LocationManagerProvider.m
//  wayback
//
//  Created by Cory Neale on 3/07/2014.
//  Copyright (c) 2014 Cory Neale. All rights reserved.
//

#import "LocationProvider.h"

@interface LocationProvider ()

@property (nonatomic, retain) CLLocationManager *locationManager;

- (void)requestAuthorization;

@end

@implementation LocationProvider

#pragma mark - sharedInstance

+ (LocationProvider *) sharedInstance
{
    static LocationProvider *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[LocationProvider alloc] init];
    });
    
    return _sharedInstance;
}

#pragma mark - init method(s)

- (id) init
{
    self = [super init];
    if(self)
    {
        _locationManager = [[CLLocationManager alloc] init];
        
        _currentLocation = nil;
    }
    return self;
}

#pragma mark - class methods

- (void) start
{
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    _locationManager.delegate = self;
    
    [self requestAuthorization];
    
    [_locationManager startUpdatingLocation];
}

- (void) stop
{
    [_locationManager stopUpdatingLocation];
}

- (void)requestAuthorization
{
    // NOTE: check info.plist file for display message when requesting auth.
    // need to check if the locationManager responds; versions of ios prior to 8 will crash on this call.
    if ([_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
}
    
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        // Send the user to the Settings for this app
        NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication] openURL:settingsURL];
    }
}

#pragma mark - CLLocationManagerDelegate functions

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    // just silently store the location so we know where they are when the button is pressed.
    _currentLocation = newLocation;
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    // TODO: contains hardcoded strings.  should probably put them somewhere better.
    
    BOOL displayMessage = NO;
    NSString * errorTitle = @"";
    NSString * errorMessage = @"";
    
    DebugLog(@"Error domain: %@ code: %d", error.domain, (int)error.code);
    
    [LogHelper logAndTrackError:error fromClass:self fromFunction:_cmd];
    
    switch(error.code)
    {
        case kCLErrorDenied:
            
            displayMessage = YES;
            errorTitle = @"Unable to find location";
            errorMessage = @"Unable to find your current location.  Please enable location services in the privacy settings and try again";
            
            DebugLog(@"Access to location services is denied. need to prompt user");
            break;
        case kCLErrorLocationUnknown:
            DebugLog(@"Could not find location right now. will keep trying. - safe to ignore.");
            break;
        case kCLErrorHeadingFailure:
            DebugLog(@"could not determine heading at this time. will keep trying - safe to ignore.");
            break;
        default:
            
            displayMessage = YES;
            errorTitle = @"Unknown Error";
            errorMessage = @"Unable to find location due to unknown error. Please try again later.";
            
            DebugLog(@"An unhandled error occurred while attempting to find user location.");
            DebugLog(@"message: %@", error.debugDescription);
            break;
    }
    
    if( displayMessage )
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:errorTitle
                                                         message:errorMessage
                                                        delegate:nil
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];
        [alert show];
        
    }
}

@end
