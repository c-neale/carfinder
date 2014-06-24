//
//  LocationListMenuViewController.h
//  wayback
//
//  Created by Cory Neale on 22/06/2014.
//  Copyright (c) 2014 Cory Neale. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LocationListMenuViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>
{
    __weak IBOutlet UITableView *locationsTableView;
}

@property (nonatomic, strong) NSMutableArray * locations;

- (IBAction)clearButtonPressed:(id)sender;
- (IBAction)editButtonPressed:(id)sender;

@end
