//
//  AppDelegate.h
//  Mafia
//
//  Created by Bionic University on 4/4/15.
//  Copyright (c) 2015 bionic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "CoreDataManager.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (readonly,nonatomic) CoreDataManager *coreDataManager;

+(AppDelegate *) sharedAppDelegate;

@end

