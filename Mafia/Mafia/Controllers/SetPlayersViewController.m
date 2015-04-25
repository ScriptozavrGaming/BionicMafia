//
//  SetPlayersViewController.m
//  Mafia
//
//  Created by AlexFill on 18.04.15.
//  Copyright (c) 2015 bionic. All rights reserved.
//

#import "SetPlayersViewController.h"
#import "AddOrChoosePlayerViewController.h"
#import "NewPlayerTabViewController.h"
#import "ExistPlayerViewController.h"
#import "AppDelegate.h"
#import "PlayerInGame.h"
#import "Player+Extension.h"
#import "Game+Extension.h"


NSInteger const kCountOfPlayers = 10;

@interface SetPlayersViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *playersTableView;
@property (nonatomic, readonly) NSManagedObjectContext *mainContext;
@property (nonatomic) NSInteger choosedControllerIndex;
@property (nonatomic, strong) NSMutableArray *addOrChooseControllers;

@end

NSString *const kNameNotificationNewPlayer = @"changePlayerInfo";
NSString *const kNameNotificationExistPlayer = @"choosePlayer";
NSString *const kUnsetPlayer = @"1";

@implementation SetPlayersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[self navigationController] setNavigationBarHidden:NO];
    self.title = @"Set Players";
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(savePlayers:)];
    self.navigationItem.rightBarButtonItem = saveButton;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recieveNotification:) name:kNameNotificationNewPlayer object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recieveNotification:) name:kNameNotificationExistPlayer object:nil];
}



- (void)recieveNotification:(NSNotification *)notification
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.choosedControllerIndex inSection:0];
    AddOrChoosePlayerViewController *tempController = self.addOrChooseControllers[self.choosedControllerIndex];
    
    if([notification.name isEqualToString:kNameNotificationNewPlayer])
    {
        NewPlayerTabViewController *forNickname = (NewPlayerTabViewController *)tempController.selectedViewController;
        [_playersTableView cellForRowAtIndexPath:indexPath].detailTextLabel.text = forNickname.nicknameTextField.text;
    }
    if([notification.name isEqualToString:kNameNotificationExistPlayer])
    {
        ExistPlayerViewController *forNickname = (ExistPlayerViewController *)tempController.selectedViewController;
        [_playersTableView cellForRowAtIndexPath:indexPath].detailTextLabel.text = forNickname.choosenPlayer;
    }
}

- (void)savePlayers:(id)sender
{
    BOOL isUnset = NO;
    for(NSUInteger i = 0; i<10; i++)
    {
        NSString *nickname = nil;
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        nickname = [_playersTableView cellForRowAtIndexPath:indexPath].detailTextLabel.text;
//        if([nickname isEqualToString:kUnsetPlayer])
        if (YES)
        {
            isUnset = YES;
        }
    }
    if(isUnset)
    {
        UIAlertView *allert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Some players don't set" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [allert show];
    }
    else
    {
        Game *game = [Game currentGame:self.mainContext];
        NSMutableSet *players = [NSMutableSet new];
        for (NSUInteger i = 0; i<10; i++)
        {
            NSString *nickname = nil;
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
            nickname = [_playersTableView cellForRowAtIndexPath:indexPath].detailTextLabel.text;
            Player *player = [Player playerForNickName:nickname inContext:self.mainContext];
            PlayerInGame *playerInfo = [NSEntityDescription insertNewObjectForEntityForName:@"PlayerInGame" inManagedObjectContext:self.mainContext];
            playerInfo.number = @(i + 1);
            playerInfo.game = game;
            playerInfo.score = @0;
            playerInfo.role = @"";
            playerInfo.faults = @0;
            playerInfo.player = player;
            
            [players addObject:playerInfo];
        }
        [game removePlayers:game.players];
        [game addPlayers:players];
        [self.navigationController popViewControllerAnimated:YES];
        [self.mainContext save:nil];
    }
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Game"];
    request.sortDescriptors = @[[[NSSortDescriptor alloc] initWithKey:@"number" ascending:YES]];
    NSError *error = nil;
    NSArray* games = [self.mainContext executeFetchRequest:request error:&error];

}

- (NSMutableArray *)addOrChooseControllers
{
    if(nil == _addOrChooseControllers)
    {
        _addOrChooseControllers = [[NSMutableArray alloc] init];
        for(NSInteger index = 0; index < 10; index++)
        {
            
            [_addOrChooseControllers addObject:[[AddOrChoosePlayerViewController alloc] initWithNibName:@"AddOrChoosePlayerViewController" bundle:nil]];
//            AddOrChoosePlayerViewController *controller
        }
    }
    return _addOrChooseControllers;
}

- (NSManagedObjectContext *)mainContext
{
    return [[[AppDelegate sharedAppDelegate] coreDataManager] managedObjectContext];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return kCountOfPlayers;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    SetPlayerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"setPlayerCell" forIndexPath:indexPath];
//    cell.numberLabel.text = [NSString stringWithFormat:@"Player %@",[@(indexPath.row + 1) stringValue]];
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:@"setPlayerCell"];
    cell.textLabel.text = [NSString stringWithFormat:@"Player %@",[@(indexPath.row + 1) stringValue]];
    cell.detailTextLabel.text = kUnsetPlayer;
    cell.detailTextLabel.textColor = [UIColor redColor];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    return cell;
}

#pragma  mark - Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.choosedControllerIndex = indexPath.row;
    AddOrChoosePlayerViewController *controller = self.addOrChooseControllers[indexPath.row];
    controller.mainContext = self.mainContext;
    [[self navigationController] pushViewController:controller animated:YES];
}

@end
