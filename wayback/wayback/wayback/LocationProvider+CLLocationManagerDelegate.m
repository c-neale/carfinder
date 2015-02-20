//
//  LocationProvider+CLLocationManagerDelegate.m
//  wayback
//
//  Created by Cory Neale on 18/02/2015.
//  Copyright (c) 2015 Cory Neale. All rights reserved.
//

#import "LocationProvider+CLLocationManagerDelegate.h"

NSString * const LocationProviderUpdatedNotification = @"LocationProviderUpdated";

@implementation LocationProvider (CLLocationManagerDelegate)

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    [self setCurrentLocation:newLocation];
    
    NSDictionary *userInfo = @{@"location": newLocation};
    
    // dispatch the notification asynchronously...
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:LocationProviderUpdatedNotification object:self userInfo:userInfo];
    });
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    // TODO: should probably handle some errors here...
}

@end
