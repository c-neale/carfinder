//
//  DataModel.m
//  wayback
//
//  Created by Cory Neale on 13/07/2014.
//  Copyright (c) 2014 Cory Neale. All rights reserved.
//

#import "DataModel.h"

#import "GeocodeProvider.h"

@interface DataModel ()

@property (nonatomic, strong) NSMutableArray * locations;

- (NSString *) itemArchivePath;

@end

@implementation DataModel

#pragma mark - sharedInstance

+ (DataModel *) sharedInstance
{
    static DataModel *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[DataModel alloc] init];
    });
    
    return _sharedInstance;
}

#pragma mark - init

- (id) init
{
    self = [super init];
    {
        _locations = [[NSMutableArray alloc] init];
    }
    return self;
}

#pragma mark - non-auto properties

- (NSArray *) locations
{
    return [NSArray arrayWithArray:_locations];
}

#pragma mark - class methods

- (void) addLocation:(CLLocation *)newLocation postInit:(postInitialiseMarker)postInit
{
    MapMarker * newMarker = [[MapMarker alloc] init];
    
    [[GeocodeProvider sharedInstance] reverseGeocodeLocation:newLocation
                                                  onComplete:^(CLPlacemark * placemark) {
                                                      [newMarker setPlacemark:placemark];
                                                      [newMarker setInitialised:YES];
                                                      
                                                      if(postInit != nil)
                                                      {
                                                          postInit();
                                                      }
                                                  }];
    
    [_locations addObject:newMarker];
}

- (MapMarker *) objectAtIndex:(NSUInteger)index
{
    return [_locations objectAtIndex:index];
}

- (MapMarker *) lastObject
{
    return [_locations lastObject];
}

- (void) removeObjectAtIndex:(NSUInteger) index
{
    [_locations removeObjectAtIndex:index];
}

- (void) removeLastObject
{
    [_locations removeLastObject];
}

- (void) clearAllLocations
{
    [_locations removeAllObjects];
}

- (void) moveObjectAtIndex:(NSUInteger)sourceIndex to:(NSUInteger)destIndex
{
    MapMarker * sourceItem = [_locations objectAtIndex:sourceIndex];
    
    [_locations removeObject:sourceItem];
    [_locations insertObject:sourceItem atIndex:destIndex];
}

- (void) resetRouteCalculationFlags
{
    // TODO: work out which routes need re-calculating.  for now, just recalculate all of them.
    for(int i = 0; i < [_locations count]; ++i)
    {
        MapMarker * marker = [_locations objectAtIndex:i];
        [marker setRouteCalcRequired:YES];
    }
}

#pragma mark saving/loading

- (NSString *) itemArchivePath
{
    // search for the documents directory (last 2 parameters are always the same for iOS)
    NSArray * documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    // for iOS, the above will always only return 1 result, so just get the first thing in the array.
    NSString * documentDirectory = [documentDirectories objectAtIndex:0];
    
    return [documentDirectory stringByAppendingPathComponent:@"locations.archive"];
}

- (BOOL) saveModel
{
    NSString * path = [self itemArchivePath];
    return [NSKeyedArchiver archiveRootObject:_locations toFile:path];
}

- (void) loadModel
{
    NSString * path = [self itemArchivePath];
    _locations = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    
    // if the file doesn't exist, unarchiver will return nil, so check and create an empty array to handle this case.
    if(_locations == nil)
    {
        _locations = [[NSMutableArray alloc] init];
    }
}

@end
