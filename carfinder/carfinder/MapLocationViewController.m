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
    BOOL colSwitch;
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
        colSwitch = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    mapView.showsUserLocation = YES;
    
    MKUserLocation *userLocation = mapView.userLocation;
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.location.coordinate, 50, 50);
    [mapView setRegion:region animated:NO];
    
    [mapView setCenterCoordinate:userLocation.coordinate animated:NO];

    [self addAnnotations];
    
    [self showDirections];
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
    NSMutableArray * pins = [[NSMutableArray alloc] initWithArray:[mapView annotations]];
    if ( userLocation != nil ) {
        [pins removeObject:userLocation]; // avoid removing user location off the map
    }
    
    [mapView removeAnnotations:pins];
    pins = nil;
}

- (void) showDirections
{
    MKDirectionsRequest * dirRequest = [[MKDirectionsRequest alloc] init];
    [dirRequest setTransportType:MKDirectionsTransportTypeWalking];
    
    [dirRequest setSource:[MKMapItem mapItemForCurrentLocation]];
    
    if([locations count] > 0)
    {
        for(int i = (int)[locations count] - 1; i >= 0; --i)
        {
            MKPlacemark * destPm = [[MKPlacemark alloc] initWithPlacemark:[[locations objectAtIndex:i] placemark]];
            MKMapItem * destMapItem = [[MKMapItem alloc] initWithPlacemark:destPm];
            
            [dirRequest setDestination:destMapItem];
            
            MKDirections * dirs = [[MKDirections alloc] initWithRequest:dirRequest];
            
            [dirs calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
                if(error != nil)
                {
                    // TODO: handle this better
                    
                    NSLog(@"error occurred calculating directions");
                    NSLog(@"error info: %@", error);
                }
                else
                {
                    MKRoute * route = response.routes.lastObject;
                    [mapView addOverlay:route.polyline level:MKOverlayLevelAboveRoads];
                }
            }];
            
            // the destination of this loop iteration becomes the source for the next...
            [dirRequest setSource:destMapItem];
        }
    }
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

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    MKPolylineRenderer * routeLineRenderer = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
    
    // alternate between red and blue paths (this is for debugging purposes)
    if(colSwitch == NO)
        routeLineRenderer.strokeColor = [UIColor redColor];
    else
        routeLineRenderer.strokeColor = [UIColor blueColor];
    
    colSwitch = !colSwitch;
    
    routeLineRenderer.lineWidth = 5;
    
    return routeLineRenderer;
}

@end
