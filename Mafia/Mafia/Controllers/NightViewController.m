//
//  NightViewController.m
//  Mafia
//
//  Created by AlexFill on 26.04.15.
//  Copyright (c) 2015 bionic. All rights reserved.
//

#import "NightViewController.h"
#import "MorningViewController.h"
#import "Game+Extension.h"
#import "PlayerInGame.h"
#import "Player.h"

@interface NightViewController () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (strong, nonatomic) NSArray *players;
@property (strong, nonatomic) NSMutableArray *alivePlayers;
@property (nonatomic) NSInteger indexOfKilledPlayer;

@end

@implementation NightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Night";
    [self.navigationItem setHidesBackButton:YES];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(selectKilledPlayer:)];
    // Do any additional setup after loading the view from its nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSArray *) players
{
    if (nil == _players)
    {
        Game *currentGame = [Game currentGame:self.mainContext];
        _players = [[[currentGame players] allObjects] sortedArrayUsingComparator:^NSComparisonResult(PlayerInGame *obj1, PlayerInGame* obj2) {
            return [obj1.number integerValue] > [obj2.number integerValue];
        }];
        
    }
    return _players;
}

- (NSMutableArray *)alivePlayers
{
    if (nil == _alivePlayers)
    {
        _alivePlayers = [[NSMutableArray alloc] init];
        [_alivePlayers addObject:@"Miss"];
        for (PlayerInGame *player in self.players)
        {
            if(player.isAlive != nil)
            {
                [_alivePlayers addObject:player];
            }
        }
    }
    return _alivePlayers;
}

- (IBAction)selectKilledPlayer:(id)sender
{
    if(self.indexOfKilledPlayer != 0)
    {
        ((PlayerInGame *)self.alivePlayers[self.indexOfKilledPlayer]).isAlive = NO;
        NSError *error = nil;
        [self.mainContext save:&error];
    }
    MorningViewController *morningController = [MorningViewController new];
    morningController.mainContext = self.mainContext;
    [self.navigationController pushViewController:morningController animated:YES];
}

#pragma mark - picker view data source

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.alivePlayers.count;
}

#pragma mark - picker view delegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(row == 0)
    {
        return self.alivePlayers[row];
    }
    else
    {
        return [NSString stringWithFormat:@"%d.%@",[((PlayerInGame *)self.alivePlayers[row]).number integerValue],
            ((PlayerInGame *)self.alivePlayers[row]).player.nickname];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.indexOfKilledPlayer = row;
}

@end
