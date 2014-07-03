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

#pragma mark - IBOutlet properties
@property (weak, nonatomic) IBOutlet UITextField *nameInput;
@property (weak, nonatomic) IBOutlet UILabel *latitudeLabel;
@property (weak, nonatomic) IBOutlet UILabel *longitudeLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeStampLabel;
@property (weak, nonatomic) IBOutlet UITextView *addressTextView;

#pragma mark - private properties
@property (nonatomic, strong) UIBarButtonItem * cancelEditButton;
@property (nonatomic, strong) UIBarButtonItem * commitEditButton;

#pragma mark - private methods
- (void) registerForKeyboardNotifications;
- (void) deregisterForKeyboardNotifications;
- (void) keyboardWillShow:(NSNotification *) notify;
- (void) keyboardWillBeHidden:(NSNotification *) notify;

@end

@implementation LocationDetailsViewController

#pragma mark - Init and Lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // add a border to the textview
    _addressTextView.layer.borderWidth = 1.0f;
    _addressTextView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    _addressTextView.layer.cornerRadius = 8.0f;
    
    MapMarker * currentLocation = [_locations objectAtIndex:_currentIndex];
    [self setupUIFields:currentLocation];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.screenName = @"LocationDetailsViewController";
    
    [self registerForKeyboardNotifications];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self deregisterForKeyboardNotifications];
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
    [self setupUIFields:[_locations objectAtIndex:_currentIndex]];
}

- (void) commitAddressChange
{
    [_addressTextView resignFirstResponder];
    
    CLGeocoder * geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:_addressTextView.text
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
                         
                         MapMarker * curMarker = [_locations objectAtIndex:_currentIndex];
                         [curMarker setPlacemark:placemark];
                         
                         // refresh the ui info
                         [self setupUIFields:curMarker];
                     }
                     
                 }];
}

#pragma mark - Keyboard management stuff

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
    if( [_addressTextView isFirstResponder] )
    {
        NSDictionary* info = [notify userInfo];
        CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        CGRect addrFrame = _addressTextView.frame;
    
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
                             
                                 CGRect curFrame = [[self view] frame];
                                 CGRect adjustedFrame = CGRectMake(curFrame.origin.x,
                                                                   curFrame.origin.y - overlap,
                                                                   curFrame.size.width,
                                                                   curFrame.size.height);
                             
                                 [[self view] setFrame:adjustedFrame];
                             
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
                         
                         CGRect curFrame = [[self view] frame];
                         CGRect originalFrame = CGRectMake(0.0f, 0.0f, curFrame.size.width, curFrame.size.height);
                         
                         [[self view] setFrame: originalFrame];
                         
                     }
                     completion:nil];
    
}

#pragma mark - IBActions

- (IBAction)nameValueChanged:(id)sender
{
    MapMarker * currentLocation = [_locations objectAtIndex:_currentIndex];
    [currentLocation setName: [_nameInput text]];
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
