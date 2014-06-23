//
//  SlideMenuViewController.m
//  TestSlideMenu
//
//  Created by Cory Neale on 19/06/2014.
//  Copyright (c) 2014 Cory Neale. All rights reserved.
//

#import "SlideMenuViewController.h"
#import "ViewControllerRegistry.h"

#import "SMMainViewDelegate.h"

typedef enum
{
    sdLeft = 0,
    sdRight,
    sdCentre,
} SlideDirection;

@interface SlideMenuViewController ()
{
    // TODO: can we work this out on the fly?
    BOOL leftMenuVisible;
    BOOL rightMenuVisible;
    
    UIBarButtonItem * leftBarButton;
    UIBarButtonItem * rightBarButton;
    
    ViewControllerRegistry * registry;
}

@property (nonatomic, strong) UINavigationController * navController;

- (void) initRightViewController:(UIViewController *)rightVc;
- (void) initLeftViewController:(UIViewController *)leftVc;
- (void) initMainViewController:(UIViewController *)mainVc;

- (void) setupMenuButtons;
- (void) setupGestures;

- (void) toggleLeftMenu;
- (void) toggleRightMenu;

- (void) swipeLeftAction;
- (void) swipeRightAction;

- (void) addSubViewController:(UIViewController *)subVc;
- (void) removeSubViewController:(UIViewController *)subVc;

- (void) slideAnim:(SlideDirection)dir;

@end

@implementation SlideMenuViewController

#pragma mark - Properties

@synthesize mainController;
@synthesize leftController;
@synthesize rightController;

#pragma mark - private properties

@synthesize navController;

#pragma mark - init and lifecycle

- (id) initWithMainView:(UIViewController *)main
            andLeftMenu:(UIViewController *)left
           andRightMenu:(UIViewController *)right
{
    self = [super init];
    if(self)
    {
        [self initRightViewController:right];
        [self initLeftViewController:left];
        [self initMainViewController:main];
        
        leftMenuVisible = rightMenuVisible = NO;
        
        [self setupMenuButtons];
        [self setupGestures];
        
        registry = [[ViewControllerRegistry alloc] init];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    [registry clear];
}

#pragma mark - init helper functions

- (void) initRightViewController:(UIViewController *)rightVc
{
    // do this outside the if statement. we want to explicitly set the property to nil if that's what was passed in.
    [self setRightController:rightVc];
    
    if(rightVc != nil)
    {
        [self addSubViewController:rightVc];
        [registry registerViewController:rightVc];
    }
}

- (void) initLeftViewController:(UIViewController *)leftVc
{
    [self setLeftController:leftVc];
    
    if(leftVc != nil)
    {
        [self addSubViewController:leftVc];
        [registry registerViewController:leftVc];
    }
}

- (void) initMainViewController:(UIViewController<SMMainViewDelegate> *)mainVc
{
    [self setMainController:mainVc];

    // no real need to check for nil values, this should never be nil.
    
    // create a navigation controller to hold the main view controller.
    navController = [[UINavigationController alloc] initWithRootViewController:mainController];
    [self addSubViewController:navController];
    
    [registry registerViewController:mainVc];
}

#pragma mark - public methods

- (void) setMainViewController:(Class)newVcClass andSetup:(void (^)(UIViewController * controller))setupBlock
{
    if(newVcClass != [mainController class])
    {
        UIViewController<SMMainViewDelegate> * nextController = (UIViewController<SMMainViewDelegate> *)[registry getFromRegistry:newVcClass];
    
        if(setupBlock != nil)
        {
            setupBlock(nextController);
        }
        
        self.mainController = nextController;
        
        NSArray * viewArray = [[NSArray alloc] initWithObjects:nextController, nil];
        [navController setViewControllers:viewArray];
        
        // menu buttons appear to get cleared when we do the above, so re-add em.
        [self setupMenuButtons];
    }
    
    [self slideAnim:sdCentre];
}

#pragma mark - Class methods

- (void) addSubViewController:(UIViewController *)subVc
{
    [self addChildViewController:subVc];
    [self.view addSubview:subVc.view];
    
    [subVc didMoveToParentViewController:self];
}

- (void) removeSubViewController:(UIViewController *)subVc
{
    [subVc removeFromParentViewController];
    [subVc.view removeFromSuperview];
    
    [subVc willMoveToParentViewController:nil];
}

- (void) setupMenuButtons
{
    if(leftController != nil)
    {
        if(leftBarButton == nil)
        {
            leftBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Left Menu"
                                                             style:UIBarButtonItemStyleBordered
                                                            target:self
                                                            action:@selector(toggleLeftMenu)];
        }
    
        [[self.mainController navigationItem] setLeftBarButtonItem:leftBarButton animated:YES];
    }

    if(rightController != nil)
    {
        if(rightBarButton == nil)
        {
            rightBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Right Menu"
                                                              style:UIBarButtonItemStyleBordered
                                                             target:self
                                                             action:@selector(toggleRightMenu)];
        }
    
        [[self.mainController navigationItem] setRightBarButtonItem:rightBarButton animated:YES];
    }
}

