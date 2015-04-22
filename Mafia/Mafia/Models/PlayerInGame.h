//
//  PlayerInGame.h
//  Mafia
//
//  Created by AlexFill on 20.04.15.
//  Copyright (c) 2015 bionic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Game, Player;

@interface PlayerInGame : NSManagedObject

@property (nonatomic, retain) NSNumber * number;
@property (nonatomic, retain) NSString * role;
@property (nonatomic, retain) NSNumber * faults;
@property (nonatomic, retain) NSNumber * score;
@property (nonatomic, retain) NSSet *game;
@property (nonatomic, retain) Player *player;
@end

@interface PlayerInGame (CoreDataGeneratedAccessors)

- (void)addGameObject:(Game *)value;
- (void)removeGameObject:(Game *)value;
- (void)addGame:(NSSet *)values;
- (void)removeGame:(NSSet *)values;

@end
