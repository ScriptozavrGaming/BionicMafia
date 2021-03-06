//
//  Game.h
//  Mafia
//
//  Created by AlexFill on 27.04.15.
//  Copyright (c) 2015 bionic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class PlayerInGame;

@interface Game : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * number;
@property (nonatomic, retain) NSNumber * round;
@property (nonatomic, retain) NSString * winner;
@property (nonatomic, retain) NSSet *players;
@end

@interface Game (CoreDataGeneratedAccessors)

- (void)addPlayersObject:(PlayerInGame *)value;
- (void)removePlayersObject:(PlayerInGame *)value;
- (void)addPlayers:(NSSet *)values;
- (void)removePlayers:(NSSet *)values;

@end
