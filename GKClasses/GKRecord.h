//
//  ABRecord.h
//  GKContactExchange
//
//  Created by georgkitz on 8/30/12.
//  Copyright (c) 2012 Georg Kitz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>

@interface GKRecord : NSObject{
    ABRecordRef _record;
}

@property (readonly) ABRecordRef record;
@property (readonly) ABRecordID recordID;

- (id)initWithABRecordRef:(ABRecordRef)recordRef;
- (NSString *)valueForAddressBookKey:(ABRecordID)key;
@end
