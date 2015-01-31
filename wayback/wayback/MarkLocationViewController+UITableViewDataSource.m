//
//  MarkLocationViewController+UITableViewDataSource.m
//  wayback
//
//  Created by Cory Neale on 31/01/2015.
//  Copyright (c) 2015 Cory Neale. All rights reserved.
//

#import "MarkLocationViewController+UITableViewDataSource.h"

#import "DataModel.h"

@implementation MarkLocationViewController (UITableViewDataSource)

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return [[[DataModel sharedInstance] locations] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"LocationCell"];
    MapMarker * locationAtIndex = [[DataModel sharedInstance] objectAtIndex:indexPath.row];
    
    cell.textLabel.text = locationAtIndex.name;
    cell.detailTextLabel.text = locationAtIndex.shortAddress;
    
    return cell;
}

- (void)
tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // remove the data from the array
    [[DataModel sharedInstance] removeObjectAtIndex:indexPath.row];
    
    // remove the row from the table
    NSArray * removeIndexes = [[NSArray alloc] initWithObjects:indexPath, nil];
    [tableView deleteRowsAtIndexPaths:removeIndexes withRowAnimation:UITableViewRowAnimationAutomatic];
    
    if([[[DataModel sharedInstance] locations] count] == 0)
    {
        [self setEditMode:NO];
        [self updateNavbarButtonVisiblity];
    }
    
    // reset the flags so the routes will get correctly recalculated.
    [[DataModel sharedInstance] resetRouteCalculationFlags];
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)source toIndexPath:(NSIndexPath *)dest;
{
    [[DataModel sharedInstance] moveObjectAtIndex:source.row to:dest.row];
}


@end
