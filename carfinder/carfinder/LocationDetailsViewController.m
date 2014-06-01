//
//  LocationDetailsViewController.m
//  carfinder
//
//  Created by Cory Neale on 1/06/2014.
//  Copyright (c) 2014 Cory Neale. All rights reserved.
//

#import "LocationDetailsViewController.h"

#import "MapMarker.h"

@interface LocationDetailsViewController ()

@end

@implementation LocationDetailsViewController

#pragma mark - Properties

@synthesize currentIndex;
@synthesize locations;

#pragma mark - Init and Lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    MapMarker * currentLocation = [locations objectAtIndex:currentIndex];
    
    [nameInput setText:currentLocation.name];
    
    NSString * latString = [[NSNumber numberWithDouble:currentLocation.loc.coordinate.latitude] stringValue];
    NSString * lonString = [[NSNumber numberWithDouble:currentLocation.loc.coordinate.longitude] stringValue];
    
    [latitudeLabel setText: latString];
    [longitudeLabel setText: lonString];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"hh:mm a dd-MM-yyyy"];
    NSString * timestampString = [formatter stringFromDate:currentLocation.loc.timestamp];
    
    [timeStampLabel setText: timestampString];
    
    addressLabel.text = currentLocation.address;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions

- (IBAction)nameValueChanged:(id)sender
{
    MapMarker * currentLocation = [locations objectAtIndex:currentIndex];
    [currentLocation setName: [nameInput text]];
}

@end
