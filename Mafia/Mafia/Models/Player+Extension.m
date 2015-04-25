//
//  Player+Extension.m
//  Mafia
//
//  Created by Bionic University on 4/25/15.
//  Copyright (c) 2015 bionic. All rights reserved.
//

#import "Player+Extension.h"

@implementation Player (Extension)

+ (Player*)playerForNickName:(NSString*)aNickname inContext:(NSManagedObjectContext*)aContext{

    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Player"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"nickname == %@", aNickname];
    request.sortDescriptors = @[[[NSSortDescriptor alloc] initWithKey:@"nickname" ascending:YES]];
    [request setPredicate:predicate];
    NSError *error = nil;
    NSArray *fetchRequestResults = [aContext executeFetchRequest:request error:&error];
    
    if (fetchRequestResults.count > 0){
        return fetchRequestResults[0];
    }
    
    return nil;
}

@end
