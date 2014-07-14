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


#pragma mark - private methods

@end

#pragma mark -

@implementation MapLocationViewController

#pragma mark - Init/lifecycle

- (id) initWithModel:(DataModel *)model
{
    self = [super initWithNibName:nil bundle:nil];
    if (self)
    {
        _mapHandler = [[MapViewHandler alloc] initWithDelegate:self];
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
    
    [_mapView setDelegate:_mapHandler];
    
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
