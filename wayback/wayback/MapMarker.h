//
//  MapMarker.h
//  wayback
//
//  Created by Cory Neale on 29/05/2014.
//  Copyright (c) 2014 Cory Neale. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <MapKit/MapKit.h>

@interface MapMarker : NSObject<MKAnnotation>
{
    
}

@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) CLPlacemark * placemark;

// this is the route to get to THIS destination
@property (nonatomic, strong) MKRoute * route;
@property (nonatomic) BOOL routeCalcRequired;

- (id) initWithPlacemark:(CLPlacemark *)pMark;

- (CLLocation *) location;
- (NSString *) address;

@end
