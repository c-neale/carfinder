//
//  GeocodeProvider.h
//  wayback
//
//  Created by Cory Neale on 13/07/2014.
//  Copyright (c) 2014 Cory Neale. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <MapKit/MapKit.h>

@interface GeocodeProvider : NSObject

typedef void (^onCompleteBlock) (CLPlacemark * placemark);

+ (id) sharedInstance;

- (void) geocodeAddress:(NSString *)address onComplete:(onCompleteBlock)onComplete;
- (void) reverseGeocodeLocation:(CLLocation *)location onComplete:(onCompleteBlock)onComplete;


@end
