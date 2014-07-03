//
//  MarkLocationViewController.h
//  wayback
//
//  Created by Cory Neale on 29/05/2014.
//  Copyright (c) 2014 Cory Neale. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GAI.h"

#import <CoreLocation/CoreLocation.h>

@interface MarkLocationViewController : GAITrackedViewController<UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate, UIAlertViewDelegate>

@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, strong) NSMutableArray * locations;

- (IBAction)markLocationButtonPressed:(id)sender;
- (IBAction)FindButtonPressed:(id)sender;

@end
