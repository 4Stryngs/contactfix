//
//  ViewController.h
//  ContactFixEC
//
//  Created by Jorge Tapia on 8/26/13.
//  Copyright (c) 2013 Mindshake Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property NSString *country;
@property (strong, nonatomic) IBOutlet UIButton *mindshakeButton;
@property (strong, nonatomic) IBOutlet UIButton *ecuadorButton;
@property (strong, nonatomic) IBOutlet UIButton *brasilButton;

- (IBAction)mindshakeAction:(id)sender;
- (IBAction)ecuadorAction:(id)sender;
- (IBAction)brasilAction:(id)sender;
@end
