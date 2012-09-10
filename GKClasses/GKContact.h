//
//  ABContact.h
//  GKContactExchange
//
//  Created by Georg Kitz on 6/25/12.
//  Copyright (c) 2012 Georg Kitz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GKRecord.h"

@interface GKContact : GKRecord

@property (readonly) NSString *firstname;
@property (readonly) NSString *middlename;
@property (readonly) NSString *lastname;
@property (readonly) NSString *nickname;
@property (readonly) NSString *name;
@property (readonly) UIImage *image;
@property (readonly) UIImage *imageForExchange;
@property (readonly) NSData *vCard;
@property (readonly) NSString *twitter;
@property (readonly) NSString *phoneNumber;
@property (readonly) NSString *email;
@property (readonly) NSString *companyName;

@end
