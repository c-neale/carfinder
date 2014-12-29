//
//  Ratings.h
//  wayback
//
//  Created by Cory Neale on 29/12/2014.
//  Copyright (c) 2014 Cory Neale. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Ratings : NSObject

+ (void) SetupForAppId:(NSString*) appId; // TODO: bad name, change this.

+ (void) enteredForeground;
+ (void) exitedForeground;

@end
