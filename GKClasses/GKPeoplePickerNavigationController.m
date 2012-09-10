//
//  GKPeoplePickerNavigationController.m
//  GKContactExchange
//
//  Created by georgkitz on 8/29/12.
//  Copyright (c) 2012 Georg Kitz. All rights reserved.
//

#import "GKPeoplePickerNavigationController.h"
#import "GKPeopleViewController.h"
#import "GKGroupViewController.h"

#import "GKAddressBook.h"
#import "GKContact.h"

@interface GKPeoplePickerNavigationController (){
    
    GKPeopleViewController *_peopleCtr;
    GKGroupViewController *_groupCtr;
    
    GKAddressBook *_addressBook;
    GKContact *_preselectedPerson;
}
@end

@implementation GKPeoplePickerNavigationController

#pragma mark -
#pragma mark Class Methods

+ (void)requestAccessToAddressBookWithCompletion:(GKAddressBookRequestAccessCompletionHandler)completion
{
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED < 60000
    
    if (completion) {
        completion(true, NULL);
    }
    
#else
    GKAddressBook *addressBook = [[GKAddressBook alloc] init];
    ABAddressBookRequestAccessWithCompletion(addressBook.addressBookRef, ^(bool granted, CFErrorRef error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (completion) {
                completion(granted, error);
            }
        });
    });

#endif
}

# pragma mark -
# pragma mark Properties

- (void)setPreselectedPerson:(ABRecordRef)preselectedPerson
{
    _preselectedPerson = [[GKContact alloc] initWithABRecordRef:preselectedPerson];
    _peopleCtr.preselectedContact = _preselectedPerson;
}

- (ABRecordRef)preselectedPerson
{
    return _preselectedPerson.record;
}

- (void)setPrefilledSearchTerm:(NSString *)prefilledSearchTerm
{
    _peopleCtr.prefilledSearchTerm = prefilledSearchTerm;
}

- (NSString *)prefilledSearchTerm
{
    return _peopleCtr.prefilledSearchTerm;
}

- (void)setAddressBookRef:(ABAddressBookRef)addressBookRef
{
    _addressBook = [[GKAddressBook alloc] initWithAddressBookRef:addressBookRef];
    _peopleCtr.addressBook = _addressBook;
    _groupCtr.addressBook = _addressBook;
}

- (ABAddressBookRef)addressBookRef
{
    return _addressBook.addressBookRef;
}

# pragma mark -
# pragma mark Private 

- (void)setupNavigationBar
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(actionCancel:)];
}

# pragma mark -
# pragma mark Action

- (void)actionCancel:(id)sender
{
    if ([_peoplePickerDelegate respondsToSelector:@selector(peoplePickerNavigationControllerDidCancel:)]) {
        [_peoplePickerDelegate peoplePickerNavigationControllerDidCancel:self];
    }
}

# pragma mark -
# pragma mark ViewController

- (id)init
{
    self = [super init];
    if (self) {
        
        _groupCtr = [[GKGroupViewController alloc] init];;
        _peopleCtr = [[GKPeopleViewController alloc] init];
        
        _addressBook = [[GKAddressBook alloc] init];
        _peopleCtr.addressBook = _addressBook;
        _groupCtr.addressBook = _addressBook;
        
        [self pushViewController:_groupCtr animated:NO];
        [self pushViewController:_peopleCtr animated:NO];
    }
    return self;
}

- (void)viewDidLoad
{    
    [super viewDidLoad];
    [self setupNavigationBar];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
