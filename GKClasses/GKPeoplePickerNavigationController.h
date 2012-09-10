//
//  GKPeoplePickerNavigationController.h
//  GKContactExchange
//
//  Created by georgkitz on 8/29/12.
//  Copyright (c) 2012 Georg Kitz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>

@protocol GKPeoplePickerNavigationControllerDelegate;

@interface GKPeoplePickerNavigationController : UINavigationController
@property (nonatomic) ABAddressBookRef addressBookRef;
@property (nonatomic) ABRecordRef preselectedPerson;
@property (nonatomic) NSString *prefilledSearchTerm;
@property (nonatomic, unsafe_unretained) id<GKPeoplePickerNavigationControllerDelegate> peoplePickerDelegate;

+ (ABAuthorizationStatus)addressBookAuthorizationStatus;
+ (void)requestAccessToAddressBookWithCompletion:(ABAddressBookRequestAccessCompletionHandler)completion;

@end

@protocol GKPeoplePickerNavigationControllerDelegate <NSObject>

// Called after the user has pressed cancel
// The delegate is responsible for dismissing the peoplePicker
- (void)peoplePickerNavigationControllerDidCancel:(GKPeoplePickerNavigationController *)peoplePicker;

// Called after a person has been selected by the user.
// Return YES if you want the person to be displayed.
// Return NO  to do nothing (the delegate is responsible for dismissing the peoplePicker).
- (BOOL)peoplePickerNavigationController:(GKPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person;

@end
