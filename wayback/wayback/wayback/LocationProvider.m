//
//  LocationProvider.m
//  wayback
//
//  Created by Cory Neale on 13/02/2015.
//  Copyright (c) 2015 Cory Neale. All rights reserved.
//

#import "LocationProvider.h"

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

#pragma mark - init

- (id) init
{
    self = [super init];
    if(self)
    {
        
    }
    
    return self;
}

#pragma mark - class methods

- (void) start
{
    
}

- (void) stop
{
    
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{

}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    
}

@end
