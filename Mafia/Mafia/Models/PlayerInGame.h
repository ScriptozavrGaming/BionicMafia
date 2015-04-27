//
//  PlayerInGame.h
//  Mafia
//
//  Created by AlexFill on 27.04.15.
//  Copyright (c) 2015 bionic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Game, Player;

@interface PlayerInGame : NSManagedObject

@property (nonatomic, retain) NSNumber * faults;
@property (nonatomic, retain) NSNumber * isAlive;
@property (nonatomic, retain) NSNumber * number;
@property (nonatomic, retain) NSString * role;
@property (nonatomic, retain) NSNumber * score;
@property (nonatomic, retain) NSNumber * onVote;
@property (nonatomic, retain) Game *game;
@property (nonatomic, retain) Player *player;

@end
