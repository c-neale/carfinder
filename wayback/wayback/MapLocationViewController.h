//
//  MapLocationViewController.h
//  wayback
//
//  Created by Cory Neale on 29/05/2014.
//  Copyright (c) 2014 Cory Neale. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

#import "GAI.h"

#import "MapMarker.h"

@interface MapLocationViewController : GAITrackedViewController

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

- (id) initWithLocation:(CLLocation*)location;

- (IBAction)changeMapType:(UISegmentedControl *)sender;

- (void) calculateRouteFrom:(MapMarker *)source to:(MapMarker *)dest;

- (void)setRegionWithLocation:(CLLocation *)location andRadius:(double)radius;
- (void)addAnnotations;
- (void)removeAnnotations;

- (void) showDirections;

@end
