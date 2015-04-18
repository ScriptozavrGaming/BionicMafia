//
//  NewGameViewController.m
//  Mafia
//
//  Created by AlexFill on 18.04.15.
//  Copyright (c) 2015 bionic. All rights reserved.
//

#import "NewGameViewController.h"

@interface NewGameViewController ()

@end

@implementation NewGameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[self navigationController] setNavigationBarHidden:NO];
    self.title = @"Setup Roles";
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
