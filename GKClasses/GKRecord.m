//
//  ABRecord.m
//  GKContactExchange
//
//  Created by georgkitz on 8/30/12.
//  Copyright (c) 2012 Georg Kitz. All rights reserved.
//

#import "GKRecord.h"


@implementation GKRecord

- (ABRecordID)recordID{
    return ABRecordGetRecordID(_record);
}

#pragma mark -
#pragma Private Methods

- (NSString *)valueForAddressBookKey:(ABRecordID)key{
    
    if (!_record) {
        return nil;
    }
    
    NSString *string = (__bridge NSString *)(ABRecordCopyValue(_record, key));
    return [string length] > 0 ? string : @"";
}

#pragma mark -
#pragma Public Methods

- (id)initWithABRecordRef:(ABRecordRef)record{
    
    if (!record) {
        return nil;
    }
    
    if (self = [super init]) {
        _record = CFRetain(record);
    }
    return self;
}

- (void)dealloc{
    if (_record) {
        CFRelease(_record);
    }
}

- (BOOL)isEqual:(id)object{
    if ([self class] != [object class]) {
        return NO;
    }
    
    GKRecord *record = (GKRecord *)object;
    
    ABRecordID id1 = self.recordID;
    ABRecordID id2 = record.recordID;
    
    return id1 == id2;
}


@end
