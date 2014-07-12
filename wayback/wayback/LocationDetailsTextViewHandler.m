//
//  LocationDetailsTextViewHandler.m
//  wayback
//
//  Created by Cory Neale on 12/07/2014.
//  Copyright (c) 2014 Cory Neale. All rights reserved.
//

#import "LocationDetailsTextViewHandler.h"

#import "LocationDetailsViewController.h"

@implementation LocationDetailsTextViewHandler

#pragma mark - init

- (id) initWithDelegate:(LocationDetailsViewController *)delegate
{
    self = [super init];
    if(self)
    {
        _delegate = delegate;
    }
    return self;
}

#pragma mark - UITextviewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [_delegate updateAddressEditButtons:YES];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [_delegate updateAddressEditButtons:NO];
}

@end
