//
//  MarkLocationViewController+UIAlertViewDelegate.h
//  wayback
//
//  Created by Cory Neale on 31/01/2015.
//  Copyright (c) 2015 Cory Neale. All rights reserved.
//

#import "MarkLocationViewController.h"

@interface MarkLocationViewController (UIAlertViewDelegate) <UIAlertViewDelegate>

- (void) displayLocationServicesAlert;
- (void) displayClearConfirmAlert;

@end
