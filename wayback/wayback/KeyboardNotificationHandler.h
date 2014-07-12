//
//  KeyboardNotificationHandler.h
//  wayback
//
//  Created by Cory Neale on 12/07/2014.
//  Copyright (c) 2014 Cory Neale. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KeyboardNotificationHandler : NSObject

@property (nonatomic, weak) UITextView * delegate;

- (id) initWithDelegate:(UITextView *)delegate;

- (void) registerForKeyboardNotifications;
- (void) deregisterForKeyboardNotifications;

@end
