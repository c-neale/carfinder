//
//  MapLocationViewController.m
//  wayback
//
//  Created by Cory Neale on 29/05/2014.
//  Copyright (c) 2014 Cory Neale. All rights reserved.
//

#import "MapLocationViewController.h"

#import "MapViewHandler.h"
#import "MapMarker.h"

@interface MapLocationViewController ()

#pragma mark - private properties
@property (nonatomic, strong) MapViewHandler * mapHandler;

@property (nonatomic, weak) CLLocation * initialLocation;

#pragma mark - private methods

@end

#pragma mark - defines
#define MAP_VIEW_RADIUS 75.0

@implementation MapLocationViewController

#pragma mark - Init/lifecycle

- (id) initWithModel:(DataModel *)model andLocation:(CLLocation*)location
{
    self = [super initWithNibName:nil bundle:nil];
    if (self)
    {
        _mapHandler = [[MapViewHandler alloc] initWithDelegate:self];
        _initialLocation = location;
        _model = model;
        
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
    [_mapView setDelegate:_mapHandler];
    
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
    if ([_model locations] != nil)
    {
        [_mapView addAnnotations:[_model locations]];
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
    for(int i = 0; i < [_model locations].count; ++i)
    {
        MapMarker * source = (i == ([_model locations].count - 1)) ? nil : [_model objectAtIndex:i+1];
        MapMarker * destination = [_model objectAtIndex:i];
        
        [_mapHandler calculateRouteFrom:source to:destination];
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
