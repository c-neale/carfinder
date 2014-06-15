//
//  LogHelper.m
//  wayback
//
//  Created by Cory Neale on 15/06/2014.
//  Copyright (c) 2014 Cory Neale. All rights reserved.
//

#import "LogHelper.h"

#import "GAI.h"
#import "GAIDictionaryBuilder.h"

@interface LogHelper ()
{
    
}

+ (void) logAndTrackString:(NSString *)str;

@end

@implementation LogHelper

#pragma mark - Internal category methods

+ (void) logAndTrackString:(NSString *)str
{
    DebugLog(str, nil);  // add nil parameter to prevent compiler warning.
    
    // send error to analytics for tracking.
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder
                    createExceptionWithDescription:str
                    withFatal:NO] build]];
}

#pragma mark - Static methods

+ (void) logAndTrackError:(NSError *) error fromClass:(id)object fromFunction:(SEL)selector
{
    NSString * errorString = [NSString stringWithFormat:@"error: class[%@] function[%@] domain[%@] code[%d]", NSStringFromClass([object class]), NSStringFromSelector(selector), error.domain, (int)error.code ];
    
    [LogHelper logAndTrackString:errorString];
}

+ (void) logAndTrackErrorMessage:(NSString *)message fromClass:(id)object fromFunction:(SEL)selector
{
    NSString * errorString = [NSString stringWithFormat:@"error: class[%@] function[%@] message[%@]", NSStringFromClass([object class]), NSStringFromSelector(selector), message];
    
    [LogHelper logAndTrackString:errorString];
}


@end