//
//  GKViewController.m
//  GKPeoplePickerViewController
//
//  Created by Georg Kitz on 9/10/12.
//  Copyright (c) 2012 Georg Kitz. All rights reserved.
//

#import "GKViewController.h"
#import "GKPeoplePickerNavigationController.h"

#import "GKAddressBook.h"
#import "GKContact.h"

#import <AddressBookUI/AddressBookUI.h>

@interface GKViewController ()

@end

@implementation GKViewController

#pragma mark -
#pragma mark Pulblic

- (IBAction)showCustomPicker:(id)sender
{
    
    [GKPeoplePickerNavigationController requestAccessToAddressBookWithCompletion:^(bool granted, CFErrorRef error) {
        if (granted) {
            
            GKPeoplePickerNavigationController *ctr = [[GKPeoplePickerNavigationController alloc] init];
            ctr.prefilledSearchTerm = @"Georg";
            [self presentViewController:ctr animated:YES completion:nil];

        }
    }];
}

- (IBAction)showCustomPickerPreSelectPerson:(id)sender
{
    [GKPeoplePickerNavigationController requestAccessToAddressBookWithCompletion:^(bool granted, CFErrorRef error) {
        if (granted) {
            
            GKAddressBook *addressBook = [GKAddressBook new];
            NSArray *array = [addressBook filterForContactWithName:@"Georg"];
            
            GKPeoplePickerNavigationController *ctr = [[GKPeoplePickerNavigationController alloc] init];
            
            if ([array count] > 0) {
                GKContact *contact = [array objectAtIndex:0];
                ctr.preselectedPerson = contact.record;
            }
            [self presentViewController:ctr animated:YES completion:nil];
            
        }
    }];
}

- (IBAction)showStandardPicker:(id)sender
{
    ABPeoplePickerNavigationController *ctr = [[ABPeoplePickerNavigationController alloc] init];
    [self presentViewController:ctr animated:YES completion:nil];
}

#pragma mark -
#pragma mark ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
