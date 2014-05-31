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

@synthesize locations;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {

    }
    return self;
}

- (void) addAnnotations:(NSArray *)locs
{
    [self removeAnnotations];
    
    NSMutableArray * annots = [[NSMutableArray alloc] init];
    for (int i = 0; i < [locs count]; ++i)
    {
        MapMarker * mm = [[MapMarker alloc] init];
     
        [mm setName:[NSString stringWithFormat:@"Location %d", i]];
        [mm setLoc:[locs objectAtIndex:i]];
        
        [annots addObject:mm];
    }
    
    [mapView addAnnotations:annots];
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    mapView.showsUserLocation = YES;
    mapView.delegate = self;
    
    MKUserLocation *userLocation = mapView.userLocation;
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.location.coordinate, 50, 50);
    [mapView setRegion:region animated:NO];
    
    [mapView setCenterCoordinate:userLocation.coordinate animated:NO];

    [self addAnnotations:locations];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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

-(void)mapView:(MKMapView *)mv didUpdateUserLocation:(MKUserLocation *)userLocation
{
    [mapView setCenterCoordinate:userLocation.coordinate animated:NO];
}

@end
