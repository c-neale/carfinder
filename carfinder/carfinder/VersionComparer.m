//
//  VersionComparer.m
//  Magic8Ball
//
//  Created by Cory Neale on 2/05/2014.
//
//

#import "VersionComparer.h"

@implementation VersionComparer

+ (VersionCompare) CompareVersionString:(NSString *)current withString:(NSString *)compare
{
    if ( ![self IsValidVersionNumber:current] || ![self IsValidVersionNumber:compare])
    {
        // return an unknown/Error value here. exceptions are expensive and shoulf be avoided.
        return VersionCompareUnkown;
    }
    
    if ([current length] == 0 || [compare length] == 0)
    {
        // if one of the strings is empty, no valid comparison can be made.
        return VersionCompareUnkown;
    }
    
    // tokenize the strings so we can compare each component
    NSArray * currentTokens = [current componentsSeparatedByString:@"."];
    NSArray * compareTokens = [compare componentsSeparatedByString:@"."];
    
    // make sure that each array contains the same number of components.
    while (currentTokens.count < compareTokens.count)
    {
        currentTokens = [self PadArray:currentTokens withString:@"0"];
    }
    while (compareTokens.count < currentTokens.count)
    {
        compareTokens = [self PadArray:compareTokens withString:@"0"];
    }
    
    for (int i = 0; i < currentTokens.count; ++i)
    {
        // convert to integers first so we can compare.
        NSUInteger currentNum = [[currentTokens objectAtIndex:i] intValue];
        NSUInteger compareNum = [[compareTokens objectAtIndex:i] intValue];
        
        if (currentNum > compareNum)
        {
            return VersionCompareCurrentIsNewer;
        }
        else if (compareNum > currentNum)
        {
            return VersionCompareCurrentIsOlder;
        }
    }
    
    // if it didn't match any of the conditions above, then they must be the same version.
    return VersionCompareSame;
}

+ (BOOL) IsValidVersionNumber: (NSString *) str
{
    // use a regular expression to test if the strings contain any chars.
    // this function only supports numerical version numbers.
    NSError * regexError = nil;
    NSRange regexRange = NSMakeRange(0, [str length]);
    NSString * regexPattern = @"^[0-9.]*$";
    
    NSRegularExpression * regex = [[NSRegularExpression alloc] initWithPattern:regexPattern options:0 error: &regexError];
    
    NSArray * matches = [regex matchesInString:str options:0 range:regexRange];
    
    return matches.count > 0;
}

+ (NSArray *) PadArray: (NSArray*) arr withString:(NSString*) str
{
    NSMutableArray * mut = [arr mutableCopy];
    [mut addObject:str];
    
    return [mut copy];
}

@end
