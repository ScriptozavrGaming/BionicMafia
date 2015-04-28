//
//  NewGameViewController.m
//  Mafia
//
//  Created by AlexFill on 18.04.15.
//  Copyright (c) 2015 bionic. All rights reserved.
//

#import "NewGameViewController.h"
#import "SetRolesViewController.h"
#import "MafiaMeetingViewController.h"
#import "Game+Extension.h"
#import "PlayerInGame.h"
#import "Player.h"
@interface NewGameViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *playersTableView;
@property (nonatomic, strong) NSMutableArray *setRolesControllers;
@property (nonatomic) NSInteger index;
@property (nonatomic) NSArray *players;
@end

NSString *const kNameNotificationRolesChanged = @"roleChanged";

@implementation NewGameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[self navigationController] setNavigationBarHidden:NO];
    self.title = @"Setup Roles";
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(savePlayersWithRoles:)];
    [doneButton setEnabled:NO];
    self.navigationItem.rightBarButtonItem = doneButton;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recieveNotification:) name:kNameNotificationRolesChanged object:nil];
    // Do any additional setup after loading the view from its nib.
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

- (void)recieveNotification:(NSNotification *)notification
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.index inSection:0];
    [self.playersTableView cellForRowAtIndexPath:indexPath].detailTextLabel.text = ((SetRolesViewController *)[notification object]).choosedRole;
    if ([self arePlayersSetRight])
    {
        [self.navigationItem.rightBarButtonItem setEnabled:YES];
    }else
    {
        [self.navigationItem.rightBarButtonItem setEnabled:NO];
    }
}

- (BOOL) arePlayersSetRight{
    NSInteger comissarsCount = 0;
    NSInteger citizenCount = 0;
    NSInteger donsCount = 0;
    NSInteger mafiaCount = 0;
    for(NSInteger i = 0; i < 10; i++){
        NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:0];
        NSString *str = [self.playersTableView cellForRowAtIndexPath:path].detailTextLabel.text;
        
        if([str isEqualToString:@"Comissar"]) comissarsCount++;
        else if ([str isEqualToString:@"Mafia"]) mafiaCount++;
        else if ([str isEqualToString:@"Citizen"]) citizenCount++;
        else if ([str isEqualToString:@"Don"]) donsCount++;
        
    }
    
    return comissarsCount == 1 && mafiaCount == 2 && citizenCount == 6 && donsCount == 1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)savePlayersWithRoles:(id)sender
{
    for(NSInteger i = 0; i < 10; i++)
    {
        NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:0];
        NSString *str = [self.playersTableView cellForRowAtIndexPath:path].detailTextLabel.text;
        
        ((PlayerInGame*)self.players[i]).role = str;
    }
    NSError *error = nil;
    [self.mainContext save:&error];
    MafiaMeetingViewController *mafiaMeetingController = [MafiaMeetingViewController new];
    mafiaMeetingController.mainContext = self.mainContext;
    [self.navigationController pushViewController:mafiaMeetingController animated:YES];
    
}

- (NSMutableArray *)setRolesControllers
{
    if (nil == _setRolesControllers)
    {
        _setRolesControllers = [[NSMutableArray alloc] init];
        for (NSInteger index = 0; index < 10; index++)
        {
            SetRolesViewController *newController = [[SetRolesViewController alloc] initWithNibName:@"SetRolesViewController" bundle:nil];
            [_setRolesControllers addObject:newController];
        }
    }
    return _setRolesControllers;
}

#pragma mark - table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:
                             UITableViewCellStyleValue1 reuseIdentifier:@"setRoleCell"];

    //    PlayerInGame * pig =player[indexPath.row];
//    Player* p = pig.player;
    cell.textLabel.text = [NSString stringWithFormat:@"%d.  %@",indexPath.row+1,((Player*)[(PlayerInGame *)self.players[indexPath.row] player]).nickname];
    cell.detailTextLabel.text = @"None";
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return @"Choose roles";
}

#pragma mark - table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.index = indexPath.row;
    [self.navigationController pushViewController:self.setRolesControllers[indexPath.row] animated:YES];
    
    [[self.playersTableView cellForRowAtIndexPath:indexPath] setSelected:NO];
}




@end
