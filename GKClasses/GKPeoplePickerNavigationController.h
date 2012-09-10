//
//  GKPeoplePickerNavigationController.h
//  GKContactExchange
//
//  Created by georgkitz on 8/29/12.
//  Copyright (c) 2012 Georg Kitz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>

typedef void(^GKAddressBookRequestAccessCompletionHandler)(bool granted, CFErrorRef error);
@protocol GKPeoplePickerNavigationControllerDelegate;

@interface GKPeoplePickerNavigationController : UINavigationController
@property (nonatomic) ABAddressBookRef addressBookRef; //a specific addressbook you want to use, otherwise one is created for you
@property (nonatomic) ABRecordRef preselectedPerson; //the person which should be preselected
@property (nonatomic) NSString *prefilledSearchTerm; // the searchterm which should be set
@property (nonatomic, unsafe_unretained) id<GKPeoplePickerNavigationControllerDelegate> peoplePickerDelegate;

/**
 * @method requestAccessToAddressBookWithCompletion: requests access to the users address book (you have to do this under iOS 6.0)
 * @param completion, the completion handler for this method
 */
+ (void)requestAccessToAddressBookWithCompletion:(GKAddressBookRequestAccessCompletionHandler)completion;

@end

@protocol GKPeoplePickerNavigationControllerDelegate <NSObject>

/**
 * @method Called after the user has pressed cancel. The delegate is responsible for dismissing the peoplePicker
 * @param peoplePicker, the people picker instance
 */
- (void)peoplePickerNavigationControllerDidCancel:(GKPeoplePickerNavigationController *)peoplePicker;


/**
 * @method peoplePickerNavigationController:shouldContinueAfterSelectingPerson:, Called after a person has been selected by the user.
 * @param peoplePicker, the people picker instance
 * @param person, the person which has been picked by the user
 */
- (BOOL)peoplePickerNavigationController:(GKPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person;

@end
