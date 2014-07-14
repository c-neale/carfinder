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
#import "DataModel.h"

@interface MapLocationViewController : GAITrackedViewController

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (nonatomic, strong) DataModel * model;

- (id) initWithModel:(DataModel *)model;

- (IBAction)changeMapType:(UISegmentedControl *)sender;

// TODO: move these to the map handler?
- (void)addAnnotations;
- (void)removeAnnotations;

- (void) showDirections;

@end
