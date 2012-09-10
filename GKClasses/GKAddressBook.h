//
//  ABAddressBook.h
//  GKContactExchange
//
//  Created by Georg Kitz on 6/25/12.
//  Copyright (c) 2012 Georg Kitz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>

@class GKContact;

@interface GKAddressBook : NSObject
@property (nonatomic, readonly) ABAddressBookRef addressBookRef;
@property (nonatomic, readonly) NSArray *allContacts;
@property (nonatomic, readonly) NSArray *allContactsSorted;
@property (nonatomic, readonly) NSArray *allGroups;

- (id)initWithAddressBookRef:(ABAddressBookRef)addressBookRef;
- (NSArray *)filterForContactWithName:(NSString *)filterName;

@end
