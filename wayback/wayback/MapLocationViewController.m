//
//  MapLocationViewController.m
//  wayback
//
//  Created by Cory Neale on 29/05/2014.
//  Copyright (c) 2014 Cory Neale. All rights reserved.
//

#import "MapLocationViewController.h"

#import "MapMarker.h"

@interface MapLocationViewController ()

#pragma mark - private properties

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

#pragma mark - private methods

- (void) calculateRouteFrom:(MapMarker *)source to:(MapMarker *)dest;
- (MKMapItem *)createMapItemFromMarker:(MapMarker *)marker;

@end

#pragma mark -

@implementation MapLocationViewController

#pragma mark - constants

const float distanceThreshold = 10.0f;

#pragma mark - Init/lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        //colSwitch = NO;
        
        self.title = @"";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _mapView.showsUserLocation = YES;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.screenName = @"MapLocationViewController";
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    MKUserLocation *userLocation = _mapView.userLocation;
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.location.coordinate, 50, 50);
    [_mapView setRegion:region animated:NO];

    [_mapView setCenterCoordinate:userLocation.coordinate animated:NO];
    
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
    if (_locations != nil)
    {
        [_mapView addAnnotations:_locations];
    }
}

// maybe move this to a category class?
- (void)removeAnnotations
{
    id userLocation = [_mapView userLocation];
    NSMutableArray * pins = [[NSMutableArray alloc] initWithArray:[_mapView annotations]];
    if ( userLocation != nil ) {
        [pins removeObject:userLocation]; // avoid removing user location off the map
    }
    
    [_mapView removeAnnotations:pins];
    pins = nil;
}

- (void) showDirections
{
    for(int i = 0; i < _locations.count; ++i)
    {
        MapMarker * source = (i == (_locations.count - 1)) ? nil : [_locations objectAtIndex:i+1];
        MapMarker * destination = [_locations objectAtIndex:i];
        
        [self calculateRouteFrom:source to:destination];
    }
}

- (void) calculateRouteFrom:(MapMarker *)source to:(MapMarker *)dest
{
    if([dest routeCalcRequired] == YES)
    {
        [dest setRouteCalcRequired:NO];
        
        MKDirectionsRequest * dirRequest = [[MKDirectionsRequest alloc] init];
        [dirRequest setTransportType:MKDirectionsTransportTypeWalking];

        [dirRequest setSource:[self createMapItemFromMarker:source]];
        [dirRequest setDestination:[self createMapItemFromMarker:dest]];
    
        MKDirections * dirs = [[MKDirections alloc] initWithRequest:dirRequest];
    
        [dirs calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
            if(error != nil)
            {
                DebugLog(@"error domain: %@ code: %d", error.domain, (int)error.code);
                
                [LogHelper logAndTrackError:error fromClass:self fromFunction:_cmd];
                
                // reset this flag so it will get processed again next time.
                [dest setRouteCalcRequired:YES];
            }
            else
            {
                // remove the current overlay, if it exists
                if(dest.route != nil)
                {
                    [_mapView removeOverlay:dest.route.polyline];
                }
                
                // get the route from the response object
                MKRoute * route = response.routes.lastObject;
                
                // apply the new route overlay to the map.
                [_mapView addOverlay:route.polyline level:MKOverlayLevelAboveRoads];
                
                // store the route on the destination for future reference.
                [dest setRoute:route];
            }
        }];
    }
}

- (MKMapItem *)createMapItemFromMarker:(MapMarker *)marker
{
    if(marker == nil)
    {
        return [MKMapItem mapItemForCurrentLocation];
    }
    
    MKPlacemark * markerPm = [[MKPlacemark alloc] initWithPlacemark:marker.placemark];
    return [[MKMapItem alloc] initWithPlacemark:markerPm];
}

#pragma mark - IBActions

- (IBAction)changeMapType:(UISegmentedControl *)sender
{
    switch(sender.selectedSegmentIndex)
    {
        case 0:
            _mapView.mapType = MKMapTypeStandard;
            break;
        case 1:
            _mapView.mapType = MKMapTypeSatellite;
            break;
        case 2:
            _mapView.mapType = MKMapTypeHybrid;
            break;
    }
}

#pragma mark - MKMapViewDelegate

- (void)mapView:(MKMapView *)mv didUpdateUserLocation:(MKUserLocation *)userLocation
{
    MapMarker * marker = [_locations lastObject];
    float distToMarker = [userLocation.location distanceFromLocation:marker.location];
    
    if(distToMarker < distanceThreshold)
    {
        // remove the pin from the map.
        [_mapView removeAnnotation:[_locations lastObject]];
        
        // get rid of the last object in the list.
        [_locations removeLastObject];
        
        // set the marker to be the new last marker in the list.
        marker = [_locations lastObject];
    }
    
    // now update the path from the current location to the last marker in the list...
    [marker setRouteCalcRequired:YES];
    [self calculateRouteFrom:nil to:marker];
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    MKPolylineRenderer * routeLineRenderer = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
    
/*
    if(colSwitch == NO) // alternate between red and blue paths (this is for debugging purposes)
    {
        routeLineRenderer.strokeColor = [UIColor redColor];
        routeLineRenderer.lineDashPhase = 5.0f;
    }
    else
    {
        routeLineRenderer.strokeColor = [UIColor blueColor];
        routeLineRenderer.lineDashPhase = 10.0f;
    }
    
    colSwitch = !colSwitch;

    routeLineRenderer.lineDashPattern = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:2], [NSNumber numberWithInt:12], nil];
*/
    routeLineRenderer.strokeColor = [UIColor redColor];
    routeLineRenderer.lineWidth = 5;
    
    return routeLineRenderer;
}

@end
