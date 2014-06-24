//
//  MarkLocationViewController.h
//  wayback
//
//  Created by Cory Neale on 29/05/2014.
//  Copyright (c) 2014 Cory Neale. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GAI.h"
#import "SMMainViewDelegate.h"

#import <CoreLocation/CoreLocation.h>

@interface MarkLocationViewController : GAITrackedViewController<CLLocationManagerDelegate, SMMainViewDelegate>
{
    CLLocation * currentLocation;
    
    __weak IBOutlet UIButton *markButton;
    __weak IBOutlet UIButton *showButton;
}

@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, strong) NSMutableArray * locations;

- (IBAction)markLocationButtonPressed:(id)sender;
- (IBAction)FindButtonPressed:(id)sender;

@end
