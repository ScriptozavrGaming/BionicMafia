//
//  RulesViewController.m
//  Mafia
//
//  Created by AlexFill on 27.04.15.
//  Copyright (c) 2015 bionic. All rights reserved.
//

#import "RulesViewController.h"

@interface RulesViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *videoWebView;

@end

@implementation RulesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO];
    self.title = @"Rules";
    [self playVideo:@"https://youtu.be/682iQ9x4brM"];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)playVideo:(NSString *)urlString
{
    NSString *embedHTML = @"\
    <html><head>\
    <style type=\"text/css\">\
    body {\
    background-color: transparent;\
    color: black;\
    }\
    </style>\
    </head><body style=\"margin:0\">\
    <embed id=\"yt\" src=\"%@\" type=\"application/x-shockwave-flash\" \
    width=\"%0.0f\" height=\"%0.0f\"></embed>\
    </body></html>";
    NSString *html = [NSString stringWithFormat:embedHTML, urlString, self.videoWebView.frame.size.width,self.videoWebView.frame.size.height];
    [self.videoWebView loadHTMLString:html baseURL:nil];
    
    
}

@end
