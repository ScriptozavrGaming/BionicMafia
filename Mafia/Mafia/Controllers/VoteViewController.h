//
//  VoteViewController.h
//  Mafia
//
//  Created by AlexFill on 27.04.15.
//  Copyright (c) 2015 bionic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VoteViewController : UIViewController

@property (nonatomic) NSManagedObjectContext *mainContext;
@property (nonatomic, strong) NSMutableArray *playersOnVote;
@property (nonatomic) BOOL isDuel;
@property (nonatomic) NSInteger alivePlayers;

@end
