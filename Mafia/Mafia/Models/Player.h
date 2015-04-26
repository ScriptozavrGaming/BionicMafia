//
//  Player.h
//  Mafia
//
//  Created by AlexFill on 25.04.15.
//  Copyright (c) 2015 bionic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class PlayerInGame;

@interface Player : NSManagedObject

@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSString * nickname;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSNumber * rating;
@property (nonatomic, retain) NSSet *gameinfoplayer;
@end

@interface Player (CoreDataGeneratedAccessors)

- (void)addGameinfoplayerObject:(PlayerInGame *)value;
- (void)removeGameinfoplayerObject:(PlayerInGame *)value;
- (void)addGameinfoplayer:(NSSet *)values;
- (void)removeGameinfoplayer:(NSSet *)values;

@end
