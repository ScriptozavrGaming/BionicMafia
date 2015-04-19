//
//  SetPlayersViewController.m
//  Mafia
//
//  Created by AlexFill on 18.04.15.
//  Copyright (c) 2015 bionic. All rights reserved.
//

#import "SetPlayersViewController.h"
#import "AddOrChoosePlayerViewController.h"
#import "AppDelegate.h"


NSInteger const kCountOfPlayers = 10;

@interface SetPlayersViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *playersTableView;
@property (nonatomic, readonly) NSManagedObjectContext *mainContext;
@property (nonatomic) AddOrChoosePlayerViewController *addOrChooseController;

@end

@implementation SetPlayersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [_playersTableView registerNib:[UINib nibWithNibName:@"SetPlayerTableViewCell" bundle:nil] forCellReuseIdentifier:@"setPlayerCell"];
    [[self navigationController] setNavigationBarHidden:NO];
    self.title = @"Set Players";
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:nil action:@selector(savePlayers:)];
    self.navigationItem.rightBarButtonItem = saveButton;
    self.addOrChooseController = [[AddOrChoosePlayerViewController alloc] initWithNibName:@"AddOrChoosePlayerViewController" bundle:nil];
    // Do any additional setup after loading the view from its nib.
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
    [[self navigationController] pushViewController:self.addOrChooseController animated:YES];
}

@end
