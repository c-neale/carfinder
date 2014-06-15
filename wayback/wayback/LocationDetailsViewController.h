//
//  LocationDetailsViewController.h
//  wayback
//
//  Created by Cory Neale on 1/06/2014.
//  Copyright (c) 2014 Cory Neale. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GAI.h"

#import "MapMarker.h"

@interface LocationDetailsViewController : GAITrackedViewController<UITextViewDelegate>
{
    __weak IBOutlet UITextField *nameInput;
    __weak IBOutlet UILabel *latitudeLabel;
    __weak IBOutlet UILabel *longitudeLabel;
    __weak IBOutlet UILabel *timeStampLabel;
    __weak IBOutlet UITextView *addressTextview;
}

@property (nonatomic) NSUInteger currentIndex;
@property (nonatomic) NSArray * locations;

- (void) setupUIFields:(MapMarker *)marker;

- (IBAction)nameValueChanged:(id)sender;

@end
