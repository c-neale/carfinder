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

#import "LocationProvider.h"
#import "MarkLocationAlertViewHandler.h"


@interface MarkLocationViewController ()

#pragma mark - IBOutlet properties
@property (weak, nonatomic) IBOutlet UITableView *locationTableView;
@property (weak, nonatomic) IBOutlet UIButton *markButton;
@property (weak, nonatomic) IBOutlet UIButton *showButton;

#pragma mark - private properties

@property (nonatomic, strong) UIBarButtonItem * editButton;
@property (nonatomic, strong) UIBarButtonItem * clearButton;

@property (nonatomic, strong) LocationProvider * locationProvider;
@property (nonatomic, strong) MarkLocationAlertViewHandler * alertHandler;

#pragma mark - private methods

- (void) setEditMode:(BOOL)active;
- (void) editButtonPressed;

- (void) clearAllMarkers;

- (void) updateNavbarButtonVisiblity;

- (void) markLocation;
//- (BOOL) shouldPassivelyMarkLocation;

@end

#pragma mark -

@implementation MarkLocationViewController

#pragma mark - Init/Lifecycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        _alertHandler = [[MarkLocationAlertViewHandler alloc] initWithDelegate:self];
        
        // TODO: move this out to a model class, init in the app delegate and pass in a pointer.
        _locations = [[NSMutableArray alloc] init];
        
        _locationProvider = [[LocationProvider alloc] init];
        
        _editButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit"
                                                      style:UIBarButtonItemStylePlain
                                                     target:self
                                                     action:@selector(editButtonPressed)];
        
        _clearButton = [[UIBarButtonItem alloc] initWithTitle:@"Clear"
                                                       style:UIBarButtonItemStylePlain
                                                      target:_alertHandler
                                                      action:@selector(displayClearConfirmAlert)];
        
        self.title = @"The Way Back";
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
    
    self.screenName = @"MarkLocationViewController";
 
    [_locationProvider start];

    [_locationTableView reloadData];
    
    [self updateNavbarButtonVisiblity];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [_locationProvider stop];
    
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
        [_editButton setTitle:@"Stop Editting"];
    }
    else
    {
        [_editButton setTitle:@"Edit"];
    }
    
    [_markButton setEnabled:!active];
    [_showButton setEnabled:!active];
    
    [_locationTableView setEditing:active animated:YES];
}

- (void)editButtonPressed
{
    [self setEditMode:![_locationTableView isEditing]];
}

// TODO: move this to a model class
- (void) clearAllMarkers
{
    [_locations removeAllObjects];
    [_locationTableView reloadData];
}

- (void) updateNavbarButtonVisiblity
{
    if([self.locations count] > 0)
    {
        [[self navigationItem] setLeftBarButtonItem:_clearButton animated:YES];
        [[self navigationItem] setRightBarButtonItem:_editButton animated:YES];
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
    [geocoder reverseGeocodeLocation: _locationProvider.currentLocation
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
                           
                           [_locations addObject:newMarker];
                           
                           // tell the table view it needs to update its data.
                           [_locationTableView reloadData];
                           
                           [self updateNavbarButtonVisiblity];
                           
                       }
                   }];

}

- (void) clearButtonAction
{
    [self clearAllMarkers];
    [self setEditMode:NO];
    [self updateNavbarButtonVisiblity];
}

#pragma mark - IBActions

- (IBAction)FindButtonPressed:(id)sender
{
    MapLocationViewController * mlvc = [[MapLocationViewController alloc] init];
    
    [mlvc setLocations:_locations];
    
    [self.navigationController pushViewController:mlvc animated:YES];
}

- (IBAction)markLocationButtonPressed:(id)sender
{
    if(_locationProvider.currentLocation != nil)
    {
        [self markLocation];
    }
    else
    {
        [LogHelper logAndTrackErrorMessage:@"Location services is off" fromClass:self fromFunction:_cmd];
        
        [_alertHandler displayLocationServicesAlert];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return [_locations count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LocationCell"];
    CLLocation * locationAtIndex = (CLLocation *)[_locations objectAtIndex:indexPath.row];
    
    cell.textLabel.text = locationAtIndex.description;
    
    return cell;
}

- (void)
tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // remove the data from the array
    [_locations removeObjectAtIndex:indexPath.row];
    
    // remove the row from the table
    NSArray * removeIndexes = [[NSArray alloc] initWithObjects:indexPath, nil];
    [tableView deleteRowsAtIndexPaths:removeIndexes withRowAnimation:UITableViewRowAnimationAutomatic];
    
    if([_locations count] == 0)
    {
        [self setEditMode:NO];
        [self updateNavbarButtonVisiblity];
    }
    
    //TODO: work out which routes need re-calculating.
    // for now, just recalculate all of them.
    for(int i = 0; i < [_locations count]; ++i)
    {
        MapMarker * marker = [_locations objectAtIndex:i];
        [marker setRouteCalcRequired:YES];
    }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)source toIndexPath:(NSIndexPath *)dest;
{
    MapMarker * sourceItem = [_locations objectAtIndex:source.row];
    
    [_locations removeObject:sourceItem];
    [_locations insertObject:sourceItem atIndex:dest.row];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LocationDetailsViewController * ldvc = [[LocationDetailsViewController alloc] init];
    
    [ldvc setCurrentIndex:indexPath.row];
    [ldvc setLocations:_locations];
    
    [self.navigationController pushViewController:ldvc animated:YES];
}

@end
