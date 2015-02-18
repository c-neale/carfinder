//
//  LocationProvider+CLLocationManagerDelegate.m
//  wayback
//
//  Created by Cory Neale on 18/02/2015.
//  Copyright (c) 2015 Cory Neale. All rights reserved.
//

#import "LocationProvider+CLLocationManagerDelegate.h"

@implementation LocationProvider (CLLocationManagerDelegate)

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    [self setCurrentLocation:newLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    
}

@end
