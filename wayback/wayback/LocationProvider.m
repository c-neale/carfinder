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

@end

@implementation LocationProvider

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
    [_locationManager startUpdatingLocation];
}

- (void) stop
{
    [_locationManager stopUpdatingLocation];
}

#pragma mark - CLLocationManagerDelegate functions

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    // just silently store the location so we know where they are when the button is pressed.
    _currentLocation = newLocation;
    
    // TODO: this needs way more thought.
    /*    if([self shouldPassivelyMarkLocation])
     {
     [self markLocation];
     }
     */
}

/*
- (BOOL) shouldPassivelyMarkLocation
{
    BOOL passiveMode = YES;
    
    // if we are not in passive mode, obviously should be a NO.
    if(passiveMode == NO)
    {
        DebugLog(@"Passive Mode is disabled");
        return NO;
    }
    
    if([_locations count] == 0)
        return NO;
    
 
     // TODO: this triggers multiple times. need to fix it.
     // if we have no markers yet, then definately mark the current loction.
//     if([locations count] == 0)
//     {
//     DebugLog(@"Adding first location.");
//     return YES;
//     }
 
    
    CLLocation * prevLocation = [(MapMarker *)[_locations lastObject] location];
    
    // check if the direction of travel is changing.
    CLLocationDirection prevDir = prevLocation.course;
    CLLocationDirection curDir = _currentLocation.course;
    
    // TODO: I need to rethink this whole process.
    // if the deviation is greater than 5 degrees AND the distance is less than 10 or time is less than 5min,
    // we should be replacing the last marker instead of just adding a new one.  this method probably isnt the
    //place for that to happen, but i dont want to be doubling up on checking the conditions.
    double deviation = fabs(prevDir - curDir);
    DebugLog(@"Course Deviation: %f degrees", deviation);
    //    if(deviation < 5.0)
    {
        // if we have moved less than x metres, then also NO.
        // TODO: make the 10.0f less hardcoded. value should ideally match the threshold to remove a marker.
        CLLocationDistance distFromLastMarker = [_currentLocation distanceFromLocation:prevLocation];
        DebugLog(@"distance from last marker: %f m", distFromLastMarker);
        if(distFromLastMarker < 10.0f)
        {
            return NO;
        }
        
        // don't set a marker too often...
        NSDate * prevTime = prevLocation.timestamp;
        NSDate * thisTime = _currentLocation.timestamp;
        
        NSTimeInterval interval = [thisTime timeIntervalSinceDate:prevTime];
        double minsSinceLastMarker = interval / 60.0f;
        
        DebugLog(@"minutes since last marker: %f", minsSinceLastMarker);
        if(minsSinceLastMarker < 1.0f) // TODO: make the 5.0f less hardcoded.
        {
            return NO;
        }
    }
    
    return YES;
}*/

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
