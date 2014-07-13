//
//  DataModel.h
//  wayback
//
//  Created by Cory Neale on 13/07/2014.
//  Copyright (c) 2014 Cory Neale. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <MapKit/MapKit.h>

@interface DataModel : NSObject

@property (nonatomic, strong) NSMutableArray * locations;

- (id) init;

- (void) addLocation:(CLLocation *) newLocation;
- (void) clearAllLocations;

@end
