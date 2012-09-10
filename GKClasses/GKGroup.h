//
//  ABGroup.h
//  GKContactExchange
//
//  Created by georgkitz on 8/30/12.
//  Copyright (c) 2012 Georg Kitz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GKRecord.h"

@interface GKGroup : GKRecord
@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSArray *allMembers;
@property (nonatomic, readonly) NSArray *allMembersSorted;
@end
