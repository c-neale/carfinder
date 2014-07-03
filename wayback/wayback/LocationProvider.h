//
//  LocationManagerProvider.h
//  wayback
//
//  Created by Cory Neale on 3/07/2014.
//  Copyright (c) 2014 Cory Neale. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <CoreLocation/CoreLocation.h>

@interface LocationProvider : NSObject<CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocation * currentLocation;

- (id) init;

- (void) start;
- (void) stop;

@end
