//
//  VersionCheck.m
//  carfinder
//
//  Created by Cory Neale on 8/06/2014.
//  Copyright (c) 2014 Cory Neale. All rights reserved.
//

#import "VersionCheck.h"

#import "VersionComparer.h"

@interface VersionCheck ()
{
    
}

- (void) handleResponseWithData:(NSData *)data;
- (NSString *) getAppVersion;
- (NSString *) parseVersionFromData:(NSData *) data;

@end

@implementation VersionCheck

#define INFO_URL_FORMAT @" http://itunes.apple.com/lookup?id=%d"

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
                                    NSLog(@"connection error when attempting url request: %@", connError.debugDescription);
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
        //TODO: prompt user to upgrade...
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"New Version"
                                                        message:@"There is a new version, get it from the App Store!"
                                                       delegate:self
                                              cancelButtonTitle:@"Not now"
                                              otherButtonTitles:@"Get it", nil];
        
        [alert show];
    }
}

- (NSString *) getAppVersion
{
    NSDictionary * infoDict = [[NSBundle mainBundle] infoDictionary];
    
    // TODO: work out which one of these we need...
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
        // TODO: better error handling...
        NSLog(@"Error detected checking for updated version: %@", parseError.debugDescription);
        return @"";
    }
    
    NSDictionary * results = [parsedObject objectForKey:@"results"];
    NSString * storeVersion = [results objectForKey:@"version"];
    
    return storeVersion;
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    NSString * bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
    NSString * urlString = [NSString stringWithFormat:@"itms://itunes.com/apps/id/%@", bundleIdentifier];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];

    // for future reference: linking to the developer's app pages
    //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms://itunes.com/apps/developername"]];//
    //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.com/apps/DevelopmentCompanyLLC"]];
    
    
    /*
    switch(buttonIndex)
    {
        case 0:
            break;
        case 1:
            break;
    }*/
}

@end
