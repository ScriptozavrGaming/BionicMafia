//
//  SetPlayersViewController.m
//  Mafia
//
//  Created by AlexFill on 18.04.15.
//  Copyright (c) 2015 bionic. All rights reserved.
//

#import "SetPlayersViewController.h"

NSInteger const kCountOfPlayers = 10;

@interface SetPlayersViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *playersTableView;

@end

@implementation SetPlayersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[self navigationController] setNavigationBarHidden:NO];
    self.title = @"Set Players";
    // Do any additional setup after loading the view from its nib.
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
    UITableViewCell *cell = [UITableViewCell new];
    cell.textLabel.text = [NSString stringWithFormat:@"Player %@",[@(indexPath.row) stringValue]];
    return cell;
}

@end
