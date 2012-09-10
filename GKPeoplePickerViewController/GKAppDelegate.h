//
//  GKAppDelegate.h
//  GKPeoplePickerViewController
//
//  Created by Georg Kitz on 9/10/12.
//  Copyright (c) 2012 Georg Kitz. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GKViewController;

@interface GKAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) GKViewController *viewController;

@end
