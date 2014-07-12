//
//  LocationDetailsTextViewHandler.h
//  wayback
//
//  Created by Cory Neale on 12/07/2014.
//  Copyright (c) 2014 Cory Neale. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LocationDetailsViewController;

@interface LocationDetailsTextViewHandler : NSObject<UITextViewDelegate>

@property (nonatomic, weak) LocationDetailsViewController * delegate;

- (id) initWithDelegate:(LocationDetailsViewController *)delegate;

@end
