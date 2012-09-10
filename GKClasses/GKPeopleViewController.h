//
//  GKPeopleViewController.h
//  GKContactExchange
//
//  Created by georgkitz on 8/29/12.
//  Copyright (c) 2012 Georg Kitz. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GKAddressBook;
@class GKContact;
@class GKGroup;

@interface GKPeopleViewController : UITableViewController
@property (nonatomic) GKContact *preselectedContact;
@property (nonatomic) NSString *prefilledSearchTerm;

@property (nonatomic) GKAddressBook *addressBook;
@property (nonatomic) GKGroup *filterGroup;
@end
