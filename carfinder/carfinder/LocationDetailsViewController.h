//
//  LocationDetailsViewController.h
//  carfinder
//
//  Created by Cory Neale on 1/06/2014.
//  Copyright (c) 2014 Cory Neale. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LocationDetailsViewController : UIViewController
{
    __weak IBOutlet UITextField *nameInput;
    __weak IBOutlet UILabel *latitudeLabel;
    __weak IBOutlet UILabel *longitudeLabel;
    __weak IBOutlet UILabel *timeStampLabel;
    __weak IBOutlet UILabel *addressLabel;
}

@property (nonatomic) NSUInteger currentIndex;
@property (nonatomic) NSArray * locations;

- (IBAction)nameValueChanged:(id)sender;

@end
