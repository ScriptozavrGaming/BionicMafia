//
//  AddOrChoosePlayerViewController.h
//  Mafia
//
//  Created by AlexFill on 19.04.15.
//  Copyright (c) 2015 bionic. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AddOrChoosePlayerViewController : UIViewController

@property (nonatomic, strong) NSArray *viewControllers;
@property (nonatomic, strong) IBOutlet UITabBar *tabBar;
@property (nonatomic, strong) IBOutlet UITabBarItem *addTabBarItem;
@property (nonatomic, strong) IBOutlet UITabBarItem *existTabBarItem;
@property (nonatomic, strong) UIViewController *selectedViewController;

@end
