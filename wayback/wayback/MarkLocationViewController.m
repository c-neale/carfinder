//
//  MarkLocationViewController.m
//  wayback
//
//  Created by Cory Neale on 29/05/2014.
//  Copyright (c) 2014 Cory Neale. All rights reserved.
//

#import "MarkLocationViewController.h"
#import "MarkLocationViewController+UIAlertViewDelegate.h"
#import "MarkLocationViewController+UITableViewDataSource.h"
#import "MarkLocationViewController+UITableViewDelegate.h"

#import "MapLocationViewController.h"
#import "LocationDetailsViewController.h"

#import "MapMarker.h"

#import "DataModel.h"
#import "LocationProvider.h"

@interface MarkLocationViewController ()

#pragma mark - IBOutlet properties
@property (weak, nonatomic) IBOutlet UITableView *locationTableView;
@property (weak, nonatomic) IBOutlet UIButton *markButton;
@property (weak, nonatomic) IBOutlet UIButton *showButton;
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;

#pragma mark - private properties

@property (nonatomic, strong) UIBarButtonItem * editButton;
@property (nonatomic, strong) UIBarButtonItem * clearButton;

#pragma mark - private methods

- (void) editButtonPressed;
- (void) setVersionLabel;

@end

#pragma mark -

@implementation MarkLocationViewController

#pragma mark - Init/Lifecycle

- (id) init
{
    self = [super initWithNibName:nil bundle:nil];
    
    if (self)
    {
        _editButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit"
                                                       style:UIBarButtonItemStylePlain
                                                      target:self
                                                      action:@selector(editButtonPressed)];
        
        _clearButton = [[UIBarButtonItem alloc] initWithTitle:@"Clear"
                                                        style:UIBarButtonItemStylePlain
                                                       target:self
                                                       action:@selector(displayClearConfirmAlert)];
        
        self.title = @"The Way Back";
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
    // Do any additional setup after loading the view from its nib.
    
    // set the delegate and datasource pointers for the tableview.
    [_locationTableView setDataSource:self];
    [_locationTableView setDelegate:self];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setVersionLabel];
    
    self.screenName = @"MarkLocationViewController";
 
    [[LocationProvider sharedInstance] start];
    [_locationTableView reloadData];
    
    [self updateNavbarButtonVisiblity];
    
    [_showButton setEnabled: [[DataModel sharedInstance] locations].count > 0];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[LocationProvider sharedInstance] stop];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Class methods

- (void)setEditMode:(BOOL)active
{
    if( active )
    {
        [_editButton setTitle:@"Stop Editting"];
    }
    else
    {
        [_editButton setTitle:@"Edit"];
    }
    
    [_markButton setEnabled:!active];
    [_showButton setEnabled:!active];
    
    [_locationTableView setEditing:active animated:YES];
}

- (void)editButtonPressed
{
    [self setEditMode:![_locationTableView isEditing]];
}

- (void) updateNavbarButtonVisiblity
{
    if([[[DataModel sharedInstance] locations] count] > 0)
    {
        [[self navigationItem] setLeftBarButtonItem:_clearButton animated:YES];
        [[self navigationItem] setRightBarButtonItem:_editButton animated:YES];
    }
    else
    {
        [[self navigationItem] setLeftBarButtonItem:nil animated:YES];
        [[self navigationItem] setRightBarButtonItem:nil animated:YES];
    }
}

- (void) clearButtonAction
{
    [[DataModel sharedInstance] clearAllLocations];
    
    [_locationTableView reloadData];
    [self setEditMode:NO];
    [self updateNavbarButtonVisiblity];
}

- (void) setVersionLabel
{
    NSDictionary * infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString * version = [infoDict objectForKey:@"CFBundleShortVersionString"];
    
    _versionLabel.text = [NSString stringWithFormat:@"v%@", version];
}

#pragma mark - IBActions

- (IBAction)FindButtonPressed:(id)sender
{
    MapLocationViewController * mlvc = [[MapLocationViewController alloc] initWithLocation:[[LocationProvider sharedInstance] currentLocation]];
    [self.navigationController pushViewController:mlvc animated:YES];
}

- (IBAction)markLocationButtonPressed:(id)sender
{
    CLLocation * currentLocation = [[LocationProvider sharedInstance] currentLocation];
    
    if(currentLocation != nil)
    {
        [[DataModel sharedInstance] addLocation:currentLocation postInit:^{
            [_locationTableView reloadData];
            [self updateNavbarButtonVisiblity];
        }];
        
        [_locationTableView reloadData];
        [self updateNavbarButtonVisiblity];
        
        [_showButton setEnabled: [[DataModel sharedInstance] locations].count > 0];
    }
    else
    {
        [LogHelper logAndTrackErrorMessage:@"Location services is off" fromClass:self fromFunction:_cmd];
        
        [self displayLocationServicesAlert];
    }
}

@end
