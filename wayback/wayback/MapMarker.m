//
//  MapMarker.m
//  wayback
//
//  Created by Cory Neale on 29/05/2014.
//  Copyright (c) 2014 Cory Neale. All rights reserved.
//

#import "MapMarker.h"

#import <AddressBookUI/ABAddressFormatting.h>

@interface MapMarker ()

@end

#define DEFAULT_NAME @"Un-named Location"

@implementation MapMarker

#pragma mark - Init and lifecycle

- (id) init
{
    self = [super init];
    if(self)
    {
        _initialised = NO;
        
        _name = DEFAULT_NAME;
        
        // TODO: idea - maybe we can calculate routes in advance when the marker is created?
        _route = nil;
        _routeCalcRequired = YES;
    }
    
    return self;
}

#pragma mark - class methods

// helper method to make it easier to get the location from the placemark.
- (CLLocation *) location
{
    return _placemark.location;
}

// only returns the first line of the address...
- (NSString *) shortAddress
{
    NSString * addr = [self address];
    NSRange rng = [addr rangeOfCharacterFromSet:[NSCharacterSet newlineCharacterSet]];
    
    // if a new line was not found, return the whole string.
    if(rng.location == NSNotFound)
    {
        return addr;
    }
    
    return [addr substringToIndex:rng.location];
}

- (NSString *) address
{
    if(_placemark != nil)
    {
        return ABCreateStringWithAddressDictionary(_placemark.addressDictionary, NO);
    }
    
    return @"";
}

#pragma mark - MKAnnotation
// this will plot the marker to a correct place on map
- (CLLocationCoordinate2D)coordinate
{
    return _placemark.location.coordinate;
}

// this will be shown as marker title
- (NSString *)title
{
    return [self name];
}

// this will be shown as marker subtitle
- (NSString *)subtitle
{
    return @"";
}

@end
