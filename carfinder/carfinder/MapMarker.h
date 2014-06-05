//
//  MapMarker.h
//  carfinder
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

- (id) initWithName:(NSString *)nm andLocation:(CLLocation *)location;

- (CLLocation *) location;
- (NSString *) address;

@end
