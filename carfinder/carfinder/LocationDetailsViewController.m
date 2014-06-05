//
//  LocationDetailsViewController.m
//  carfinder
//
//  Created by Cory Neale on 1/06/2014.
//  Copyright (c) 2014 Cory Neale. All rights reserved.
//

#import "LocationDetailsViewController.h"

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
    [self setupUIFields:currentLocation];
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

#pragma mark - Class methods

- (void) setupUIFields:(MapMarker *)marker
{
    [nameInput setText:marker.name];
    
    CLLocation * location = [marker location];
    
    NSString * latString = [[NSNumber numberWithDouble:location.coordinate.latitude] stringValue];
    NSString * lonString = [[NSNumber numberWithDouble:location.coordinate.longitude] stringValue];
    
    [latitudeLabel setText: latString];
    [longitudeLabel setText: lonString];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"hh:mm a dd-MM-yyyy"];
    NSString * timestampString = [formatter stringFromDate:location.timestamp];
    
    [timeStampLabel setText: timestampString];
    
    addressTextview.text = [marker address];
}

#pragma mark - IBActions

- (IBAction)nameValueChanged:(id)sender
{
    MapMarker * currentLocation = [locations objectAtIndex:currentIndex];
    [currentLocation setName: [nameInput text]];
}

- (IBAction)refineButtonPressed:(id)sender
{
    [addressTextview resignFirstResponder];
    
    CLGeocoder * geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:addressTextview.text
                 completionHandler:^(NSArray *placemarks, NSError *error) {
                    
                     if(error != nil)
                     {
                         //TODO: handle error better
                         NSLog(@"Error occurred looking up address");
                     }
                     else
                     {
                         // TODO: need to handle multiple results somehow...
                         CLPlacemark *placemark = [placemarks lastObject];
                         
                         MapMarker * curMarker = [locations objectAtIndex:currentIndex];
                         [curMarker setPlacemark:placemark];
                         
                         // refresh the ui info
                         [self setupUIFields:curMarker];
                     }
                     
                }];
}

#pragma mark - UITextviewDelegate
/*
- (void)textViewDidBeginEditing:(UITextView *)textView;
- (void)textViewDidEndEditing:(UITextView *)textView;
*/

@end
