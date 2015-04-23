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
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(savePlayer:)];
    self.navigationItem.rightBarButtonItem = saveButton;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)savePlayer:(id)sender
{
    if ([self saveToCoreData] == YES) {
        if (![((NewPlayerTabViewController *)self.selectedViewController).nicknameTextField.text isEqualToString:@""])
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:kNameNotification object:self];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"Input error"
                message:@"Nickname needed" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [view show];
        
    }
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
        existPlayerTab.mainContext = self.mainContext;
        [self.selectedViewController.view removeFromSuperview];
        [self.view addSubview:existPlayerTab.view];
        selectedViewController = existPlayerTab;
    }
}

bool isEmptyString(NSString * str){
    
    return [str isEqualToString:@""];
}

- (BOOL)saveToCoreData
{
    Player *newPlayer = [NSEntityDescription insertNewObjectForEntityForName:@"Player" inManagedObjectContext:self.mainContext];
    NewPlayerTabViewController *newPlayerController = (NewPlayerTabViewController *)selectedViewController;

    if(!isEmptyString(newPlayerController.nicknameTextField.text))
    {
        newPlayer.nickname = newPlayerController.nicknameTextField.text;
    }
    else
    {
        return NO;
    }
    
    newPlayer.firstName = (!isEmptyString(newPlayerController.firstNameTextField.text)) ?
        newPlayerController.firstNameTextField.text : kUnknownData;

    
    newPlayer.lastName = (!isEmptyString(newPlayerController.lastNameTextField.text)) ?
        newPlayerController.lastNameTextField.text : kUnknownData;

    
    newPlayer.email = (!isEmptyString(newPlayerController.lastNameTextField.text)) ?
        newPlayerController.emailTextField.text : kUnknownData;

    
    
    newPlayer.phone = (!isEmptyString(newPlayerController.phoneTextField.text)) ?
        newPlayerController.phoneTextField.text : kUnknownData;

    
    NSError *error = nil;
    [self.mainContext save:&error];
    return YES;
}

@end
