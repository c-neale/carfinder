//
//  MarkLocationViewController.h
//  carfinder
//
//  Created by Cory Neale on 29/05/2014.
//  Copyright (c) 2014 Cory Neale. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CoreLocation/CoreLocation.h>

@interface MarkLocationViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate>
{
    CLLocation * currentLocation;
    __weak IBOutlet UITableView *locationTableView;
    __weak IBOutlet UILabel *distanceLabel;
}

@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, strong) NSMutableArray * locations;

- (IBAction)markLocationButtonPressed:(id)sender;
- (IBAction)FindButtonPressed:(id)sender;

@end
