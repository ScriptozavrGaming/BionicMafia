//
//  Game+Extension.m
//  Mafia
//
//  Created by Bionic University on 4/25/15.
//  Copyright (c) 2015 bionic. All rights reserved.
//

#import "Game+Extension.h"

@implementation Game (Extension)

+(Game*) currentGame:(NSManagedObjectContext *)context {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Game"];
    request.sortDescriptors = @[[[NSSortDescriptor alloc] initWithKey:@"number" ascending:YES]];
    NSError *error = nil;
    NSArray* games = [context executeFetchRequest:request error:&error];
    Game *game;
    if (games.count < 1){
        game = [NSEntityDescription insertNewObjectForEntityForName:@"Game" inManagedObjectContext:context];
        game.number = @1;

    }else {
        game = games.lastObject;
        game.number = @(games.count);
    }
    
    game.name = [NSString stringWithFormat:@"Game %@" ,game.number];

//    [context save:nil];
    return game;
}

@end
