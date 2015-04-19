//
//  Player.h
//  Mafia
//
//  Created by AlexFill on 19.04.15.
//  Copyright (c) 2015 bionic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Game;

@interface Player : NSManagedObject

@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSString * nickname;
@property (nonatomic, retain) NSDecimalNumber * phone;
@property (nonatomic, retain) NSNumber * rating;
@property (nonatomic, retain) Game *game;

@end
