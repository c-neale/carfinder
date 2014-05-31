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
}

@property (nonatomic, retain) CLLocationManager *locationManager;

@property (nonatomic, strong) NSMutableArray * locations;

- (IBAction)markLocationButtonPressed:(id)sender;
- (IBAction)FindButtonPressed:(id)sender;

// table view delegate functions
// (nothing here...yet)

// table view data source functions
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

// location manager delegate functions
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation;
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error;

@end
