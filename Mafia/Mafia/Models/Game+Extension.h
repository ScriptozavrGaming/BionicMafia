//
//  Game+Extension.h
//  Mafia
//
//  Created by Bionic University on 4/25/15.
//  Copyright (c) 2015 bionic. All rights reserved.
//

#import "Game.h"

@interface Game (Extension)


+ (Game *) currentGame: (NSManagedObjectContext*)context;

@end
