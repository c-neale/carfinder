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
    UIBarButtonItem * editButton;
}

- (void) editLocations;
- (void) updateEditButtonVisiblity;

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
        
        editButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit"
                                                      style:UIBarButtonItemStylePlain
                                                     target:self
                                                     action:@selector(editLocations)];
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
    
    [self updateEditButtonVisiblity];
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

#pragma mark - Class methods

- (void)editLocations
{
    BOOL enterEditMode = YES;
    
    [editButton setTitle:@"Stop Editting"];
    
    if([locationTableView isEditing])
    {
        enterEditMode = NO;
        [editButton setTitle:@"Edit"];
    }
    
    [locationTableView setEditing:enterEditMode animated:YES];
}

- (void) updateEditButtonVisiblity
{
    if([locations count] > 0)
    {
        [[self navigationItem] setRightBarButtonItem:editButton animated:YES];
    }
    else
    {
        [[self navigationItem] setRightBarButtonItem:nil animated:YES];
    }
}

#pragma mark - IBActions

- (IBAction)FindButtonPressed:(id)sender
{
    MapLocationViewController * mlvc = [[MapLocationViewController alloc] init];
    
    [mlvc setLocations:locations];
    
    [self.navigationController pushViewController:mlvc animated:YES];
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
        
        [self updateEditButtonVisiblity];
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
    
    [self updateEditButtonVisiblity];
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
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    // TODO: handle the error better.
    NSLog(@"Location manager failed with error: %@", error.localizedDescription);
}

@end
