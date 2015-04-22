//
//  AddOrChoosePlayerViewController.m
//  Mafia
//
//  Created by AlexFill on 19.04.15.
//  Copyright (c) 2015 bionic. All rights reserved.
//

#import "AddOrChoosePlayerViewController.h"
#import "NewPlayerTabViewController.h"
#import "ExistPlayerViewController.h"
#import "Player.h"

@interface AddOrChoosePlayerViewController () <UITabBarDelegate>

@end

NSString *const kNameNotification = @"changePlayerInfo";
NSString *const kUnknownData = @"unknown";

@implementation AddOrChoosePlayerViewController

@synthesize viewControllers;
@synthesize tabBar;
@synthesize addTabBarItem;
@synthesize existTabBarItem;
@synthesize selectedViewController;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"AddOrChoosePlayerViewController" bundle:nil];
    if(nil != self)
    {
        NewPlayerTabViewController *newPlayerTab = [[NewPlayerTabViewController alloc] initWithNibName:@"NewPlayerTabViewController" bundle:nil];
        ExistPlayerViewController *existPlayerTab = [[ExistPlayerViewController alloc] initWithNibName:@"ExistPlayerViewController" bundle:nil];
        NSArray *controllers = [NSArray arrayWithObjects:newPlayerTab,existPlayerTab, nil];
        self.viewControllers = controllers;
        [self.view addSubview:newPlayerTab.view];
        self.selectedViewController = newPlayerTab;
    }
    return self;
}
//- (instancetype)init
//{
//    self = [super init];
//    if(nil != self)
//    {
//        NewPlayerTabViewController *newPlayerTab = [[NewPlayerTabViewController alloc] initWithNibName:@"NewPlayerTabViewController" bundle:nil];
//        ExistPlayerViewController *existPlayerTab = [[ExistPlayerViewController alloc] initWithNibName:@"ExistPlayerViewController" bundle:nil];
//        NSArray *controllers = [NSArray arrayWithObjects:newPlayerTab,existPlayerTab, nil];
//        self.viewControllers = controllers;
//        [self.view addSubview:newPlayerTab.view];
//        self.selectedViewController = newPlayerTab;
//    }
//    return self;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Add New Player";
    [[self tabBar] setSelectedItem:addTabBarItem];
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:nil action:@selector(savePlayer:)];
    self.navigationItem.rightBarButtonItem = saveButton;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)savePlayer:(id)sender
{
    [self saveToCoreData];
    if (![((NewPlayerTabViewController *)self.selectedViewController).nicknameTextField.text isEqualToString:@""])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kNameNotification object:self];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)playerChoosed:(id)sender
{
    
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    if(item == addTabBarItem)
    {
        self.title = @"Add New Player";
        self.navigationItem.rightBarButtonItems = nil;
        UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:nil action:@selector(savePlayer:)];
        self.navigationItem.rightBarButtonItem = saveButton;
        NewPlayerTabViewController *newPlayerTab =[viewControllers objectAtIndex:0];
        [self.selectedViewController.view removeFromSuperview];
        [self.view addSubview:newPlayerTab.view];
        selectedViewController = newPlayerTab;
    }
    else if(item == existTabBarItem)
    {
        self.title = @"Choose Exist Player";
        self.navigationItem.rightBarButtonItems = nil;
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:nil action:@selector(playerChoosed:)];
        UIBarButtonItem *searchButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:nil action:@selector(playerChoosed:)];
        NSArray *rightBarItems = @[doneButton,searchButton];
        self.navigationItem.rightBarButtonItems = rightBarItems;
        ExistPlayerViewController *existPlayerTab =[viewControllers objectAtIndex:1];
        [self.selectedViewController.view removeFromSuperview];
        [self.view addSubview:existPlayerTab.view];
        selectedViewController = existPlayerTab;
    }
}

- (void)saveToCoreData
{
    Player *newPlayer = [NSEntityDescription insertNewObjectForEntityForName:@"Player" inManagedObjectContext:self.mainContext];
    NewPlayerTabViewController *newPlayerController = (NewPlayerTabViewController *)selectedViewController;
    if(![newPlayerController.firstNameTextField.text isEqual:@""])
    {
        newPlayer.firstName = newPlayerController.firstNameTextField.text;
    }
    else
    {
        newPlayer.firstName = kUnknownData;
    }
    if(![newPlayerController.lastNameTextField.text isEqual:@""])
    {
        newPlayer.lastName = newPlayerController.lastNameTextField.text;
    }
    else
    {
        newPlayer.lastName = kUnknownData;
    }
    if(![newPlayerController.emailTextField.text isEqual:@""])
    {
        newPlayer.email = newPlayerController.emailTextField.text;
    }
    else
    {
        newPlayer.email = kUnknownData;
    }
    if(![newPlayerController.phoneTextField.text isEqual:@""])
    {
        NSDecimalNumber *phone = [[NSDecimalNumber alloc] initWithString:newPlayerController.phoneTextField.text];
        newPlayer.phone = phone;
    }
    else
    {
        newPlayer.phone = 0;
    }
    if(![newPlayerController.nicknameTextField.text isEqual:@""])
    {
        newPlayer.nickname = newPlayerController.nicknameTextField.text;
    }
    else
    {
        newPlayer.nickname = @"Unset";
    }
    NSError *error = nil;
    [self.mainContext save:&error];
}

@end
