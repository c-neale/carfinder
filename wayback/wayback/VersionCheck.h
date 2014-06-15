//
//  VersionCheck.h
//  wayback
//
//  Created by Cory Neale on 8/06/2014.
//  Copyright (c) 2014 Cory Neale. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VersionCheck : NSObject<UIAlertViewDelegate>
{
    
}

- (void) newVersionForId:(int)appId;

@end
