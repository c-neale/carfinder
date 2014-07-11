//
//  MapViewHandler.m
//  wayback
//
//  Created by Cory Neale on 3/07/2014.
//  Copyright (c) 2014 Cory Neale. All rights reserved.
//

#import "MapViewHandler.h"

@interface MapViewHandler ()

+ (MKMapItem *)createMapItemFromMarker:(MapMarker *)marker;

@end

@implementation MapViewHandler

#pragma mark - constants

const float distanceThreshold = 10.0f;

#pragma mark - init method(s)

- (id) initWithModel:(NSMutableArray *)locations
{
    self = [super init];
    if(self)
    {
        _locations = locations;
    }
    return self;
}

#pragma mark - class methods

+ (void) mapView:(MKMapView *)mv calculateRouteFrom:(MapMarker *)source to:(MapMarker *)dest
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
                    [mv removeOverlay:dest.route.polyline];
                }
                
                // get the route from the response object
                MKRoute * route = response.routes.lastObject;
                
                // apply the new route overlay to the map.
                [mv addOverlay:route.polyline level:MKOverlayLevelAboveRoads];
                
                // store the route on the destination for future reference.
                [dest setRoute:route];
            }
        }];
    }
}

#pragma mark - private methods

+ (MKMapItem *)createMapItemFromMarker:(MapMarker *)marker
{
    if(marker == nil)
    {
        return [MKMapItem mapItemForCurrentLocation];
    }
    
    MKPlacemark * markerPm = [[MKPlacemark alloc] initWithPlacemark:marker.placemark];
    return [[MKMapItem alloc] initWithPlacemark:markerPm];
}

#pragma mark - MKMapViewDelegate

- (void)mapView:(MKMapView *)mv didUpdateUserLocation:(MKUserLocation *)userLocation
{
    MapMarker * marker = [_locations lastObject];
    float distToMarker = [userLocation.location distanceFromLocation:marker.location];
    
    if(distToMarker < distanceThreshold)
    {
        // remove the pin from the map.
        [mv removeAnnotation:marker];
        
        // get rid of the last object in the list.
        [_locations removeLastObject];
        
        // set the marker to be the new last marker in the list.
        marker = [_locations lastObject];
    }
    
    // now update the path from the current location to the last marker in the list...
    [marker setRouteCalcRequired:YES];
    [MapViewHandler mapView:mv calculateRouteFrom:nil to:marker];
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
