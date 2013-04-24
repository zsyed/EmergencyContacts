//
//  SettingsViewController.m
//  SOW
//
//  Created by Zulfiqar Syed on 11/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SettingsViewController.h"
#import "MainAppViewController.h"
#import "SettingsEntity.h"
#import "DataModel.h"
#import "ABContact.h"
#import <QuartzCore/QuartzCore.h>
#import "ABContactsHelper.h"
#import "ABStandin.h"
#import "ABGroup.h"

DataModel *dataModel;

@interface SettingsViewController ()

@end

@implementation SettingsViewController



////@synthesize txtFromName;

//@synthesize txtTextPhoneNumbers;
@synthesize txtMessageBody;
@synthesize txtToEmailAddress;
@synthesize txtName;
@synthesize txtMsgSubject;
@synthesize txtCallPhoneNum;
@synthesize scrSettings;
@synthesize txtTextNumbers;

#define kOFFSET_FOR_KEYBOARD 80.0

NSManagedObjectContext *managedObjectContext;
NSEntityDescription *entity;
BOOL *chooseEmail;
BOOL *choosePhone;
BOOL *chooseText;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)textViewDidBeginEditing:(UITextView *)textField
{
    [self animateTextField:textField up: YES];
}

- (void)textViewDidEndEditing:(UITextView *)textField
{
    [self animateTextField: textField up: NO];
}

- (void) animateTextField: (UITextView*) textField up: (BOOL) up
{
    const int movementDistance = 80; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == txtTextNumbers || textField == txtToEmailAddress || textField == txtCallPhoneNum)
    {
        UIButton *button = nil;
        NSLog(@"textField>>%@",[textField.subviews description]);
        if([textField.text isEqualToString:@""])
            button = (UIButton *)[textField.subviews objectAtIndex:2];
        else
            button = (UIButton *)[textField.subviews objectAtIndex:1];
    
        if (button != nil)
        {
            button.hidden = YES;
            [button removeFromSuperview];
        }
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == txtTextNumbers || textField == txtToEmailAddress || textField == txtCallPhoneNum)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeContactAdd];
        textField.rightView = button;
        textField.rightViewMode = UITextFieldViewModeAlways;
        if(textField == txtTextNumbers)
        {
            [button addTarget:self action:@selector(AddTextNumber:) forControlEvents:UIControlEventTouchUpInside];
        }
        if(textField == txtCallPhoneNum)
        {
            [button addTarget:self action:@selector(AddPhoneNumber:) forControlEvents:UIControlEventTouchUpInside];
        }
        if(textField == txtToEmailAddress)
        {
            [button addTarget:self action:@selector(AddEmailAddress:) forControlEvents:UIControlEventTouchUpInside];
        }
        [textField addSubview:button];
    }
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    txtMessageBody.layer.cornerRadius = 5.0;
    txtMessageBody.clipsToBounds = YES;
    [txtMessageBody.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor]];
    [txtMessageBody.layer setBorderWidth:2.0];
    

    dataModel = [[DataModel alloc] init];
    
    NSArray *results= [dataModel GetSettingsResult];
    
    if (results.count > 0)
    {
        SettingsEntity *setting = [results objectAtIndex:0];
        

        txtName.text = setting.sentToName;
        txtToEmailAddress.text = setting.toEmailAddress;
        txtCallPhoneNum.text = setting.toPhoneNumber;
        txtMessageBody.text = setting.messageBody;
        txtMsgSubject.text = setting.messageSubject;
        txtTextNumbers.text = setting.toTextNumbers;
    }
    else {
        
        txtMsgSubject.text =@"I am out sick today."; // emptyString;
        txtMessageBody.text = @"I am feeling sick and I can not come into work today.";
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Reminder" message:@"You have not saved any settings." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [alert show];
    }
}

- (void)viewDidUnload
{
    [self setTxtToEmailAddress:nil];
    [self setTxtName:nil];
    [self setTxtCallPhoneNum:nil];
    [self setTxtMessageBody:nil];
    [self setTxtMsgSubject:nil];
    [self setScrSettings:nil];
    [self setTxtTextNumbers:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)btnSaveSetting:(id)sender {
    
    SettingsEntity *entity = [dataModel GetSettingsEntity];
    
    entity.toEmailAddress = txtToEmailAddress.text;
    entity.sentToName = txtName.text;
    entity.toPhoneNumber = txtCallPhoneNum.text;
    entity.messageBody = txtMessageBody.text;
    entity.messageSubject = txtMsgSubject.text;
    entity.toTextNumbers = txtTextNumbers.text;
    entity.enteredDateTime = [NSDate date];
    
    [dataModel SaveSetting:entity];
    [txtMessageBody resignFirstResponder];
    
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];
    
}


