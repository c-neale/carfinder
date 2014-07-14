//
//  DataModel.h
//  wayback
//
//  Created by Cory Neale on 13/07/2014.
//  Copyright (c) 2014 Cory Neale. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <MapKit/MapKit.h>

#import "MapMarker.h"

@interface DataModel : NSObject

typedef void (^postInitialiseMarker) (void);

- (id) init;

- (NSArray *) locations;

- (void) addLocation:(CLLocation *) newLocation postInit:(postInitialiseMarker)postInit;

- (MapMarker *) objectAtIndex:(NSUInteger)index;
- (MapMarker *) lastObject;

- (void) removeObjectAtIndex:(NSUInteger) index;
- (void) removeLastObject;

- (void) clearAllLocations;
- (void) moveObjectAtIndex:(NSUInteger)sourceIndex to:(NSUInteger)destIndex;

- (void) resetRouteCalculationFlags;

@end
