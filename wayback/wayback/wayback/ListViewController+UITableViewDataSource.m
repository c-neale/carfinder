//
//  ListViewController+UITableViewDataSource.m
//  wayback
//
//  Created by Cory Neale on 14/02/2015.
//  Copyright (c) 2015 Cory Neale. All rights reserved.
//

#import "ListViewController+UITableViewDataSource.h"

@implementation ListViewController (UITableViewDataSource)

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // TODO: check for existing reusable instances...
    // TODO: replace this with correct cell type...
    return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ListCell"];
}

@end