- (IBAction)btnReset:(id)sender {
    [self ResetControls];
}

-(void)ResetControls
{
    NSString *emptyString = @"";
    txtToEmailAddress.text = emptyString;
    txtName.text =emptyString;
    txtCallPhoneNum.text = emptyString;
    txtTextNumbers.text = emptyString;
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"EEE. MMM. dd"];
    NSString *currentDateTime = [dateFormat stringFromDate:[NSDate date]];
    
    NSString *messageSubject = @"I am out sick today ";
    messageSubject = [messageSubject stringByAppendingString:currentDateTime];
    txtMsgSubject.text = messageSubject;
    NSString *bodyText = @"I am feeling sick and I can not come into work today on ";
    bodyText = [bodyText stringByAppendingString:currentDateTime];
    txtMessageBody.text = bodyText;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    
    [txtToEmailAddress resignFirstResponder];
    [txtName resignFirstResponder];
    [txtCallPhoneNum resignFirstResponder];
    [txtMessageBody resignFirstResponder];
    [txtMsgSubject resignFirstResponder];
    [txtTextNumbers resignFirstResponder];
    
}

-(IBAction)AddPhoneNumber:(id)sender{
    chooseEmail = NO;
    choosePhone = YES;
    chooseText = NO;
    [self DisplayAddressBook];
}

-(IBAction)AddEmailAddress:(id)sender{
    
    chooseEmail = YES;
    choosePhone = NO;
    chooseText = NO;
    [self DisplayAddressBook];
 
}

-(IBAction)AddTextNumber:(id)sender{
    chooseEmail = NO;
    choosePhone = NO;
    chooseText = YES;
    [self DisplayAddressBook];
    
}


-(void) DisplayAddressBook
{
    ABPeoplePickerNavigationController *ppnc =
    [[ABPeoplePickerNavigationController alloc] init];
    ppnc.peoplePickerDelegate = self;
    [self presentModalViewController:ppnc animated:YES];
}

- (void)peoplePickerNavigationControllerDidCancel:
(ABPeoplePickerNavigationController *)peoplePicker
{
    [self dismissModalViewControllerAnimated:YES];
}

- (BOOL)peoplePickerNavigationController:
(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person
{
    // Continue onto the detail screen
    return YES;
}

- (BOOL)validateEmail:(NSString *)emailStr {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:emailStr];
}

- (BOOL)validatePhoneNumber:(NSString *)phoneStr {
    NSString *phoneRegex = @"^[\\(]{0,1}([0-9]){3}[\\)]{0,1}[ ]?([^0-1]){1}([0-9]){2}[ ]?[-]?[ ]?([0-9]){4}[ ]*((x){0,1}([0-9]){1,5}){0,1}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [phoneTest evaluateWithObject:phoneStr];
}

- (BOOL)peoplePickerNavigationController:
(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person
                                property:(ABPropertyID)property
                              identifier:(ABMultiValueIdentifier)identifier
{
    // Guaranteed to only be working with e-mail or phone here
    [self dismissModalViewControllerAnimated:YES];
        
    NSArray *array =
    [ABContact arrayForProperty:property inRecord:person];
    NSString *pickedValue = (NSString *)[array objectAtIndex:identifier];
    
    
    if (chooseEmail)
    {
        if([self validateEmail:pickedValue]) {
            if (txtToEmailAddress.text.length > 0)
            {
                
                txtToEmailAddress.text = [txtToEmailAddress.text stringByAppendingFormat:@",%@",pickedValue];
            }
            else
            {
                txtToEmailAddress.text = pickedValue;
            }
        }
        else
        {
            // user entered invalid email address
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Enter a valid email address." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alert show];
        }

        
    }
    if (choosePhone)
    {
        
        if([self validatePhoneNumber:pickedValue]) {
            txtCallPhoneNum.text = pickedValue;
        }
        else
        {
            // user entered invalid phone number
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Enter a valid phone number." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alert show];
        }
        
        
    }
    if (chooseText)
    {
        if([self validatePhoneNumber:pickedValue]) {
            if (txtTextNumbers.text.length > 0)
            {
                txtTextNumbers.text = [txtTextNumbers.text stringByAppendingFormat:@",%@",pickedValue];
            }
            else
            {
                txtTextNumbers.text = pickedValue;
            }
        }
        else
        {
            // user entered invalid phone number
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Enter a valid phone number." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alert show];
        }
        
    }

    return NO;
    
}

@end
