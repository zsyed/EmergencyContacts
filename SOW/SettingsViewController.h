//
//  SettingsViewController.h
//  SOW
//
//  Created by Zulfiqar Syed on 11/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
// hello

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

@interface SettingsViewController : UIViewController <UITextViewDelegate, UIScrollViewDelegate, ABPeoplePickerNavigationControllerDelegate>


- (IBAction)btnSaveSetting:(id)sender;

- (IBAction)btnShowPicker:(id)sender;
- (IBAction)btnRetireKeyboard:(id)sender;
- (IBAction)btnReset:(id)sender;
- (IBAction)btnRetireKeyboard:(id)sender;


@property (unsafe_unretained, nonatomic) IBOutlet UITextField *txtToEmailAddress;
@property (unsafe_unretained, nonatomic) IBOutlet UITextField *txtName;
@property (unsafe_unretained, nonatomic) IBOutlet UITextField *txtCallPhoneNum;
@property (unsafe_unretained, nonatomic) IBOutlet UITextField *txtTextNumbers;
@property (unsafe_unretained, nonatomic) IBOutlet UITextView *txtMessageBody;
@property (unsafe_unretained, nonatomic) IBOutlet UITextField *txtMsgSubject;
@property (unsafe_unretained, nonatomic) IBOutlet UIScrollView *scrSettings;

@end

