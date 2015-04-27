//
//  PlayerInfoViewController.m
//  Mafia
//
//  Created by AlexFill on 27.04.15.
//  Copyright (c) 2015 bionic. All rights reserved.
//

#import "PlayerInfoViewController.h"
#import "PlayerInfoTableViewCell.h"

@interface PlayerInfoViewController ()

@property (strong,nonatomic) UIBarButtonItem *doneButton;
@property (strong,nonatomic) UIBarButtonItem *editButton;
@property (strong,nonatomic) UIBarButtonItem *saveButton;
@property (weak, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;

@end

@implementation PlayerInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Player Info";
    self.navigationItem.rightBarButtonItems = @[self.saveButton,self.editButton];
    [self makePreviousSettings];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIBarButtonItem *)saveButton
{
    if(nil == _saveButton)
    {
        _saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                                                    target:self action:@selector(saveChanges:)];
    }
    return _saveButton;
}

- (UIBarButtonItem *)editButton
{
    if(nil == _editButton)
    {
        _editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                                                                    target:self action:@selector(makeEditable:)];
    }
    return _editButton;
}

- (UIBarButtonItem *)doneButton
{
    if(nil == _doneButton)
    {
        _doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                    target:self action:@selector(changesCompleted:)];
    }
    return _doneButton;
}

- (IBAction)makeEditable:(id)sender
{
    [self.saveButton setEnabled:NO];
    self.navigationItem.rightBarButtonItems = @[self.saveButton,self.doneButton];
    [self.firstNameTextField setEnabled:YES];
    [self.lastNameTextField setEnabled:YES];
    [self.emailTextField setEnabled:YES];
    [self.phoneTextField setEnabled:YES];
}

- (IBAction)saveChanges:(id)sender
{
    if(![self.firstNameTextField.text isEqualToString:@""])
    {
        self.player.firstName = self.firstNameTextField.text;
    }
    if(![self.lastNameTextField.text isEqualToString:@""])
    {
        self.player.lastName = self.lastNameTextField.text;
    }
    if(![self.emailTextField.text isEqualToString:@""])
    {
        self.player.email = self.emailTextField.text;
    }
    if(![self.phoneTextField.text isEqualToString:@""])
    {
        self.player.phone = self.phoneTextField.text;
    }
    NSError *error = nil;
    [self.mainContext save:&error];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)changesCompleted:(id)sender
{
    [self.saveButton setEnabled:YES];
    self.navigationItem.rightBarButtonItems = @[self.saveButton, self.editButton];
    [self.firstNameTextField setEnabled:NO];
    [self.lastNameTextField setEnabled:NO];
    [self.emailTextField setEnabled:NO];
    [self.phoneTextField setEnabled:NO];
    
}

- (void)makePreviousSettings
{
    self.firstNameTextField.text = self.player.firstName;
    self.lastNameTextField.text = self.player.lastName;
    self.emailTextField.text = self.player.email;
    self.phoneTextField.text = self.player.phone;
    self.nicknameLabel.text = [NSString stringWithFormat:@"%@ %@",self.nicknameLabel.text,self.player.nickname];
    self.ratingLabel.text = [NSString stringWithFormat:@"%@ %@",self.ratingLabel.text,self.player.rating];
}


@end
