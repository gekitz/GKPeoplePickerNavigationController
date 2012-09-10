//
//  ABGroup.m
//  GKContactExchange
//
//  Created by georgkitz on 8/30/12.
//  Copyright (c) 2012 Georg Kitz. All rights reserved.
//

#import "GKGroup.h"
#import "GKContact.h"

@interface GKGroup (){
    NSArray *_members;
    NSArray *_membersSorted;
}

@end

@implementation GKGroup

- (NSString *)name{
    return [self valueForAddressBookKey:kABGroupNameProperty];
}

- (NSArray *)members{
    if (_members){
        return _members;
    }
    
    NSArray *allMembers = (__bridge NSArray *)(ABGroupCopyArrayOfAllMembers(_record));
    NSMutableArray *values = [NSMutableArray arrayWithCapacity:[allMembers count]];

    for (id record in allMembers) {
        ABRecordRef item = (__bridge ABRecordRef)(record);
        GKContact *contact = [[GKContact alloc] initWithABRecordRef:item];
        [values addObject:contact];
    }

    _members = [NSMutableArray arrayWithArray:values];
    return _members;
}

- (NSArray *)allMembersSorted{
    if (_membersSorted){
        return _membersSorted;
    }
    
    NSArray *allMembers = (__bridge NSArray *)(ABGroupCopyArrayOfAllMembersWithSortOrdering(_record, kABPersonSortByFirstName));
    NSMutableArray *values = [NSMutableArray arrayWithCapacity:[allMembers count]];
    
    for (id record in allMembers) {
        ABRecordRef item = (__bridge ABRecordRef)(record);
        GKContact *contact = [[GKContact alloc] initWithABRecordRef:item];
        [values addObject:contact];
    }
    
    _membersSorted = [NSMutableArray arrayWithArray:values];
    return _membersSorted;
}

@end

