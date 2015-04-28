//
//  LoginPage.h
//  driverApp
//
//  Created by Nagraj Gopalakrishnan on 22/11/11.
//  Copyright 2011 TeamDecode Software Private limited. All rights reserved.
///

#import <UIKit/UIKit.h>
#import "SQLHelper.h"


@interface LoginPage : UIViewController {
	IBOutlet UIButton *LogInButton;
	IBOutlet UITextField *emailIdText;
	IBOutlet UITextField *PasswordText;
	IBOutlet UISwitch *RememberMe;
	IBOutlet UIButton *GuestVisitorButton;
	NSString *AlreadyWentToCity;
	NSString *isUserGuest;
	NSDictionary *allJourney;
	
	SQLHelper *m_db;
	
	NSDictionary *cityDictionary;
	NSDictionary *localitiesDictionary;
	NSDictionary *locationDictionary;
	NSArray *paths;
	NSString *documentsDirectory ;
}
@property(nonatomic,retain) NSDictionary *allJourney;
@property(nonatomic,retain) IBOutlet UIButton *LogInButton;
@property(nonatomic,retain) IBOutlet UIButton *GuestVisitorButton;
@property(nonatomic,retain) IBOutlet UITextField *emailIdText;
@property(nonatomic,retain) IBOutlet UITextField *PasswordText;
@property(nonatomic,retain) IBOutlet UISwitch *RememberMe;
@property(nonatomic, retain) NSString *AlreadyWentToCity;
@property (nonatomic, retain) 	NSString *isUserGuest;
@property (nonatomic, retain) 	NSArray *paths;
@property (nonatomic, retain) 	NSString *documentsDirectory ;

- (IBAction)textFieldReturn:(id)sender;
- (IBAction)dismissKeyboard:(id)sender;
- (IBAction) cancelEdit:(id)sender;
- (IBAction)loginIn:(id)sender;
- (IBAction)continueAsGuest:(id)sender;
//- (void) showAlert: (NSString *)msg;
@end




