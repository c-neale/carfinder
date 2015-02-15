//
//  LocationProvider.m
//  wayback
//
//  Created by Cory Neale on 13/02/2015.
//  Copyright (c) 2015 Cory Neale. All rights reserved.
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

#pragma mark - init

- (id) init
{
    self = [super init];
    if(self)
    {
        _currentLocation = nil;
        _locationManager = [[CLLocationManager alloc] init];
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

- (void) requestAuthorization
{
    // NOTE: check info.plist file for display message when requesting auth.
    // need to check if the locationManager responds; versions of ios prior to 8 will crash on this call.
    if ([_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{

}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    
}

@end
