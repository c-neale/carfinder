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

@class MapLocationViewController;

@interface MapViewHandler : NSObject<MKMapViewDelegate>

@property (nonatomic, weak) MapLocationViewController * delegate;

- (id) initWithDelegate:(MapLocationViewController *)delegate;

- (void) calculateRouteFrom:(MapMarker *)source to:(MapMarker *)dest;

@end
