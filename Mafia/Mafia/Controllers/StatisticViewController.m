//
//  StatisticViewController.m
//  Mafia
//
//  Created by AlexFill on 27.04.15.
//  Copyright (c) 2015 bionic. All rights reserved.
//

#import "StatisticViewController.h"
#import "PlayerInfoViewController.h"
#import "Player.h"

@interface StatisticViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *players;

@end

@implementation StatisticViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO];
    self.title = @"Rating";
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSArray *)players
{
    if(nil == _players)
    {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Player"];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"rating" ascending:NO],
                                    [NSSortDescriptor sortDescriptorWithKey:@"nickname" ascending:YES]];
        NSError *error = nil;
        _players = [self.mainContext executeFetchRequest:request error:&error];
    }
    return _players;
}

#pragma mark - Table View Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return self.players.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"setPlayerCell"];
    cell.textLabel.text = [NSString stringWithFormat:@"%@.  %@",[@(indexPath.row + 1) stringValue],((Player *)self.players[indexPath.row]).nickname];
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ points",
                                 [((Player *)self.players[indexPath.row]).rating stringValue]];
    cell.detailTextLabel.textAlignment = NSTextAlignmentCenter;
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    return cell;
}

#pragma mark - table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PlayerInfoViewController *infoController = [PlayerInfoViewController new];
    infoController.player = self.players[indexPath.row];
    infoController.mainContext = self.mainContext;
    [self.navigationController pushViewController:infoController animated:YES];
}


@end
