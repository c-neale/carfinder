//
//  MarkLocationViewController.m
//  carfinder
//
//  Created by Cory Neale on 29/05/2014.
//  Copyright (c) 2014 Cory Neale. All rights reserved.
//

#import "MarkLocationViewController.h"

#import "MapLocationViewController.h"
#import "LocationDetailsViewController.h"

#import "MapMarker.h"

@interface MarkLocationViewController ()
{
    
}

- (float) findTotalDistance;

@end

@implementation MarkLocationViewController

#pragma mark - Properties

@synthesize locationManager;
@synthesize locations;

#pragma mark - Init/Lifecycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        locations = [[NSMutableArray alloc] init];
        locationManager = [[CLLocationManager alloc] init];
        
        currentLocation = nil;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void) viewWillAppear:(BOOL)animated
{
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.delegate = self;
    [locationManager startUpdatingLocation];
    
    [locationTableView reloadData];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [locationManager stopUpdatingLocation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - helper functions

- (float) findTotalDistance
{
    float totalDist = 0.0f;
    
    if([locations count] > 0)
    {
        // calc the cumulative distance between all the array elements
        MapMarker * curElement = [locations objectAtIndex:0];
        for (int i = 1; i < [locations count]; ++i)
        {
            MapMarker * marker = [locations objectAtIndex:i];
            
            CLLocation * first = curElement.location;
            CLLocation * second = marker.location;
            
            totalDist += [first distanceFromLocation:second];
            
            curElement = marker;
        }
        
        // and finally add the distance between the last element and the current user position
        
        int lastIndex = (int)[locations count] - 1;
        MapMarker * lastElement = [locations objectAtIndex:lastIndex];

        totalDist += [currentLocation distanceFromLocation:lastElement.location];
    }
    
    return totalDist;
}

- (void) setDistanceText
{
    float distance = [self findTotalDistance];
    NSString * distText = [NSString stringWithFormat:@"Total Distance: %0.2fm", distance];
    distanceLabel.text = distText;
}

#pragma mark - IBActions

- (IBAction)FindButtonPressed:(id)sender
{
    MapLocationViewController * mlvc = [[MapLocationViewController alloc] init];
    
    [mlvc setLocations:locations];
    
    [self.navigationController pushViewController:mlvc animated:YES];
}

- (IBAction)editLocations:(id)sender
{
    BOOL enterEditMode = YES;
    
    if([locationTableView isEditing])
    {
        enterEditMode = NO;
    }
     
    [locationTableView setEditing:enterEditMode animated:YES];
}

- (IBAction)markLocationButtonPressed:(id)sender
{
    if(currentLocation != nil)
    {
        NSString * defaultName = [NSString stringWithFormat:@"Location %lu", (unsigned long)[locations count]];
        
        MapMarker * newMarker = [[MapMarker alloc] initWithName:defaultName
                                                    andLocation:currentLocation];
        
        [locations addObject:newMarker];
        
        // tell the table view it needs to update its data.
        [locationTableView reloadData];
    }
    else
    {
        // TODO: handle the error better
        NSLog(@"currentLocation is nil - something is wrong!");
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return [locations count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LocationCell"];
    CLLocation * locationAtIndex = (CLLocation *)[locations objectAtIndex:indexPath.row];
    
    cell.textLabel.text = locationAtIndex.description;
    
    return cell;
}

- (void)
tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // remove the data from the array
    [locations removeObjectAtIndex:indexPath.row];
    
    // remove the row from the table
    NSArray * removeIndexes = [[NSArray alloc] initWithObjects:indexPath, nil];
    [tableView deleteRowsAtIndexPaths:removeIndexes withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)source toIndexPath:(NSIndexPath *)dest;
{
    MapMarker * sourceItem = [locations objectAtIndex:source.row];
    
    [locations removeObject:sourceItem];
    [locations insertObject:sourceItem atIndex:dest.row];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LocationDetailsViewController * ldvc = [[LocationDetailsViewController alloc] init];
    
    [ldvc setCurrentIndex:indexPath.row];
    [ldvc setLocations:locations];
    
    [self.navigationController pushViewController:ldvc animated:YES];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    // just silently store the location so we know where they are when the button is pressed.
    currentLocation = newLocation;
    
    // update the distance label. // TODO: needs to be called in a few more places.
    [self setDistanceText];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    // TODO: handle the error better.
    NSLog(@"Location manager failed with error: %@", error.localizedDescription);
}

@end
