//
//  MorningViewController.m
//  Mafia
//
//  Created by AlexFill on 26.04.15.
//  Copyright (c) 2015 bionic. All rights reserved.
//

#import "MorningViewController.h"
#import "ButtonsTableViewCell.h"
#import "Game+Extension.h"
#import "PlayerInGame.h"
#import "Player.h"

@interface MorningViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *playersTableView;
@property (strong, nonatomic) NSArray *players;
@property (weak, nonatomic) NSTimer *timer;
@property (nonatomic) NSInteger secondsLeft;
@property (nonatomic) NSInteger playersToTalk;
@property (nonatomic, strong) NSMutableArray *playersOnVote;

@property (strong, nonatomic) UIBarButtonItem *startButton;
@property (strong, nonatomic) UIBarButtonItem *pauseButton;

@end

@implementation MorningViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_playersTableView registerNib:[UINib nibWithNibName:@"ButtonsTableViewCell" bundle:nil] forCellReuseIdentifier:@"buttonsCell"];
    self.title = @"Morning";
    self.startButton = [[UIBarButtonItem alloc] initWithTitle:@"Start" style:UIBarButtonItemStylePlain target:self action:@selector(playerMinuteStart:)];
    self.navigationItem.rightBarButtonItem = self.startButton;
    
    self.pauseButton = [[UIBarButtonItem alloc] initWithTitle:@"Pause" style:UIBarButtonItemStylePlain target:self action:@selector(playerMinutePause:)];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Stop" style:UIBarButtonItemStylePlain target:self action:@selector(nextPlayer:)];
    self.playersToTalk = 0;
    for (PlayerInGame *player in self.players){
        if (player.isAlive) self.playersToTalk++;
    }
    self.secondsLeft = 60;
    NSLog(@"%@", [@(self.playersToTalk) stringValue]);
    //[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(playerMinuteStart:)];
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
            return obj1.number > obj2.number;
        }];
        
    }
    return _players;
}

- (NSMutableArray *)playersOnVote
{
    if (_playersOnVote == nil)
    {
        _playersOnVote = [NSMutableArray new];
    }
    return _playersOnVote;
}


- (void)updateTime:(NSTimer *)aTimer
{
    if(self.secondsLeft >0)
    {
        self.secondsLeft--;
        self.title = [NSString stringWithFormat:@"0:%02d",self.secondsLeft];
    }
    else
    {
        [self nextPlayer:self];
    }
}

#pragma mark - Table View Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if (indexPath.row == 0)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"rightDetailCell"];
        cell.textLabel.text = [NSString stringWithFormat:@"Nickname: %@", ((PlayerInGame *)self.players[indexPath.section]).player.nickname];
        cell.detailTextLabel.text = ((PlayerInGame *)self.players[indexPath.section]).role;
    }
    else if (indexPath.row == 1)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"rightDetailCell"];
        NSString *status = (![((PlayerInGame *)self.players[indexPath.section]).isAlive  isEqual: @(0)])?
        @"Alive" : @"Dead";
        cell.textLabel.text = [NSString stringWithFormat:@"Status: %@", status];
        NSNumber *faults = ((PlayerInGame *)self.players[indexPath.section]).faults;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"Faults: %@",[faults stringValue]];
        cell.detailTextLabel.textColor = [UIColor blackColor];
    }
    else if(indexPath.row == 2)
    {
        cell = [_playersTableView dequeueReusableCellWithIdentifier:@"buttonsCell"];
        UIButton *faultButton = ((ButtonsTableViewCell*)cell).takeFaultButton;
        UIButton *voteButton = ((ButtonsTableViewCell*)cell).takeOnVoteButton;
        [faultButton setTag:[indexPath section]];
        [voteButton setTag:[indexPath section]];
        if (![(PlayerInGame*)self.players[indexPath.section] isAlive]){
            [faultButton setEnabled:NO];
            [voteButton setEnabled:NO];
        }else {
            [faultButton setEnabled:YES];
            [voteButton setEnabled:YES];
            
        }
        [faultButton addTarget:self action:@selector(takeFaults:) forControlEvents:UIControlEventTouchUpInside];
        [voteButton addTarget:self action:@selector(takeOnVote:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 10;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [NSString stringWithFormat:@"Player %d",section+1];
}


#pragma mark - Button delegates

- (IBAction)takeOnVote:(id)sender
{
    NSInteger index = [sender tag];
    [sender setEnabled:NO];
    [self.playersOnVote addObject:self.players[index]];
}

- (IBAction)takeFaults:(id)sender
{
    NSInteger index = [sender tag];
    NSNumber *faults =((PlayerInGame*)self.players[index]).faults;
    faults = [[NSNumber alloc] initWithInteger:[faults integerValue] + 1];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:index];
    [self.playersTableView cellForRowAtIndexPath:indexPath].detailTextLabel.text =[NSString stringWithFormat:@"Faults: %@"
                                                                                   ,[faults stringValue]];
    ((PlayerInGame*)self.players[index]).faults = faults;
    if (faults.integerValue > 3){
        NSLog(@"%@ is dead now!", @(index));
        self.playersToTalk--;
        ((PlayerInGame*)self.players[index]).isAlive = NO;
        [self.playersTableView cellForRowAtIndexPath:indexPath].textLabel.text = @"Status: Dead";
        [sender setEnabled:NO];
    }
//    cell.detailTextLabel.textColor = [UIColor blackColor];
}


- (IBAction)playerMinutePause:(id)sender
{
    self.navigationItem.rightBarButtonItem = self.startButton;
    [self.timer invalidate];
    self.timer = nil;
}

- (IBAction)nextPlayer:(id)sender
{
    self.navigationItem.rightBarButtonItem = self.startButton;
    [self.timer invalidate];
    self.secondsLeft = 60;
    self.title = @"1:00";
    self.playersToTalk--;
    //    NSLog(@"%@", [@(self.playersToTalk) stringValue]);
    
    if (self.playersToTalk >0 ) {
        
    }
}


- (IBAction)playerMinuteStart:(id)sender
{
    self.navigationItem.rightBarButtonItem = self.pauseButton;
    if (nil != self.timer) {
        [self.timer invalidate];
    }
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateTime:) userInfo:nil repeats:YES];
}

@end
