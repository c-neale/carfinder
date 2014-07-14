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

- (id) initWithDelegate:(MarkLocationViewController *)delegate andModel:(DataModel *)model
{
    self = [super init];
    if( self )
    {
        _delegate = delegate;
        _model = model;
    }
    return self;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return [[_model locations] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"LocationCell"];
    MapMarker * locationAtIndex = [_model objectAtIndex:indexPath.row];
        
    cell.textLabel.text = locationAtIndex.name;
    cell.detailTextLabel.text = locationAtIndex.shortAddress;
    
    return cell;
}

- (void)
tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // remove the data from the array
    [_model removeObjectAtIndex:indexPath.row];
    
    // remove the row from the table
    NSArray * removeIndexes = [[NSArray alloc] initWithObjects:indexPath, nil];
    [tableView deleteRowsAtIndexPaths:removeIndexes withRowAnimation:UITableViewRowAnimationAutomatic];
    
    if([[_model locations] count] == 0)
    {
        [_delegate setEditMode:NO];
        [_delegate updateNavbarButtonVisiblity];
    }
    
    // reset the flags so the routes will get correctly recalculated.
    [_model resetRouteCalculationFlags];
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)source toIndexPath:(NSIndexPath *)dest;
{
    [_model moveObjectAtIndex:source.row to:dest.row];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LocationDetailsViewController * ldvc = [[LocationDetailsViewController alloc] initWithModel:_model];
    [ldvc setCurrentIndex:indexPath.row];
    
    [_delegate.navigationController pushViewController:ldvc animated:YES];
}

@end
