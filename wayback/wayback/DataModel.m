//
//  DataModel.m
//  wayback
//
//  Created by Cory Neale on 13/07/2014.
//  Copyright (c) 2014 Cory Neale. All rights reserved.
//

#import "DataModel.h"

#import "GeocodeProvider.h"

@interface DataModel ()

// TODO: add a public readonly property to access this as an NSArray.
// all changes should be done through this class.
@property (nonatomic, strong) NSMutableArray * locations;

@end

@implementation DataModel

#pragma mark - init

- (id) init
{
    self = [super init];
    {
        _locations = [[NSMutableArray alloc] init];
    }
    return self;
}

#pragma mark - non-auto properties

- (NSArray *) locations
{
    return [NSArray arrayWithArray:_locations];
}

#pragma mark - class methods

- (void) addLocation:(CLLocation *)newLocation postInit:(postInitialiseMarker)postInit
{
    MapMarker * newMarker = [[MapMarker alloc] init];
    
    [[GeocodeProvider sharedInstance] reverseGeocodeLocation:newLocation
                                                  onComplete:^(CLPlacemark * placemark) {
                                                      [newMarker setPlacemark:placemark];
                                                      [newMarker setInitialised:YES];
                                                      
                                                      if(postInit != nil)
                                                      {
                                                          postInit();
                                                      }
                                                  }];
    
    [_locations addObject:newMarker];
}

- (MapMarker *) objectAtIndex:(NSUInteger)index
{
    return [_locations objectAtIndex:index];
}

- (void) removeObjectAtIndex:(NSUInteger) index
{
    [_locations removeObjectAtIndex:index];
}

- (void) clearAllLocations
{
    [_locations removeAllObjects];
}

- (void) moveObjectAtIndex:(NSUInteger)sourceIndex to:(NSUInteger)destIndex
{
    MapMarker * sourceItem = [_locations objectAtIndex:sourceIndex];
    
    [_locations removeObject:sourceItem];
    [_locations insertObject:sourceItem atIndex:destIndex];
}

- (void) resetRouteCalculationFlags
{
    // TODO: work out which routes need re-calculating.  for now, just recalculate all of them.
    for(int i = 0; i < [_locations count]; ++i)
    {
        MapMarker * marker = [_locations objectAtIndex:i];
        [marker setRouteCalcRequired:YES];
    }
}
@end
