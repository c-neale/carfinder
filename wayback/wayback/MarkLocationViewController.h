//
//  MarkLocationViewController.h
//  wayback
//
//  Created by Cory Neale on 29/05/2014.
//  Copyright (c) 2014 Cory Neale. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DataModel.h"

#import "GAI.h"

@interface MarkLocationViewController : GAITrackedViewController

//@property (nonatomic, strong) NSMutableArray * locations;
@property (nonatomic, weak) DataModel * model;

- (id) initWithModel:(DataModel *)model;

- (IBAction)markLocationButtonPressed:(id)sender;
- (IBAction)FindButtonPressed:(id)sender;

- (void) clearButtonAction;

- (void) setEditMode:(BOOL)active;
- (void) updateNavbarButtonVisiblity;

@end
