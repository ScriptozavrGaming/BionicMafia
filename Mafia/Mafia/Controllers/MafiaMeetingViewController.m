//
//  MafiaMeetingViewController.m
//  Mafia
//
//  Created by AlexFill on 26.04.15.
//  Copyright (c) 2015 bionic. All rights reserved.
//

#import "MafiaMeetingViewController.h"
#import "MorningViewController.h"

@interface MafiaMeetingViewController ()
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UIButton *pauseButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@property (weak, nonatomic) NSTimer *timer;
@property (nonatomic) NSInteger seconds;

@end

@implementation MafiaMeetingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Mafia First Meet";
    [[self timerLabel] setText:@"1:00"];
    self.seconds = 60;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startButtonTouched:(id)sender
{
    if (nil == self.timer)
    {
//        [self.timer invalidate];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateTime:) userInfo:nil repeats:YES];
    }
    
}

- (IBAction)pauseButtonTouched:(id)sender
{
    if (nil != self.timer)
    {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)updateTime:(NSTimer *)aTimer
{
    if(self.seconds >0)
    {
        self.seconds--;
        [self.timerLabel setText:[NSString stringWithFormat:@"0:%02d",self.seconds]];
    }
    else
    {
        [aTimer invalidate];
        [self gotoMorning];
    }
}

- (IBAction)nexeTouched:(id)sender
{
    [self.timer invalidate];
    [self gotoMorning];
}

- (void)gotoMorning
{
    MorningViewController *morningController = [MorningViewController new];
    morningController.mainContext = self.mainContext;
    [self.navigationController pushViewController:morningController animated:YES];
}


@end
