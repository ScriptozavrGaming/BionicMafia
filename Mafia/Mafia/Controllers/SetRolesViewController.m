//
//  SetRolesViewController.m
//  Mafia
//
//  Created by AlexFill on 25.04.15.
//  Copyright (c) 2015 bionic. All rights reserved.
//

#import "SetRolesViewController.h"

@interface SetRolesViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *rolesTableView;
@property (nonatomic, strong) NSArray *roles;
@property (nonatomic, strong) NSIndexPath *previousCellPath;
@end

NSString *const kNameNotificationRolesChangedSend = @"roleChanged";

@implementation SetRolesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSArray *)roles
{
    if(nil == _roles)
    {
        _roles = [[NSArray alloc] initWithObjects:@"Citizen",@"Mafia",@"Don",@"Comissar", nil];
    }
    return _roles;
}

#pragma mark - table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.roles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.textLabel.text = self.roles[indexPath.row];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return @"Roles";
}
#pragma mark - table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.previousCellPath != nil){
        [[tableView cellForRowAtIndexPath:self.previousCellPath] setAccessoryType:UITableViewCellAccessoryNone];

    }
    [[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryCheckmark];
    self.previousCellPath = indexPath;
     [[tableView cellForRowAtIndexPath:indexPath] setSelected:NO animated:YES];
    self.choosedRole = self.roles[indexPath.row];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNameNotificationRolesChangedSend object:self];
    [self.navigationController popViewControllerAnimated:YES];
}


@end
