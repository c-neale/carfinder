//
//  ViewControllerRegistry.h
//  TestSlideMenu
//
//  Created by Cory Neale on 22/06/2014.
//  Copyright (c) 2014 Cory Neale. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ViewControllerRegistry : NSObject
{
    NSMutableDictionary * registry;
}

- (id) init;

- (void) registerViewController:(UIViewController *)viewController;
- (UIViewController *) getFromRegistry:(Class)vcClass;
- (void) clear;

@end
