//
//  LeftMenuViewController.m
//  wayback
//
//  Created by Cory Neale on 22/06/2014.
//  Copyright (c) 2014 Cory Neale. All rights reserved.
//

#import "LeftMenuViewController.h"

@interface LeftMenuViewController ()

@end

@implementation LeftMenuViewController

#pragma mark - Init and lifecycle

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return 4;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LeftMenuCell"];
    
    [cell setBackgroundColor:[UIColor clearColor]];
    
    switch (indexPath.row)
    {
        case 0:
            cell.textLabel.text = @"cell 1";
            break;
        case 1:
            cell.textLabel.text = @"cell 2";
            break;
        case 2:
            cell.textLabel.text = @"cell 3";
            break;
        case 3:
            cell.textLabel.text = @"cell 4";
            break;
            
        default:
            break;
    }
    
    return cell;
}

@end
