//
//  LocationStore.m
//  wayback
//
//  Created by Cory Neale on 18/02/2015.
//  Copyright (c) 2015 Cory Neale. All rights reserved.
//

#import "LocationStore.h"

@implementation LocationStore

#pragma mark - sharedInstance

+ (LocationStore *) sharedInstance
{
    static LocationStore *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[LocationStore alloc] init];
    });
    
    return _sharedInstance;
}

@end
