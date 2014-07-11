//
//  MapViewHandler.h
//  wayback
//
//  Created by Cory Neale on 3/07/2014.
//  Copyright (c) 2014 Cory Neale. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <MapKit/MapKit.h>

#import "MapMarker.h"

@interface MapViewHandler : NSObject<MKMapViewDelegate>

@property (nonatomic, strong) NSMutableArray * locations;

- (id) initWithModel:(NSMutableArray *)locations;

+ (void) mapView:(MKMapView *)mv calculateRouteFrom:(MapMarker *)source to:(MapMarker *)dest;

@end
