//
//  LocationListMenuViewController.m
//  wayback
//
//  Created by Cory Neale on 22/06/2014.
//  Copyright (c) 2014 Cory Neale. All rights reserved.
//

#import "LocationListMenuViewController.h"

#import "MapMarker.h"

@interface LocationListMenuViewController ()
{
    
}

- (void) clearAllMarkers;

@end

@implementation LocationListMenuViewController

#pragma mark - Properties

@synthesize locations;

#pragma mark - Init and lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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

    [locationsTableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Class methods

- (void) clearAllMarkers
{
    [locations removeAllObjects];
    [locationsTableView reloadData];
}

#pragma mark - IBActions

- (IBAction)clearButtonPressed:(id)sender
{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Are you sure?"
                                                     message:@"Are you sure you want to clear all?"
                                                    delegate:self
                                           cancelButtonTitle:@"No"
                                           otherButtonTitles:@"Yes", nil];
    
    [alert show];

}

- (IBAction)editButtonPressed:(id)sender
{
    BOOL isActive = [locationsTableView isEditing];
    
    [locationsTableView setEditing:!isActive animated:YES];
    
    if(isActive)
    {
        [(UIButton *)sender setTitle:@"Edit" forState:UIControlStateNormal];
    }
    else
    {
        [(UIButton *)sender setTitle:@"Stop Editting" forState:UIControlStateNormal];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return [locations count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LocationCell"];
    MapMarker * locationAtIndex = (MapMarker *)[locations objectAtIndex:indexPath.row];
    
    [cell setBackgroundColor:[UIColor clearColor]];
    
    cell.textLabel.text = locationAtIndex.description;
    
    return cell;
}

- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // remove the data from the array
    [locations removeObjectAtIndex:indexPath.row];
    
    // remove the row from the table
    NSArray * removeIndexes = [[NSArray alloc] initWithObjects:indexPath, nil];
    [tableView deleteRowsAtIndexPaths:removeIndexes withRowAnimation:UITableViewRowAnimationAutomatic];
        
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
    // TODO: hook this up to work? somehow?
    
    /*
    LocationDetailsViewController * ldvc = [[LocationDetailsViewController alloc] init];
    
    [ldvc setCurrentIndex:indexPath.row];
    [ldvc setLocations:locations];
    
    [self.navigationController pushViewController:ldvc animated:YES];
     */
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
                [locationsTableView reloadData];
                break;
            case 0:
            default:
                break;
        }
    }
}

@end
