//
//  MarkLocationViewController.m
//  wayback
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
    UIBarButtonItem * clearButton;
}

- (void) setEditMode:(BOOL)active;
- (void) editButtonPressed;

- (void) promptToClear;
- (void) clearAllMarkers;

- (void) updateNavbarButtonVisiblity;

- (void) markLocation;
- (BOOL) shouldPassivelyMarkLocation;

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
                                                     action:@selector(editButtonPressed)];
        
        clearButton = [[UIBarButtonItem alloc] initWithTitle:@"Clear"
                                                       style:UIBarButtonItemStylePlain
                                                      target:self
                                                      action:@selector(promptToClear)];
        
        self.title = @"Wayback";
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
    [super viewWillAppear:animated];
    
    self.screenName = @"Mark Locations";
    
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.delegate = self;
    [locationManager startUpdatingLocation];
    
    [locationTableView reloadData];
    
    [self updateNavbarButtonVisiblity];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [locationManager stopUpdatingLocation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Class methods

- (void)setEditMode:(BOOL)active
{
    if( active )
    {
        [editButton setTitle:@"Stop Editting"];
    }
    else
    {
        [editButton setTitle:@"Edit"];
    }
    
    [markButton setEnabled:!active];
    [showButton setEnabled:!active];
    
    [locationTableView setEditing:active animated:YES];
}

- (void)editButtonPressed
{
    [self setEditMode:![locationTableView isEditing]];
}

- (void) promptToClear
{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Are you sure?"
                                                     message:@"Are you sure you want to clear all?"
                                                    delegate:self
                                           cancelButtonTitle:@"No"
                                           otherButtonTitles:@"Yes", nil];
    
    [alert show];
}

- (void) clearAllMarkers
{
    [locations removeAllObjects];
    [locationTableView reloadData];
}

- (void) updateNavbarButtonVisiblity
{
    if([locations count] > 0)
    {
        [[self navigationItem] setLeftBarButtonItem:clearButton animated:YES];
        [[self navigationItem] setRightBarButtonItem:editButton animated:YES];
    }
    else
    {
        [[self navigationItem] setLeftBarButtonItem:nil animated:YES];
        [[self navigationItem] setRightBarButtonItem:nil animated:YES];
    }
}

- (void) markLocation
{
    CLGeocoder * geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:currentLocation
                   completionHandler:^(NSArray * placemarks, NSError * error) {
                       if(error != nil)
                       {
                           [LogHelper logAndTrackError:error fromClass:self fromFunction:_cmd];
                           
                           switch(error.code)
                           {
                               case kCLErrorNetwork:
                                   DebugLog(@"no network access, or geocode flooding detected");
                                   break;
                               default:
                                   break;
                           }
                       }
                       else
                       {
                           if([placemarks count] > 1)
                           {
                               DebugLog(@"Multiple places found! (%d total)", (int)[placemarks count]);
                           }
                           
                           // TODO: handle multiple results somehow? how often will this happen?
                           MapMarker * newMarker = [[MapMarker alloc] initWithPlacemark:[placemarks lastObject]];
                           
                           [locations addObject:newMarker];
                           
                           // tell the table view it needs to update its data.
                           [locationTableView reloadData];
                           
                           [self updateNavbarButtonVisiblity];
                           
                       }
                   }];

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
        [self markLocation];
    }
    else
    {
        NSString * errorTitle = @"Unable to find location";
        NSString * errorMessage = @"Unable to find your current location.  Please enable location services in the privacy settings and try again";
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:errorTitle
                                                         message:errorMessage
                                                        delegate:nil
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];
        [alert show];
        
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
    
    if([locations count] == 0)
    {
        [self setEditMode:NO];
        [self updateNavbarButtonVisiblity];
    }
    
    //TODO: work out which routes need re-calculating.
    // for now, just recalculate all of them.
    for(int i = 0; i < [locations count]; ++i)
    {
        MapMarker * marker = [locations objectAtIndex:i];
        [marker setRouteCalcRequired:YES];
    }
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

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // need to be sure which alert view we are working with.
    // although there is probably a better way of doing this.
    if([[alertView title]  isEqual: @"Are you sure?"])
    {
        // check which button was pressed and process it.
        switch (buttonIndex) {
            case 1:
                [self clearAllMarkers];
                [self setEditMode:NO];
                [self updateNavbarButtonVisiblity];
                break;
            case 0:
            default:
                break;
        }
    }
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    // just silently store the location so we know where they are when the button is pressed.
    currentLocation = newLocation;

    // TODO: this needs way more thought.
