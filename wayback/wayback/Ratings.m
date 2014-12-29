//
//  Ratings.m
//  wayback
//
//  Created by Cory Neale on 29/12/2014.
//  Copyright (c) 2014 Cory Neale. All rights reserved.
//

#import "Ratings.h"

#import "Appirater.h"

@implementation Ratings

+ (void) SetupForAppId:(NSString*) appId
{
    [Appirater setAppId:appId];
    
    [Appirater setDaysUntilPrompt: 1];
    [Appirater setUsesUntilPrompt:2];
    [Appirater setTimeBeforeReminding:2.0];
    
    [Appirater setVersion:0]; // TODO: this should probably be different for each version...(can we automate this somehow?)
    
    // TODO: potentially split this out to another function...
    [Appirater appLaunched:YES];
    
#ifdef DEBUG
    [Appirater setDebug:YES];
#else
    [Appirater setDebug:NO];
#endif
}

+ (void) enteredForeground
{
    [Appirater appEnteredForeground:YES];
}

+ (void) exitedForeground
{
    [Appirater appEnteredForeground:NO];
}

+ (void) registerEvent
{
    [Appirater userDidSignificantEvent:YES];
}

@end
