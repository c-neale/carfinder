//
//  LocationDetailsViewController.m
//  wayback
//
//  Created by Cory Neale on 1/06/2014.
//  Copyright (c) 2014 Cory Neale. All rights reserved.
//

#import "LocationDetailsViewController.h"

#import <QuartzCore/QuartzCore.h>

@interface LocationDetailsViewController ()
{
    UIBarButtonItem * cancelEditButton;
    UIBarButtonItem * commitEditButton;
}

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

        cancelEditButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                            style:UIBarButtonItemStylePlain
                                                           target:self
                                                           action:@selector(cancelAddressChange)];
        
        commitEditButton = [[UIBarButtonItem alloc] initWithTitle:@"Refine"
                                                            style:UIBarButtonItemStylePlain
                                                           target:self
                                                           action:@selector(commitAddressChange)];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // add a border to the textview
    addressTextview.layer.borderWidth = 1.0f;
    addressTextview.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    addressTextview.layer.cornerRadius = 8.0f;
    
    MapMarker * currentLocation = [locations objectAtIndex:currentIndex];
    [self setupUIFields:currentLocation];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.screenName = @"LocationDetailsViewController";
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

- (void) updateAddressEditButtons:(BOOL) setVisible
{
    if(setVisible)
    {
        [[self navigationItem] setLeftBarButtonItem:cancelEditButton animated:YES];
        [[self navigationItem] setRightBarButtonItem:commitEditButton animated:YES];
    }
    else
    {
        [[self navigationItem] setLeftBarButtonItem:nil animated:YES];
        [[self navigationItem] setRightBarButtonItem:nil animated:YES];
    }
}

- (void) cancelAddressChange
{
    // stop editting/make keyboard disappear.
    [addressTextview resignFirstResponder];
    
    // refresh the data back to original
    [self setupUIFields:[locations objectAtIndex:currentIndex]];
}

- (void) commitAddressChange
{
    [addressTextview resignFirstResponder];
    
    CLGeocoder * geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:addressTextview.text
                 completionHandler:^(NSArray *placemarks, NSError *error) {
                     
                     if(error != nil)
                     {
                         DebugLog(@"error domain: %@ code: %d", error.domain, (int)error.code);
                         [LogHelper logAndTrackError:error fromClass:self fromFunction:_cmd];
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

#pragma mark - IBActions

- (IBAction)nameValueChanged:(id)sender
{
    MapMarker * currentLocation = [locations objectAtIndex:currentIndex];
    [currentLocation setName: [nameInput text]];
}

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
