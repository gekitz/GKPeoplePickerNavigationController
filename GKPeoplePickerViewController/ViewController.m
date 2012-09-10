//
//  ViewController.m
//  GKPeoplePickerViewController
//
//  Created by Georg Kitz on 9/10/12.
//  Copyright (c) 2012 Georg Kitz. All rights reserved.
//

#import "ViewController.h"

#import "GKPeoplePickerNavigationController.h"
#import "GKAddressBook.h"
#import "GKContact.h"

@interface ViewController ()

@end

@implementation ViewController

#pragma mark -
#pragma mark Public

- (IBAction)showPeoplePickerPreselectContact:(id)sender
{
    [GKPeoplePickerNavigationController requestAccessToAddressBookWithCompletion:^(bool granted, CFErrorRef error) {
        if (granted) {
            
            GKAddressBook *addressBook = [[GKAddressBook alloc] init];
            NSArray *contacts = [addressBook filterForContactWithName:@"Georg K"];
            
            GKPeoplePickerNavigationController *ctr = [[GKPeoplePickerNavigationController alloc] init];
            
            if ([contacts count] > 0) {
                GKContact *contact = [contacts objectAtIndex:0];
                ctr.preselectedPerson = contact.record;
            }
            
            [self presentViewController:ctr animated:YES completion:nil];
        }
    }];
}

- (IBAction)showPeoplePickerPreFilledSearch:(id)sender
{
    [GKPeoplePickerNavigationController requestAccessToAddressBookWithCompletion:^(bool granted, CFErrorRef error) {
        if (granted) {
            
            GKPeoplePickerNavigationController *ctr = [[GKPeoplePickerNavigationController alloc] init];
            ctr.prefilledSearchTerm = @"Georg";
            [self presentViewController:ctr animated:YES completion:nil];
            
        }
    }];
}

- (IBAction)showStandardPicker:(id)sender
{
    [GKPeoplePickerNavigationController requestAccessToAddressBookWithCompletion:^(bool granted, CFErrorRef error) {
        if (granted) {
            
            GKPeoplePickerNavigationController *ctr = [[GKPeoplePickerNavigationController alloc] init];
            [self presentViewController:ctr animated:YES completion:nil];
            
        }
    }];
}

#pragma mark -
#pragma mark ViewController

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

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
