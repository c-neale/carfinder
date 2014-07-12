//
//  KeyboardNotificationHandler.m
//  wayback
//
//  Created by Cory Neale on 12/07/2014.
//  Copyright (c) 2014 Cory Neale. All rights reserved.
//

#import "KeyboardNotificationHandler.h"

@interface KeyboardNotificationHandler ()

- (void) keyboardWillShow:(NSNotification *) notify;
- (void) keyboardWillBeHidden:(NSNotification *) notify;

@end

@implementation KeyboardNotificationHandler

#pragma mark - init

- (id) initWithDelegate:(UITextView *)delegate
{
    self = [super init];
    if(self)
    {
        _delegate = delegate;
    }
    return self;
}

#pragma mark - class methods

- (void) registerForKeyboardNotifications
{
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void) deregisterForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

- (void) keyboardWillShow:(NSNotification *) notify
{
    if( [_delegate isFirstResponder] )
    {
        NSDictionary* info = [notify userInfo];
        CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
        
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        CGRect addrFrame = _delegate.frame;
        
        float kbTop = screenRect.size.height - kbSize.height;
        float tvTop = addrFrame.origin.y;
        float tvBottom = tvTop + addrFrame.size.height;
        
        // check if the keyboard is obsucring anything.
        if(tvTop > kbTop || tvBottom > kbTop)
        {
            // it is, so we need to find out by how much so we can adjust accordingly.
            float overlap = (tvBottom - kbTop) + 10.0f; // add 10 px so we get a bit of a buffer
            
            [UIView animateWithDuration:0.25f
                                  delay:0.0f
                                options:0
                             animations:^{
                                 
                                 // this assumes that the superview is the viewcontroller root view.
                                 CGRect curFrame = [[_delegate superview] frame];
                                 CGRect adjustedFrame = CGRectMake(curFrame.origin.x,
                                                                   curFrame.origin.y - overlap,
                                                                   curFrame.size.width,
                                                                   curFrame.size.height);
                                 
                                 [[_delegate superview] setFrame:adjustedFrame];
                                 
                             }
                             completion:nil];
        }
    }
}

- (void) keyboardWillBeHidden:(NSNotification *) notify
{
    // move all views back to the default position
    
    [UIView animateWithDuration:0.25f
                          delay:0.0f
                        options:0
                     animations:^{
                         
                         CGRect curFrame = [[_delegate superview] frame];
                         CGRect originalFrame = CGRectMake(0.0f, 0.0f, curFrame.size.width, curFrame.size.height);
                         
                         [[_delegate superview] setFrame: originalFrame];
                         
                     }
                     completion:nil];
    
}


@end
