//
//  SlideMenuViewController.h
//  TestSlideMenu
//
//  Created by Cory Neale on 19/06/2014.
//  Copyright (c) 2014 Cory Neale. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SlideMenuViewController : UIViewController
{
}

@property (nonatomic, strong) UIViewController * mainController;
@property (nonatomic, strong) UIViewController * leftController;
@property (nonatomic, strong) UIViewController * rightController;

- (id) initWithMainView:(UIViewController *)mainController
            andLeftMenu:(UIViewController *)leftController
           andRightMenu:(UIViewController *)rightController;

- (void) setMainViewController:(Class)newVcClass andSetup:(void (^)(UIViewController * controller))setupBlock;

@end
