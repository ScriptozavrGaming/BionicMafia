//
//  VoteViewController.m
//  Mafia
//
//  Created by AlexFill on 27.04.15.
//  Copyright (c) 2015 bionic. All rights reserved.
//

#import "VoteViewController.h"
#import "NightViewController.h"
#import "VoteTableViewCell.h"
#import "PlayerInGame.h"
#import "Player.h"

@interface VoteViewController ()

@property (weak, nonatomic) IBOutlet UITableView *playersOnVoteTableView;
@property (strong, nonatomic) NSMutableArray *countOfVotes;

@end

@implementation VoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = (self.isDuel) ? @"Duel" : @"Vote";
    [_playersOnVoteTableView registerNib:[UINib nibWithNibName:@"VoteTableViewCell" bundle:nil] forCellReuseIdentifier:@"voteCell"];
    [self.navigationItem setHidesBackButton:YES];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(votingDone:)];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)votingDone:(id)sender
{
    UIAlertView *allert = nil;
    NSIndexPath *indexPath = nil;
    for(NSInteger index = 0; index<self.playersOnVote.count; index++)
    {
        indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        NSString *count =((VoteTableViewCell *)[_playersOnVoteTableView
                                                cellForRowAtIndexPath:indexPath]).votesTextField.text;
        if([count isEqualToString:@""])
        {
            self.countOfVotes = nil;
            allert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Some count of votes didn't set" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [allert show];
            return;
        }
        else
        {
            [self.countOfVotes addObject:count];
        }
    }
    NSInteger sum = 0;
    for(NSString *object in self.countOfVotes)
    {
        sum += [object integerValue];
    }
    if(sum != self.alivePlayers)
    {
        self.countOfVotes = nil;
        allert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Wrong count of votes" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [allert show];
        return;

    }
    else
    {
        
        NSArray *sortedArray = [self.countOfVotes sortedArrayUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
            return [obj1 integerValue] < [obj2 integerValue];
        }];
        if([sortedArray[0] integerValue] > [sortedArray[1] integerValue])
        {
            NSInteger indexOfPlayer = 0;
            while([sortedArray[0] integerValue] != [self.countOfVotes[indexOfPlayer] integerValue])
            {
                indexOfPlayer++;
            }
            ((PlayerInGame *)self.playersOnVote[indexOfPlayer]).isAlive = NO;
            for(PlayerInGame *player in self.playersOnVote)
            {
                player.onVote = NO;
            }
            NSError *error = nil;
            [self.mainContext save:&error];
            NightViewController *nightController = [NightViewController new];
            nightController.mainContext = self.mainContext;
            [self.navigationController pushViewController:nightController animated:YES];
        }
        else
        {
            if(!self.isDuel)
            {
                NSMutableArray *playersOnDuel = [NSMutableArray new];
                for(NSInteger index = 0; index < self.countOfVotes.count; index++)
                {
                    if([sortedArray[0] integerValue]==[self.countOfVotes[index] integerValue])
                    {
                        [playersOnDuel addObject:self.playersOnVote[index]];
                    }
                    else
                    {
                        ((PlayerInGame *)self.playersOnVote[index]).onVote = NO;
                    }
                }
                NSError *error = nil;
                [self.mainContext save:&error];
                VoteViewController *duelController = [VoteViewController new];
                duelController.mainContext = self.mainContext;
                duelController.playersOnVote = playersOnDuel;
                duelController.isDuel = YES;
                duelController.alivePlayers = self.alivePlayers;
                [self.navigationController pushViewController:duelController animated:YES];
            }
            else
            {
                for(PlayerInGame *player in self.playersOnVote)
                {
                    player.onVote = NO;
                }
                NightViewController *nightController = [NightViewController new];
                nightController.mainContext = self.mainContext;
                [self.navigationController pushViewController:nightController animated:YES];
            }
        }
    }

}

- (NSMutableArray *)countOfVotes
{
    if(nil == _countOfVotes)
    {
        _countOfVotes = [NSMutableArray new];
    }
    return _countOfVotes;
}

#pragma mark - Table View Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return self.playersOnVote.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [_playersOnVoteTableView dequeueReusableCellWithIdentifier:@"voteCell" forIndexPath:indexPath];
    ((VoteTableViewCell *)cell).playerOnVoteLabel.text = [NSString stringWithFormat:@"%d. %@",[((PlayerInGame *)self.playersOnVote[indexPath.row]).number integerValue],((PlayerInGame *)self.playersOnVote[indexPath.row]).player.nickname];
    return cell;
}



@end