- (void) setupGestures
{    
    UISwipeGestureRecognizer * swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                     action:@selector(swipeLeftAction)];
    [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.view addGestureRecognizer:swipeLeft];
    
    UISwipeGestureRecognizer * swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                      action:@selector(swipeRightAction)];
    [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer:swipeRight];
}

- (void) swipeLeftAction
{
    if(rightMenuVisible == NO)
    {
        if(leftMenuVisible == NO && rightController != nil)
        {
            [self slideAnim:sdLeft];
        }
        else
        {
            [self slideAnim:sdCentre];
        }
    }
}

- (void) swipeRightAction
{
    if(leftMenuVisible == NO)
    {
        if(rightMenuVisible == NO && leftController != nil)
        {
            [self slideAnim:sdRight];
        }
        else
        {
            [self slideAnim:sdCentre];
        }
    }
}

- (void) toggleLeftMenu
{
    if(leftMenuVisible == NO)
    {
        [self slideAnim:sdRight];
    }
    else
    {
        [self slideAnim:sdCentre];
    }
}

- (void) toggleRightMenu
{
    if(rightMenuVisible == NO)
    {
        [self slideAnim:sdLeft];
    }
    else
    {
        [self slideAnim:sdCentre];
    }
}

- (void) executeIfResponds:(UIViewController<SMMainViewDelegate> *)main toSelector:(SEL)selector withData:(UIViewController *)menu
{
    if([main respondsToSelector:selector])
    {
        // calling [main performSelector:selector withObject:menu]; thows a warning about memory leaks.
        // see http://stackoverflow.com/a/20058585 for a full explanation of whats going on below.
        IMP impl = [main methodForSelector:selector];
        void (*func)(id, SEL, UIViewController *) = (void *)impl;
        func(main, selector, menu);
    }
}

// TODO: this function has a crap name.
- (void) slideAnim:(SlideDirection)dir
{
    float xPos = 0.0f;
    
    switch(dir)
    {
        case sdLeft:
            [self executeIfResponds:mainController toSelector:@selector(showRightMenu:) withData:rightController];
            [rightController viewWillAppear:NO];
            
            xPos = 60.0f - mainController.view.frame.size.width;
            [self.view sendSubviewToBack:leftController.view];
            break;
        case sdRight:
            
            // call the showLeftMenu: selector on the main controller to pass any data to the menu
            [self executeIfResponds:mainController toSelector:@selector(showLeftMenu:) withData:leftController];
            
            // call the view will appear method to set up the view before we display it.
            [leftController viewWillAppear:NO];
            
            xPos = mainController.view.frame.size.width - 60.0f;
            [self.view sendSubviewToBack:rightController.view];
            break;
        case sdCentre:
            [mainController viewWillAppear:NO];
        default:
            break;
    }
    
    [UIView animateWithDuration:0.25f
                          delay:0.0f
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         
                         navController.view.frame = CGRectMake(xPos,
                                                               mainController.view.frame.origin.y,
                                                               mainController.view.frame.size.width,
                                                               mainController.view.frame.size.height);
                     }
                     completion:^(BOOL finished) {
                         leftMenuVisible = (dir == sdRight);
                         rightMenuVisible = (dir == sdLeft);
                     }];
}

@end
