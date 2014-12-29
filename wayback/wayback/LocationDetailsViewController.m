//
//  LocationDetailsViewController.m
//  wayback
//
//  Created by Cory Neale on 1/06/2014.
//  Copyright (c) 2014 Cory Neale. All rights reserved.
//

#import "LocationDetailsViewController.h"

#import <QuartzCore/QuartzCore.h>

#import "LocationDetailsTextViewHandler.h"
#import "KeyboardNotificationHandler.h"

#import "GeocodeProvider.h"

@interface LocationDetailsViewController ()

#pragma mark - IBOutlet properties
@property (weak, nonatomic) IBOutlet UITextField *nameInput;
@property (weak, nonatomic) IBOutlet UILabel *latitudeLabel;
@property (weak, nonatomic) IBOutlet UILabel *longitudeLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeStampLabel;
@property (weak, nonatomic) IBOutlet UITextView *addressTextView;

#pragma mark - private properties
@property (nonatomic, strong) UIBarButtonItem * cancelEditButton;
@property (nonatomic, strong) UIBarButtonItem * commitEditButton;

@property (nonatomic, strong) LocationDetailsTextViewHandler * textViewHandler;
@property (nonatomic, strong) KeyboardNotificationHandler * keyboardHandler;

- (void) setupUIFields:(MapMarker *)marker;

@end

@implementation LocationDetailsViewController

#pragma mark - Init and Lifecycle

- (id) initWithModel:(DataModel *)model
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        
        _model = model;
        
        _textViewHandler = [[LocationDetailsTextViewHandler alloc] initWithDelegate:self];
        _keyboardHandler = [[KeyboardNotificationHandler alloc] initWithDelegate:_addressTextView];
        
        _cancelEditButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                             style:UIBarButtonItemStylePlain
                                                            target:self
                                                            action:@selector(cancelAddressChange)];
        
        _commitEditButton = [[UIBarButtonItem alloc] initWithTitle:@"Refine"
                                                             style:UIBarButtonItemStylePlain
                                                            target:self
                                                            action:@selector(commitAddressChange)];
        
        self.title = @"Location Details";
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    NSAssert(NO, @"Initialize with -initWithModel:");
    return nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // add a border to the textview
    _addressTextView.layer.borderWidth = 1.0f;
    _addressTextView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    _addressTextView.layer.cornerRadius = 8.0f;
    
    MapMarker * currentLocation = [_model objectAtIndex:_currentIndex];
    [self setupUIFields:currentLocation];
    
    [_addressTextView setDelegate:_textViewHandler];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.screenName = @"LocationDetailsViewController";
    
    [_keyboardHandler registerForKeyboardNotifications];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [_keyboardHandler deregisterForKeyboardNotifications];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Class methods

- (void) setupUIFields:(MapMarker *)marker
{
    [_nameInput setText:marker.name];
    
    CLLocation * location = [marker location];
    
    NSString * latString = [[NSNumber numberWithDouble:location.coordinate.latitude] stringValue];
    NSString * lonString = [[NSNumber numberWithDouble:location.coordinate.longitude] stringValue];
    
    [_latitudeLabel setText: latString];
    [_longitudeLabel setText: lonString];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"hh:mm a dd-MM-yyyy"];
    NSString * timestampString = [formatter stringFromDate:location.timestamp];
    
    [_timeStampLabel setText: timestampString];
    
    _addressTextView.text = [marker address];
}

- (void) updateAddressEditButtons:(BOOL) setVisible
{
    if(setVisible)
    {
        [[self navigationItem] setLeftBarButtonItem:_cancelEditButton animated:YES];
        [[self navigationItem] setRightBarButtonItem:_commitEditButton animated:YES];
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
    [_addressTextView resignFirstResponder];
    
    // refresh the data back to original
    [self setupUIFields:[_model objectAtIndex:_currentIndex]];
}

- (void) commitAddressChange
{
    [_addressTextView resignFirstResponder];
    
    [[GeocodeProvider sharedInstance] geocodeAddress:_addressTextView.text
                                         onComplete:^(CLPlacemark *placemark) {
                                             
                                             MapMarker * curMarker = [_model objectAtIndex:_currentIndex];
                                             [curMarker setPlacemark:placemark];
                                             
                                             // refresh the ui info
                                             [self setupUIFields:curMarker];
                                         }];    
}

#pragma mark - IBActions

- (IBAction)nameValueChanged:(id)sender
{
    MapMarker * currentLocation = [_model objectAtIndex:_currentIndex];
    [currentLocation setName: [_nameInput text]];
}


@end
