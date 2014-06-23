//
//  SMMainMenuDelegate.h
//  TestSlideMenu
//
//  Created by Cory Neale on 23/06/2014.
//  Copyright (c) 2014 Cory Neale. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SMMainViewDelegate <NSObject>

@optional
- (void) showLeftMenu:(UIViewController *)leftMenuController;
- (void) showRightMenu:(UIViewController *)rightMenuController;

@end
