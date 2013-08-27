//
//  ViewController.m
//  ContactFixEC
//
//  Created by Jorge Tapia on 8/26/13.
//  Copyright (c) 2013 Mindshake Interactive. All rights reserved.
//

#import "ViewController.h"
#import "MainViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    MainViewController *mainViewController = [[MainViewController alloc] init];
    mainViewController = [segue destinationViewController];
    
    mainViewController.country = _country;
}

- (IBAction)mindshakeAction:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://mindshake.net"]];
}

- (IBAction)brasilAction:(id)sender {
    _country = NSLocalizedString(@"BRAZIL", nil);
}

- (IBAction)ecuadorAction:(id)sender {
    _country = NSLocalizedString(@"ECUADOR", nil);
}
@end
