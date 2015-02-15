//
//  LocationProvider.h
//  wayback
//
//  Created by Cory Neale on 13/02/2015.
//  Copyright (c) 2015 Cory Neale. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface LocationProvider : NSObject <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocation * currentLocation;

+ (LocationProvider *) sharedInstance;

- (void) start;
- (void) stop;


@end
