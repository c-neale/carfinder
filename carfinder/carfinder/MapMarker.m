//
//  MapMarker.m
//  carfinder
//
//  Created by Cory Neale on 29/05/2014.
//  Copyright (c) 2014 Cory Neale. All rights reserved.
//

#import "MapMarker.h"

#import <AddressBookUI/ABAddressFormatting.h>

@interface MapMarker ()
{
    
}

- (void) requestPlacemarkFromLocation:(CLLocation *)loc;

@end

@implementation MapMarker

#pragma mark - Properties

@synthesize name;
@synthesize placemark;

#pragma mark - Init and lifecycle

- (id) initWithName:(NSString *)nm andLocation:(CLLocation *)location
{
    self = [super init];
    if(self)
    {
        name = nm;
        placemark = nil;
        [self requestPlacemarkFromLocation:location];
    }
    
    return self;
}

- (NSString *)description
{
    return name;
}

#pragma mark - internal methods

- (void) requestPlacemarkFromLocation:(CLLocation *)loc
{
    // geocode to get a friendly address and create directions
    CLGeocoder * geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:loc
                   completionHandler:^(NSArray * placemarks, NSError * error) {
                       if(error != nil)
                       {
                           // TODO: handle the error a bit better.
                           NSLog(@"Error occurred while attemting to reverse geocode the address");
                       }
                       else
                       {
                           // TODO: handle multiples somehow?
                           placemark = [placemarks lastObject];
                       }
                   }];

}

#pragma mark - class methods

// helper method to make it easier to get the location from the placemark.
- (CLLocation *) location
{
    return placemark.location;
}

- (NSString *) address
{
    if(placemark != nil)
    {
        return ABCreateStringWithAddressDictionary(placemark.addressDictionary, NO);
    }
    
    return @"";
}

#pragma mark - MKAnnotation
// this will plot the marker to a correct place on map
- (CLLocationCoordinate2D)coordinate
{
    return placemark.location.coordinate;
}

// this will be shown as marker title
- (NSString *)title
{
    return name;
}

// this will be shown as marker subtitle
- (NSString *)subtitle
{
    return @"";
}

@end
