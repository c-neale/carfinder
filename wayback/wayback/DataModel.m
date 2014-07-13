//
//  DataModel.m
//  wayback
//
//  Created by Cory Neale on 13/07/2014.
//  Copyright (c) 2014 Cory Neale. All rights reserved.
//

#import "DataModel.h"

#import "MapMarker.h"

@implementation DataModel

- (id) init
{
    self = [super init];
    {
        _locations = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void) addLocation:(CLLocation *)newLocation
{
    MapMarker * newMarker = [[MapMarker alloc] init];
    [_locations addObject:newMarker];
}

- (void) clearAllLocations
{
    [_locations removeAllObjects];
}

@end
