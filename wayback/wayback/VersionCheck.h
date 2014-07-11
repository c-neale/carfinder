//
//  VersionCheck.h
//  wayback
//
//  Created by Cory Neale on 8/06/2014.
//  Copyright (c) 2014 Cory Neale. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "VersionCheckAlertViewHandler.h"

@interface VersionCheck : NSObject

@property (nonatomic, strong) VersionCheckAlertViewHandler * alertViewHandler;

- (id) init;

- (void) newVersionForId:(int)appId;

@end
