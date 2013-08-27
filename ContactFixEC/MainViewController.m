//
//  MainViewController.m
//  ContactFixEC
//
//  Created by Jorge Tapia on 8/26/13.
//  Copyright (c) 2013 Mindshake Interactive. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.title = _country;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)mindshakeAction:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://mindshake.net"]];
}

- (IBAction)facebookAction:(id)sender {
    NSString *appUrlString = @"https://itunes.apple.com/app/contactfixec/id562577342?mt=8";
    NSString *shareUrlString = [NSString stringWithFormat:@"http://www.facebook.com/sharer.php?u=%@", [appUrlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] ;
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:shareUrlString]];
}

- (IBAction)twitterAction:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:NSLocalizedString(@"TWITTER_SHARE", nil)]];
}

- (IBAction)actualizarAction:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"UPDATE", nil) message:NSLocalizedString(@"CONFIRM_TEXT", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"CANCEL", nil) otherButtonTitles:NSLocalizedString(@"ACCEPT", nil), nil];
    [alert show];
}

- (void) alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        // Process contacts
        __block BOOL accessGranted = NO;
        ABAddressBookRef addressBook = ABAddressBookCreate();
        
        if (ABAddressBookRequestAccessWithCompletion != NULL) {
            dispatch_semaphore_t sema = dispatch_semaphore_create(0);
            
            ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
                accessGranted = granted;
                dispatch_semaphore_signal(sema);
            });
            
            dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
            //dispatch_release(sema);
        }
        else { // we're on iOS5 or older
            accessGranted = YES;
        }
        
        if (accessGranted) {
            // Show activity indicator while processing
            UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
            [self.view addSubview: activityIndicator];
            activityIndicator.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
            activityIndicator.center = self.view.center;
            [activityIndicator startAnimating];
            
            // Disable UI controls
            [self enableUI:NO];
            
            CFArrayRef allContacts = ABAddressBookCopyArrayOfAllPeople(addressBook);
            CFIndex nContacts = ABAddressBookGetPersonCount(addressBook);
            
            // Loop through the entire address book
            for (CFIndex contactIndex = 0; contactIndex < nContacts; contactIndex++) {
                ABRecordRef contact = CFArrayGetValueAtIndex(allContacts, contactIndex);
                ABMultiValueRef phoneNumbers = ABRecordCopyValue(contact, kABPersonPhoneProperty);
                ABMutableMultiValueRef phones = ABMultiValueCreateMutableCopy(phoneNumbers);
                
                NSString *mobile = nil;
                
                // Loop through every phone number stored
                for (CFIndex phoneIndex = 0; phoneIndex < ABMultiValueGetCount(phoneNumbers); phoneIndex++) {
                    NSString *phoneLabel = (__bridge NSString *)(ABMultiValueCopyLabelAtIndex(phoneNumbers, phoneIndex));
                    
                    if ([phoneLabel isEqualToString:(NSString*)kABPersonPhoneMobileLabel] || [phoneLabel isEqualToString:(NSString *)kABPersonPhoneIPhoneLabel]) {
                        mobile = (__bridge NSString *) ABMultiValueCopyValueAtIndex(phoneNumbers, phoneIndex);
                        
                        if ([_country isEqualToString:NSLocalizedString(@"ECUADOR", nil)]) {
                            // Ecuador
                            if ([mobile hasPrefix:@"0"] && [mobile length] == 9) {
                                NSString *newFormattedNumber = [NSString stringWithFormat:@"09%@",[mobile substringFromIndex:1]];
                                ABMultiValueReplaceValueAtIndex(phones, (__bridge CFTypeRef)(newFormattedNumber), phoneIndex);
                                NSLog(@"Old %@ \nNew %@", mobile, newFormattedNumber);
                            } else if ([mobile hasPrefix:@"+593"] && ([mobile length] == 12 || [mobile length] == 13)) {
                                if ([mobile length] == 12) {
                                    NSString *newFormattedNumber = [NSString stringWithFormat:@"+5939%@",[mobile substringFromIndex:4]];
                                    ABMultiValueReplaceValueAtIndex(phones, (__bridge CFTypeRef)(newFormattedNumber), phoneIndex);
                                    NSLog(@"Old %@ \nNew %@", mobile, newFormattedNumber);
                                } else if ([mobile length] == 13) {
                                    NSString *newFormattedNumber = [NSString stringWithFormat:@"+593 9%@",[mobile substringFromIndex:5]];
                                    ABMultiValueReplaceValueAtIndex(phones, (__bridge CFTypeRef)(newFormattedNumber), phoneIndex);
                                    NSLog(@"Old %@ \nNew %@", mobile, newFormattedNumber);
                                }
                            }
                        } else if ([_country isEqualToString:NSLocalizedString(@"BRAZIL", nil)]) {
                            // Brasil
                            if ([mobile hasPrefix:@"0"] && mobile.length == 11) {
                                NSString *newFormattedNumber = [NSString stringWithFormat:@"%@9%@", [mobile substringToIndex:3],[mobile substringFromIndex:3]];
                                ABMultiValueReplaceValueAtIndex(phones, (__bridge CFTypeRef)(newFormattedNumber), phoneIndex);
                                NSLog(@"Old %@ \nNew %@", mobile, newFormattedNumber);
                            } else if ([mobile hasPrefix:@"+55"] && mobile.length == 18) {
                                NSString *newFormattedNumber = [NSString stringWithFormat:@"%@9%@", [mobile substringToIndex:9],[mobile substringFromIndex:9]];
                                ABMultiValueReplaceValueAtIndex(phones, (__bridge CFTypeRef)(newFormattedNumber), phoneIndex);
                                NSLog(@"Old %@ \nNew %@", mobile, newFormattedNumber);
                            } else if ([mobile hasPrefix:@"("] && mobile.length == 12) {
                                NSString *newFormattedNumber = [NSString stringWithFormat:@"%@9%@", [mobile substringToIndex:1], [mobile substringFromIndex:1]];
                                ABMultiValueReplaceValueAtIndex(phones, (__bridge CFTypeRef)(newFormattedNumber), phoneIndex);
                                NSLog(@"Old %@ \nNew %@", mobile, newFormattedNumber);
                            }
                        }
                    }
                }
                
                ABRecordSetValue(contact, kABPersonPhoneProperty, phones, nil);
                
                CFRelease(phoneNumbers);
                CFRelease(phones);
            }
            
            // Hide activity indicator
            [activityIndicator stopAnimating];
            
            if (ABAddressBookHasUnsavedChanges(addressBook)) {
                CFErrorRef saveError = NULL;
                bool didSave = ABAddressBookSave(addressBook, &saveError);
                
                if (didSave) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"UPDATE", nil) message:NSLocalizedString(@"SUCCESS", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"ACCEPT", nil) otherButtonTitles:nil, nil];
                    [alert show];
                } else {
                    ABAddressBookRevert(addressBook);
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"ERROR", nil) message:@"Ha ocurrido un error. Sus contactos no han sido modificados." delegate:self cancelButtonTitle:@"Aceptar" otherButtonTitles:nil, nil];
                    [alert show];
                }
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"UPDATE", nil) message:NSLocalizedString(@"NO_MODS", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"ACEPTAR", nil) otherButtonTitles:nil, nil];
                [alert show];
            }
            
            CFRelease(addressBook);
            CFRelease(allContacts);
            
            // Enable UI controls
            [self enableUI:YES];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"ERROR", nil) message:NSLocalizedString(@"NO_PERMISSIONS", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"ACEPTAR", nil) otherButtonTitles:nil, nil];
            [alert show];
        }
    }
}

- (void)enableUI:(BOOL)enable {
    [_actualizarButton setEnabled:enable];
    [_mindshakeButton setEnabled:enable];
    [_facebookButton setEnabled:enable];
    [_twitterButton setEnabled:enable];
}
@end
