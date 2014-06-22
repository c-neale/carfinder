//
//  ViewControllerRegistry.m
//  TestSlideMenu
//
//  Created by Cory Neale on 22/06/2014.
//  Copyright (c) 2014 Cory Neale. All rights reserved.
//

#import "ViewControllerRegistry.h"

@implementation ViewControllerRegistry

- (id) init
{
    self = [super init];
    if(self)
    {
        registry = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void) registerViewController:(UIViewController *)viewController
{
    // if it already exists, overwrite it.
    NSString * className = NSStringFromClass([viewController class]);
    [registry setObject:viewController forKey:className];
}

- (UIViewController *) getFromRegistry:(Class)vcClass
{
    NSString * className = NSStringFromClass(vcClass);
    UIViewController * controller = [registry objectForKey:className];
    
    // if its not found, create one, register it and return it.
    if(controller == nil)
    {
        controller = [[vcClass alloc] init];
        [self registerViewController:controller];
    }
    
    return controller;
}

- (void) clear
{
    [registry removeAllObjects];
}


@end
