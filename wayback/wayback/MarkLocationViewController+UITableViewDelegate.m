//
//  MarkLocationViewController+UITableViewDelegate.m
//  wayback
//
//  Created by Cory Neale on 31/01/2015.
//  Copyright (c) 2015 Cory Neale. All rights reserved.
//

#import "MarkLocationViewController+UITableViewDelegate.h"

#import "LocationDetailsViewController.h"

@implementation MarkLocationViewController (UITableViewDelegate)

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LocationDetailsViewController * ldvc = [[LocationDetailsViewController alloc] init];
    [ldvc setCurrentIndex:indexPath.row];
    
    [self.navigationController pushViewController:ldvc animated:YES];
}


@end
