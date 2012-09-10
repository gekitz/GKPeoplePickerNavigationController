//
//  ABRecord.h
//  GKContactExchange
//
//  Created by georgkitz on 8/30/12.
//  Copyright (c) 2012 Georg Kitz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>

#if __IPHONE_OS_VERSION_MAX_ALLOWED < 60000
@interface NSObject (PSPDFSubscriptingSupport)

- (id)objectAtIndexedSubscript:(NSUInteger)idx;
- (void)setObject:(id)obj atIndexedSubscript:(NSUInteger)idx;
- (void)setObject:(id)obj forKeyedSubscript:(id <NSCopying>)key;
- (id)objectForKeyedSubscript:(id)key;

@end
#endif

@interface GKRecord : NSObject{
    ABRecordRef _record;
}

@property (readonly) ABRecordRef record;
@property (readonly) ABRecordID recordID;

- (id)initWithABRecordRef:(ABRecordRef)recordRef;
- (NSString *)valueForAddressBookKey:(ABRecordID)key;
@end
