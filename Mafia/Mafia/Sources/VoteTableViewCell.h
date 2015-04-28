//
//  VoteTableViewCell.h
//  Mafia
//
//  Created by AlexFill on 27.04.15.
//  Copyright (c) 2015 bionic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VoteTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *playerOnVoteLabel;
@property (weak, nonatomic) IBOutlet UITextField *votesTextField;

@end
