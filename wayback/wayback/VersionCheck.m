//
//  VersionCheck.m
//  wayback
//
//  Created by Cory Neale on 8/06/2014.
//  Copyright (c) 2014 Cory Neale. All rights reserved.
//

#import "VersionCheck.h"

#import "VersionComparer.h"

@interface VersionCheck ()

- (void) handleResponseWithData:(NSData *)data;
- (NSString *) getAppVersion;
- (NSString *) parseVersionFromData:(NSData *) data;

@end

@implementation VersionCheck

#pragma mark - constants

// (although its not really a constant...
#define INFO_URL_FORMAT @"http://itunes.apple.com/lookup?id=%d"

- (id) init
{
    self = [super init];
    if(self)
    {
        _alertViewHandler = [[VersionCheckAlertViewHandler alloc] init];
    }
    return self;
}

- (void) newVersionForId:(int)appId
{
    NSString * urlString = [NSString stringWithFormat:INFO_URL_FORMAT, appId];
    NSURL * url = [NSURL URLWithString:urlString];
    
    NSURLRequest * request = [[NSURLRequest alloc] initWithURL:url];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connError) {
                                if(connError != nil)
                                {
                                    //TODO: handle error correctly
                                    DebugLog(@"connection error when attempting url request: %@", connError.debugDescription);
                                }
                                else
                                {
                                    [self handleResponseWithData:data];
                                    
                                }
                            }];
}

- (void) handleResponseWithData:(NSData *)data
{
    
    NSString * appVersion = [self getAppVersion];
    NSString * storeVersion = [self parseVersionFromData:data];
    
    VersionCompare isNewer = [VersionComparer CompareVersionString:appVersion withString:storeVersion];
    
    if(isNewer == VersionCompareCurrentIsOlder)
    {
        // show prompt for user to upgrade...
        [_alertViewHandler displayVersionAlert];
    }
}

- (NSString *) getAppVersion
{
    NSDictionary * infoDict = [[NSBundle mainBundle] infoDictionary];
    
    NSString * version = [infoDict objectForKey:@"CFBundleShortVersionString"];
//    NSString * build = [infoDict objectForKey:(NSString *)kCFBundleVersionKey];
    
    return version;
}

- (NSString *) parseVersionFromData:(NSData *) data
{
    NSError * parseError = nil;
    NSDictionary * parsedObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
    
    if( parseError != nil )
    {
        DebugLog(@"Error detected checking for updated version: %@", parseError.debugDescription);
        return @"";
    }
    
    NSArray * results = [parsedObject objectForKey:@"results"];
    
    // multiple results should never occur, lets assume we always have 1 result.
    NSDictionary * result = [results objectAtIndex:0];
    
    NSString * storeVersion = [result objectForKey:@"version"];
    
    return storeVersion;
}

@end
