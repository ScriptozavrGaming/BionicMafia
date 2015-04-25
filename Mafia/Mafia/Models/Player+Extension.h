//
//  Player+Extension.h
//  Mafia
//
//  Created by Bionic University on 4/25/15.
//  Copyright (c) 2015 bionic. All rights reserved.
//

#import "Player.h"

@interface Player (Extension)

+(Player*) playerForNickName:(NSString*)aNickname inContext:(NSManagedObjectContext*)aContext;

@end
