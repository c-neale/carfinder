//
//  LocationProvider+CLLocationManagerDelegate.h
//  wayback
//
//  Created by Cory Neale on 18/02/2015.
//  Copyright (c) 2015 Cory Neale. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#import "LocationProvider.h"

extern NSString * const LocationProviderUpdatedNotification;

@interface LocationProvider (CLLocationManagerDelegate) <CLLocationManagerDelegate>

@end
