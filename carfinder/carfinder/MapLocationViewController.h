//
//  MapLocationViewController.h
//  carfinder
//
//  Created by Cory Neale on 29/05/2014.
//  Copyright (c) 2014 Cory Neale. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <MapKit/MapKit.h>

@interface MapLocationViewController : UIViewController<MKMapViewDelegate>
{
    __weak IBOutlet MKMapView *mapView;
}

@property (nonatomic, strong) NSArray * locations;

- (IBAction)changeMapType:(UISegmentedControl *)sender;

- (void)addAnnotations;
- (void)removeAnnotations;

- (void) showDirections;

@end
