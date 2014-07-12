//
//  MarkLocationAlertViewHandler.h
//  wayback
//
//  Created by Cory Neale on 11/07/2014.
//  Copyright (c) 2014 Cory Neale. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MarkLocationViewController;

@interface MarkLocationAlertViewHandler : NSObject<UIAlertViewDelegate>

@property (nonatomic, weak) MarkLocationViewController * delegate;

- (id) initWithDelegate:(MarkLocationViewController *)delegate;

- (void) displayLocationServicesAlert;
- (void) displayClearConfirmAlert;

@end
