//
//  MarkLocationTableViewHandler.m
//  wayback
//
//  Created by Cory Neale on 11/07/2014.
//  Copyright (c) 2014 Cory Neale. All rights reserved.
//

#import "MarkLocationTableViewHandler.h"

#import "MarkLocationViewController.h"
#import "LocationDetailsViewController.h"

#import "MapMarker.h"

@implementation MarkLocationTableViewHandler

#pragma mark - init

- (id) initWithDelegate:(MarkLocationViewController *)delegate andModel:(NSMutableArray *)locations
{
    self = [super init];
    if( self )
    {
        _delegate = delegate;
        _locations = locations;
    }
    return self;
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
        [_delegate setEditMode:NO];
        [_delegate updateNavbarButtonVisiblity];
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
    
    [_delegate.navigationController pushViewController:ldvc animated:YES];
}

@end
