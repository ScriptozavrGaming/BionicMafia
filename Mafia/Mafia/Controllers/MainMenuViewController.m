//
//  MainMenuViewController.m
//  Mafia
//
//  Created by AlexFill on 17.04.15.
//  Copyright (c) 2015 bionic. All rights reserved.
//

#import "MainMenuViewController.h"
#import "NewGameViewController.h"
#import "SetPlayersViewController.h"
#import "AppDelegate.h"
#import "Game+Extension.h"

@interface MainMenuViewController () 

@property (nonatomic,readonly) NSManagedObjectContext *mainContext;


@end

@implementation MainMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view from its nib.
}



- (void)viewWillAppear:(BOOL)animated
{
    [[self navigationController] setNavigationBarHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)setPlayersButtonTouched:(id)sender
{
    SetPlayersViewController *setPlayersController = [SetPlayersViewController new];
    setPlayersController.mainContext = self.mainContext;
    [[self navigationController] pushViewController:setPlayersController animated:YES];
}

- (IBAction)newGameButtonTouched:(id)sender
{
    if([[[[Game currentGame:self.mainContext] players] allObjects] count]<10)
    {
        UIAlertView *allert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Set players need" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [allert show];
    }
    else
    {
        NewGameViewController *newGameController = [NewGameViewController new];
        newGameController.mainContext = self.mainContext;
        [[self navigationController] pushViewController:newGameController animated:YES];

    }
}

- (NSManagedObjectContext *)mainContext
{
    return [[[AppDelegate sharedAppDelegate] coreDataManager] managedObjectContext];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
