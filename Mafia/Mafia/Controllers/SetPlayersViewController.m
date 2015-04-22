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
#import "AppDelegate.h"


NSInteger const kCountOfPlayers = 10;

@interface SetPlayersViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *playersTableView;
@property (nonatomic, readonly) NSManagedObjectContext *mainContext;
@property (nonatomic) NSInteger choosedControllerIndex;
@property (nonatomic, strong) NSMutableArray *addOrChooseControllers;

@end

NSString *const kNameNotification2 = @"changePlayerInfo";

@implementation SetPlayersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[self navigationController] setNavigationBarHidden:NO];
    self.title = @"Set Players";
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:nil action:@selector(savePlayers:)];
    self.navigationItem.rightBarButtonItem = saveButton;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recieveNotification:) name:kNameNotification2 object:nil];
}

- (void)recieveNotification:(NSNotification *)notification
{
    if([notification.name isEqualToString:kNameNotification2])
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.choosedControllerIndex inSection:0];
        AddOrChoosePlayerViewController *tempController = self.addOrChooseControllers[self.choosedControllerIndex];
        NewPlayerTabViewController *forNickname = (NewPlayerTabViewController *)tempController.selectedViewController;
        [_playersTableView cellForRowAtIndexPath:indexPath].detailTextLabel.text = forNickname.nicknameTextField.text;
    }
}

- (void)savePlayers:(id)sender
{
    for(NSUInteger i = 0; i<10; i++)
    {
//        NSString *temp = nil;
//        NSIndexPath *a = [NSIndexPath indexPathForItem:i inSection:0];
//        temp = ((SetPlayerTableViewCell *)[_playersTableView cellForRowAtIndexPath:a]).nicknameTextField.text;
//        
//        NSLog(@"%@ \n",temp);
    }
}

- (NSMutableArray *)addOrChooseControllers
{
    if(nil == _addOrChooseControllers)
    {
        _addOrChooseControllers = [[NSMutableArray alloc] init];
        for(NSInteger index = 0; index<10; index++)
        {
            [_addOrChooseControllers addObject:[[AddOrChoosePlayerViewController alloc] initWithNibName:@"AddOrChoosePlayerViewController" bundle:nil]];
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
    cell.detailTextLabel.text = @"BANDERA";
    cell.detailTextLabel.textColor = [UIColor redColor];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    return cell;
}

#pragma  mark - Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.choosedControllerIndex = indexPath.row;
    [[self navigationController] pushViewController:self.addOrChooseControllers[indexPath.row] animated:YES];
}

@end
