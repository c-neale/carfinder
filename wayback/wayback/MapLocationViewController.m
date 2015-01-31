//
//  MapLocationViewController.m
//  wayback
//
//  Created by Cory Neale on 29/05/2014.
//  Copyright (c) 2014 Cory Neale. All rights reserved.
//

#import "MapLocationViewController.h"
#import "MapLocationViewController+MKMapViewDelegate.h"

#import "MapMarker.h"

#import "DataModel.h"

@interface MapLocationViewController ()

#pragma mark - private properties
@property (nonatomic, weak) CLLocation * initialLocation;

#pragma mark - private methods
- (MKMapItem *)createMapItemFromMarker:(MapMarker *)marker;

@end

#pragma mark - defines
#define MAP_VIEW_RADIUS 75.0

@implementation MapLocationViewController

#pragma mark - Init/lifecycle

- (id) initWithLocation:(CLLocation*)location
{
    self = [super initWithNibName:nil bundle:nil];
    if (self)
    {
        _initialLocation = location;
        
        self.title = @"";
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    NSAssert(NO, @"Initialize with -initWithModel:");
    return nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // map view needs to be loaded before we can do stuff with it...
    [_mapView setDelegate:self];
    
    [self setRegionWithLocation:_initialLocation andRadius:MAP_VIEW_RADIUS];
    
    [self addAnnotations];
    [self showDirections];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.screenName = @"MapLocationViewController";
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];    
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
    if ([[DataModel sharedInstance] locations] != nil)
    {
        [_mapView addAnnotations:[[DataModel sharedInstance] locations]];
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
    DataModel * dataModel = [DataModel sharedInstance];
    
    for(int i = 0; i < [dataModel locations].count; ++i)
    {
        MapMarker * source = (i == ([dataModel locations].count - 1)) ? nil : [dataModel objectAtIndex:i+1];
        MapMarker * destination = [dataModel objectAtIndex:i];
        
        [self calculateRouteFrom:source to:destination];
    }
}

- (void)setRegionWithLocation:(CLLocation *)location andRadius:(double)radius;
{
    // TODO: wtf am i doing? current user location should be coming from an instance
    // of the location manager. At this point, the mapview doesn't know the users
    // location, so its obviously returning nil.
//    MKUserLocation *userLocation = _mapView.userLocation;
//    CLLocation * testLoc = userLocation.location;
//    CLLocationCoordinate2D testCoords = testLoc.coordinate;
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(location.coordinate, radius, radius);
    [_mapView setRegion:region animated:NO];
    [_mapView setShowsUserLocation:YES];
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
                //MKMapView * mv = [_delegate mapView];
                
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


@end
