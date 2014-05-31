//
//  MapLocationViewController.m
//  carfinder
//
//  Created by Cory Neale on 29/05/2014.
//  Copyright (c) 2014 Cory Neale. All rights reserved.
//

#import "MapLocationViewController.h"

#import "MapMarker.h"

@interface MapLocationViewController ()
{
    
}

@end

@implementation MapLocationViewController

#pragma mark - Properties

@synthesize locations;

#pragma mark - Init/lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    mapView.showsUserLocation = YES;
    mapView.delegate = self;
    
    MKUserLocation *userLocation = mapView.userLocation;
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.location.coordinate, 50, 50);
    [mapView setRegion:region animated:NO];
    
    [mapView setCenterCoordinate:userLocation.coordinate animated:NO];

    [self addAnnotations];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark helper functions

- (void) addAnnotations
{
    [self removeAnnotations];
    if (locations != nil)
    {
        [mapView addAnnotations:locations];
    }
}

// maybe move this to a category class?
- (void)removeAnnotations
{
    id userLocation = [mapView userLocation];
    NSMutableArray *pins = [[NSMutableArray alloc] initWithArray:[mapView annotations]];
    if ( userLocation != nil ) {
        [pins removeObject:userLocation]; // avoid removing user location off the map
    }
    
    [mapView removeAnnotations:pins];
    pins = nil;
}

#pragma mark - IBActions

- (IBAction)changeMapType:(UISegmentedControl *)sender
{
    switch(sender.selectedSegmentIndex)
    {
        case 0:
            mapView.mapType = MKMapTypeStandard;
            break;
        case 1:
            mapView.mapType = MKMapTypeSatellite;
            break;
        case 2:
            mapView.mapType = MKMapTypeHybrid;
            break;
    }
}

#pragma mark - MKMapViewDelegate

- (void)mapView:(MKMapView *)mv didUpdateUserLocation:(MKUserLocation *)userLocation
{
    [mapView setCenterCoordinate:userLocation.coordinate animated:NO];
}

@end
