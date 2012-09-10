//
//  GKGroupViewController.m
//  GKContactExchange
//
//  Created by georgkitz on 8/30/12.
//  Copyright (c) 2012 Georg Kitz. All rights reserved.
//

#import "GKGroupViewController.h"
#import "GKPeopleViewController.h"
#import "GKPeoplePickerNavigationController.h"

#import "GKAddressBook.h"
#import "GKGroup.h"

@interface GKGroupViewController (){
    NSMutableArray *_data;
}

@end

@implementation GKGroupViewController

# pragma mark -
# pragma mark Private

- (void)setupNavigationBar
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(actionCancel:)];
}

- (void)internalLoadContent
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        _data = [[NSMutableArray alloc] initWithArray:[_addressBook allGroups]];
        
        //first entry is "All Contacts"
        [_data insertObject:@"" atIndex:0];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    });
}

# pragma mark -
# pragma mark Action Methods

- (void)actionCancel:(id)sender
{
    GKPeoplePickerNavigationController *nCtr = (GKPeoplePickerNavigationController *)self.parentViewController;
    if ([nCtr.peoplePickerDelegate respondsToSelector:@selector(peoplePickerNavigationControllerDidCancel:)]) {
        [nCtr.peoplePickerDelegate peoplePickerNavigationControllerDidCancel:nCtr];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

# pragma mark -
# pragma mark ViewController Methods

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self internalLoadContent];
    
    self.title = NSLocalizedString(@"GKGroups", @"");
    [self setupNavigationBar];
}

# pragma mark -
# pragma mark TableView Datasourec & Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    if (indexPath.row == 0) {
        cell.textLabel.text = NSLocalizedString(@"GKAllContacts", @"");
    }else {
        GKGroup *group = [_data objectAtIndex:indexPath.row];
        cell.textLabel.text = [group name];
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GKPeopleViewController *ctr = [[GKPeopleViewController alloc] init];
    ctr.addressBook = _addressBook;
    ctr.filterGroup = indexPath.row == 0 ? nil : [_data objectAtIndex:indexPath.row];
    
    [self.navigationController pushViewController:ctr animated:YES];
}

@end
