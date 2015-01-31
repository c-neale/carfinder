//
//  LocationDetailsViewController+UITextViewDelegate.m
//  wayback
//
//  Created by Cory Neale on 31/01/2015.
//  Copyright (c) 2015 Cory Neale. All rights reserved.
//

#import "LocationDetailsViewController+UITextViewDelegate.h"

@implementation LocationDetailsViewController (UITextViewDelegate)

#pragma mark - UITextviewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [self updateAddressEditButtons:YES];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [self updateAddressEditButtons:NO];
}


@end
