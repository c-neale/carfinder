//
//  GeocodeProvider.m
//  wayback
//
//  Created by Cory Neale on 13/07/2014.
//  Copyright (c) 2014 Cory Neale. All rights reserved.
//

#import "GeocodeProvider.h"

@interface GeocodeProvider ()

@property (nonatomic, strong) NSMutableDictionary * reverseGeocodeCache;

@end

@implementation GeocodeProvider

#pragma mark - init

// see http://www.galloway.me.uk/tutorials/singleton-classes/ for singleton implementation.
+ (id) sharedInstance
{
    static GeocodeProvider * geocodeProvider = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        geocodeProvider = [[self alloc] init];
    });
    return geocodeProvider;
}

// TODO: this should never be called, make it private somehow.
- (id) init
{
    self = [super init];
    if(self)
    {
        _reverseGeocodeCache = [[NSMutableDictionary alloc] init];
    }
    return self;
}

#pragma mark - class methods

- (void) geocodeAddress:(NSString *)address onComplete:(onCompleteBlock)onComplete
{
    CLGeocoder * geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:address
                 completionHandler:^(NSArray *placemarks, NSError *error) {
                     
                     if(error != nil)
                     {
                         DebugLog(@"error domain: %@ code: %d", error.domain, (int)error.code);
                         [LogHelper logAndTrackError:error fromClass:self fromFunction:_cmd];
                     }
                     else
                     {
                         // TODO: need to handle multiple results somehow...
                         CLPlacemark *placemark = [placemarks lastObject];
                         
                         if(onComplete)
                         {
                             onComplete(placemark);
                         }
                         
                         /*
                         MapMarker * curMarker = [_locations objectAtIndex:_currentIndex];
                         [curMarker setPlacemark:placemark];
                         
                         // refresh the ui info
                         [self setupUIFields:curMarker];
                          */
                     }
                     
                 }];
}

- (void) reverseGeocodeLocation:(CLLocation *)location onComplete:(onCompleteBlock)onComplete
{
    // check for a cached version...
    MKPlacemark * placemark = [_reverseGeocodeCache objectForKey:location];
    if(placemark != nil)
    {
        if(onComplete != nil)
        {
            onComplete(placemark);
        }

        return;
    }
    
    CLGeocoder * geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location
                   completionHandler:^(NSArray * placemarks, NSError * error) {
                       if(error != nil)
                       {
                           [LogHelper logAndTrackError:error fromClass:self fromFunction:_cmd];
                           
                           switch(error.code)
                           {
                               case kCLErrorNetwork:
                                   DebugLog(@"no network access, or geocode flooding detected");
                                   break;
                               default:
                                   break;
                           }
                       }
                       else
                       {
                           // this should never get multiples, but log it just in case...
                           if([placemarks count] > 1)
                           {
                               DebugLog(@"Multiple places found! (%d total)", (int)[placemarks count]);
                           }
                           
                           CLPlacemark * placemark = [placemarks lastObject];
                           
                           if(onComplete != nil)
                           {
                               onComplete(placemark);
                           }
                           
                           // add it to the cache.
                           [_reverseGeocodeCache setObject:placemark forKey:location];
                       }
                   }];
    
}

@end
