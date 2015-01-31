//
//  MapLocationViewController+MKMapViewDelegate.m
//  wayback
//
//  Created by Cory Neale on 31/01/2015.
//  Copyright (c) 2015 Cory Neale. All rights reserved.
//

#import "MapLocationViewController+MKMapViewDelegate.h"

@implementation MapLocationViewController (MKMapViewDelegate)

#pragma mark - constants

const float distanceThreshold = 10.0f;

#pragma mark - MKMapViewDelegate

- (void)mapView:(MKMapView *)mv didUpdateUserLocation:(MKUserLocation *)userLocation
{
    //    mv.centerCoordinate = userLocation.location.coordinate;
    
    NSArray * locations = [[self model] locations];
    
    MapMarker * marker = [locations lastObject];
    float distToMarker = [userLocation.location distanceFromLocation:marker.location];
    
    if(distToMarker < distanceThreshold)
    {
        // remove the pin from the map.
        [mv removeAnnotation:marker];
        
        // get rid of the last object in the list.
        [[self model] removeLastObject];
        
        // set the marker to be the new last marker in the list.
        marker = [[self model] lastObject];
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

#pragma mark - class methods

#pragma mark - private methods



@end
