//
//  MarkLocationAlertViewHandler.h
//  wayback
//
//  Created by Cory Neale on 11/07/2014.
//  Copyright (c) 2014 Cory Neale. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MarkLocationViewController.h"

@interface MarkLocationAlertViewHandler : NSObject<UIAlertViewDelegate>

@property (nonatomic, strong) MarkLocationViewController * delegate;

- (id) initWithDelegate:(MarkLocationViewController *)delegate;

- (void) displayLocationServicesAlert;
- (void) displayClearConfirmAlert;

@end
