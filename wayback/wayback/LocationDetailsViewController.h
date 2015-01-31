//
//  LocationDetailsViewController.h
//  wayback
//
//  Created by Cory Neale on 1/06/2014.
//  Copyright (c) 2014 Cory Neale. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GAI.h"

#import "MapMarker.h"

@interface LocationDetailsViewController : GAITrackedViewController

@property (nonatomic) NSUInteger currentIndex;

- (id) init;

- (IBAction)nameValueChanged:(id)sender;
- (void) updateAddressEditButtons:(BOOL) setVisible;

@end
