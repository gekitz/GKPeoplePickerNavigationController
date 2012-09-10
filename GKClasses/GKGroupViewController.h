//
//  GKGroupViewController.h
//  GKContactExchange
//
//  Created by georgkitz on 8/30/12.
//  Copyright (c) 2012 Georg Kitz. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GKAddressBook;

@interface GKGroupViewController : UITableViewController
@property (nonatomic) GKAddressBook *addressBook;
@end