/*    if([self shouldPassivelyMarkLocation])
    {
        [self markLocation];
    }
     */
}

- (BOOL) shouldPassivelyMarkLocation
{
    BOOL passiveMode = YES;
    
    // if we are not in passive mode, obviously should be a NO.
    if(passiveMode == NO)
    {
        DebugLog(@"Passive Mode is disabled");
        return NO;
    }

    if([locations count] == 0)
        return NO;
    
    /*
     // TODO: this triggers multiple times. need to fix it.
    // if we have no markers yet, then definately mark the current loction.
    if([locations count] == 0)
    {
        DebugLog(@"Adding first location.");
        return YES;
    }
     */
    
    CLLocation * prevLocation = [(MapMarker *)[locations lastObject] location];

    // check if the direction of travel is changing.
    CLLocationDirection prevDir = prevLocation.course;
    CLLocationDirection curDir = currentLocation.course;
    
    // TODO: I need to rethink this whole process.
    // if the deviation is greater than 5 degrees AND the distance is less than 10 or time is less than 5min,
    // we should be replacing the last marker instead of just adding a new one.  this method probably isnt the
    //place for that to happen, but i dont want to be doubling up on checking the conditions.
    double deviation = fabs(prevDir - curDir);
    DebugLog(@"Course Deviation: %f degrees", deviation);
//    if(deviation < 5.0)
    {
        // if we have moved less than x metres, then also NO.
        // TODO: make the 10.0f less hardcoded. value should ideally match the threshold to remove a marker.
        CLLocationDistance distFromLastMarker = [currentLocation distanceFromLocation:prevLocation];
        DebugLog(@"distance from last marker: %f m", distFromLastMarker);
        if(distFromLastMarker < 10.0f)
        {
            return NO;
        }
    
        // don't set a marker too often...
        NSDate * prevTime = prevLocation.timestamp;
        NSDate * thisTime = currentLocation.timestamp;
    
        NSTimeInterval interval = [thisTime timeIntervalSinceDate:prevTime];
        double minsSinceLastMarker = interval / 60.0f;
    
        DebugLog(@"minutes since last marker: %f", minsSinceLastMarker);
        if(minsSinceLastMarker < 1.0f) // TODO: make the 5.0f less hardcoded.
        {
            return NO;
        }
    }
    
    return YES;
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    // TODO: contains hardcoded strings.  should probably put them somewhere better.
    
    BOOL displayMessage = NO;
    NSString * errorTitle = @"";
    NSString * errorMessage = @"";
    
    DebugLog(@"Error domain: %@ code: %d", error.domain, (int)error.code);
    
    switch(error.code)
    {
        case kCLErrorDenied:
            
            displayMessage = YES;
            errorTitle = @"Unable to find location";
            errorMessage = @"Unable to find your current location.  Please enable location services in the privacy settings and try again";
            
            DebugLog(@"Access to location services is denied. need to prompt user");
            break;
        case kCLErrorLocationUnknown:
            DebugLog(@"Could not find location right now. will keep trying. - safe to ignore.");
            break;
        case kCLErrorHeadingFailure:
            DebugLog(@"could not determine heading at this time. will keep trying - safe to ignore.");
            break;
        default:

            displayMessage = YES;
            errorTitle = @"Unknown Error";
            errorMessage = @"Unable to find location due to unknown error. Please try again later.";

            DebugLog(@"An unhandled error occurred while attempting to find user location.");
            DebugLog(@"message: %@", error.debugDescription);
            break;
    }
 
    if( displayMessage )
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:errorTitle
                                                     message:errorMessage
                                                    delegate:nil
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil];
        [alert show];
        
    }
}

@end
