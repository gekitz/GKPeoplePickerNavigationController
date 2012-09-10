//
//  ABContact.m
//  GKContactExchange
//
//  Created by Georg Kitz on 6/25/12.
//  Copyright (c) 2012 Georg Kitz. All rights reserved.
//

#import "GKContact.h"

@interface GKContact()
@end

@implementation GKContact{
    UIImage *_image;
}

#pragma mark -
#pragma Properties

- (NSString *)firstname{
    return [self valueForAddressBookKey:kABPersonFirstNameProperty];
}

- (NSString *)middlename{
    return [self valueForAddressBookKey:kABPersonMiddleNameProperty];
}

- (NSString *)lastname{
    return [self valueForAddressBookKey:kABPersonLastNameProperty];
}

- (NSString *)nickname{
    return [self valueForAddressBookKey:kABPersonNicknameProperty];
}

- (NSString *)name{
    if ([self.firstname length] == 0 && [self.lastname length] == 0) {
        return self.companyName;
    }
    return [NSString stringWithFormat:@"%@ %@", self.firstname, self.lastname];
}

- (NSString *)companyName{
    return [self valueForAddressBookKey:kABPersonOrganizationProperty];
}

- (UIImage *)image{
    
    if (_image) {
        return _image;
    }
    
    if (!ABPersonHasImageData(_record)){
        return nil;
    }
    
	CFDataRef imageData = ABPersonCopyImageData(_record);
	_image = [UIImage imageWithData:(__bridge NSData *) imageData];
	CFRelease(imageData);
	return _image;
}

- (NSData *)vCard{
    NSArray *array = [NSArray arrayWithObject:(__bridge NSObject *)(_record)];
    return (__bridge NSData *)(ABPersonCreateVCardRepresentationWithPeople((__bridge CFArrayRef)(array)));
}

- (NSString *)twitter{
    ABMultiValueRef multiValue = ABRecordCopyValue(_record, kABPersonSocialProfileProperty);
    
    if (multiValue == nil) {
        return nil;
    }
    
    for (CFIndex i = 0; i < ABMultiValueGetCount(multiValue); i++)
    {
        NSDictionary* personalDetails = [NSDictionary dictionaryWithDictionary:(__bridge NSDictionary*)ABMultiValueCopyValueAtIndex(multiValue, i)];
        if ([personalDetails[@"service"] isEqualToString: (__bridge NSString *)kABPersonSocialProfileServiceTwitter]) {
            return personalDetails[@"username"];
        }
    }
    
    return nil;
}

- (NSString *)phoneNumber
{
    ABMultiValueRef multiValue = ABRecordCopyValue(_record, kABPersonPhoneProperty);
    
    if (multiValue == nil || ABMultiValueGetCount(multiValue) == 0) {
        return nil;
    }
    
    return (__bridge NSString*)ABMultiValueCopyValueAtIndex(multiValue, 0);
}

- (NSString *)email
{
    ABMultiValueRef multiValue = ABRecordCopyValue(_record, kABPersonEmailProperty);
    
    if (multiValue == nil || ABMultiValueGetCount(multiValue) == 0) {
        return nil;
    }
    
    return (__bridge NSString*)ABMultiValueCopyValueAtIndex(multiValue, 0);
}

@end
