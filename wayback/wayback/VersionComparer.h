//
//  VersionComparer.h
//  wayback
//
//  Created by Cory Neale on 2/05/2014.
//  Copyright (c) 2014 Cory Neale. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum VersionCompareTypes {
    
    VersionCompareSame = 0,
    VersionCompareCurrentIsNewer,
    VersionCompareCurrentIsOlder,
    
    // used to signify an error - ie version string contained alpha chars
    VersionCompareUnkown
    
} VersionCompare;

@interface VersionComparer : NSObject

+ (VersionCompare)CompareVersionString: (NSString*) current withString: (NSString*) compare;

@end
