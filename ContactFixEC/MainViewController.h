//
//  MainViewController.h
//  ContactFixEC
//
//  Created by Jorge Tapia on 8/26/13.
//  Copyright (c) 2013 Mindshake Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

@interface MainViewController : UIViewController <UIAlertViewDelegate>
@property NSString *country;
@property (strong, nonatomic) IBOutlet UIButton *mindshakeButton;
@property (strong, nonatomic) IBOutlet UIButton *facebookButton;
@property (strong, nonatomic) IBOutlet UIButton *twitterButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *actualizarButton;


- (IBAction)mindshakeAction:(id)sender;
- (IBAction)facebookAction:(id)sender;
- (IBAction)twitterAction:(id)sender;
- (IBAction)actualizarAction:(id)sender;
@end
