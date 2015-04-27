//
//  PlayerInfoViewController.h
//  Mafia
//
//  Created by AlexFill on 27.04.15.
//  Copyright (c) 2015 bionic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Player+Extension.h"

@interface PlayerInfoViewController : UIViewController

@property (nonatomic,strong) Player *player;
@property (nonatomic) NSManagedObjectContext *mainContext;

@end
