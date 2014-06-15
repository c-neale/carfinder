//
//  LogHelper.h
//  wayback
//
//  Created by Cory Neale on 10/06/2014.
//  Copyright (c) 2014 Cory Neale. All rights reserved.
//

#import <Foundation/Foundation.h>

// comment this line out for release builds.
#define DEBUG_MODE

#ifdef DEBUG_MODE

#define DebugLog( s, ... ) NSLog( @"<%p %@:(%d)> %@", self, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )

#else

#define DebugLog( s, ... )

#endif

@interface LogHelper : NSObject
{
    
}

+ (void) logAndTrackError:(NSError *) error fromClass:(id)object fromFunction:(SEL)selector;
+ (void) logAndTrackErrorMessage:(NSString *)message fromClass:(id)object fromFunction:(SEL)selector;

@end
