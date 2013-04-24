//
//  MainAppViewController.m
//  SOW
//
//  Created by Zulfiqar Syed on 11/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MainAppViewController.h"
#import "HistoryTableViewController.h"
#import "MessageEntity.h"
#import "SettingsEntity.h"
#import "DataModel.h"
#import "Constants.h"


DataModel *dataModel;

@interface MainAppViewController ()


@end

@implementation MainAppViewController



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
    dataModel = [[DataModel alloc]init];
    
    /*
    UIViewController *uivwHistory = [[UIViewController alloc] initWithNibName:@"HistoryTableViewController" bundle:nil];
    UIViewController *uivwSettings = [[UIViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil];
    
    
    NSArray *vwControllers = [NSArray arrayWithObjects:uivwHistory, uivwSettings, nil];
     */
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)btnSendEmail:(id)sender {


    if ([self OkayToSendEmail] == TRUE)
    {
        MessageEntity *msgEntity = [self GetFilledMessage];
        msgEntity.typeMessage = [Constants Email];
        [dataModel SaveMessage:msgEntity];
        
        MFMailComposeViewController *composer = [[MFMailComposeViewController alloc] init];
        [composer setMailComposeDelegate:self];
        if ([MFMailComposeViewController canSendMail])
        {
            // NSArray *recepient = [NSArray arrayWithObject:msgEntity.toEmailAddress];
            NSArray *recepient = [[NSArray alloc] init];// arrayWithObject:@"zulfiqarsyed@yahoo.com", @"dd", nil];
            //recepient = [NSArray arrayWithObjects:@"datagig@gmail.com", @"sobisyed@yahoo.com", nil];
            recepient = [msgEntity.toEmailAddress componentsSeparatedByString:@","];//  componentsSeparatedByString:@","];
            //recepient = [NSMutableArray arrayWithObjects:, nil];
            [composer setToRecipients:recepient];
            [composer setSubject:msgEntity.messageSubject];
            [composer setMessageBody:msgEntity.sentMessage isHTML:NO];
            [composer setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
            [self presentViewController:composer animated:YES completion:nil];
        }
       
    }   
    else {
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Some or all controls on Settings screen are empty. Please fill out Settings screen correctly." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil , nil];
        [alert show];
    }
}

-(BOOL) OkayToSendEmail
{
    BOOL returnValue = TRUE;
    
    dataModel = [[DataModel alloc] init];
    
    NSArray *results= [dataModel GetSettingsResult];
    
    if (results.count > 0)
    {
        SettingsEntity *settings = [results objectAtIndex:0];
        
        if (settings.messageSubject.length == 0) {
            returnValue = FALSE;
        }
        else if (settings.toEmailAddress.length == 0) {
            returnValue = FALSE;
        }
        else if (settings.messageBody.length == 0) {
            returnValue = FALSE;    
        }
        
    }
    else {
        returnValue = FALSE;  
    }

    return returnValue;
}

-(BOOL) OkayToCall
{
    BOOL returnValue = TRUE;
    
    dataModel = [[DataModel alloc] init];
    
    NSArray *results= [dataModel GetSettingsResult];
    
    if (results.count > 0)
    {
        SettingsEntity *settings = [results objectAtIndex:0];
        
        if (settings.toPhoneNumber.length == 0) {
            returnValue = FALSE;    
        }
        
    }
    else {
        returnValue = FALSE;  
    }
    
    return returnValue;
}

-(BOOL) OkayToText
{
    BOOL returnValue = TRUE;
    
    dataModel = [[DataModel alloc] init];
    
    NSArray *results= [dataModel GetSettingsResult];
    
    if (results.count > 0)
    {
        SettingsEntity *settings = [results objectAtIndex:0];

        if (settings.toPhoneNumber.length == 0) {
            returnValue = FALSE;    
        }        
        else if (settings.messageBody.length == 0) {
            returnValue = FALSE;    
        }
        
    }
    else {
        returnValue = FALSE;  
    }
    
    return returnValue;
}


-(MessageEntity *) GetFilledMessage
{
    DataModel *d = [[DataModel alloc] init];
    MessageEntity *msgEntity = [d GetMessageEntity];
    SettingsEntity *settings = [self GetSettings];
    
    msgEntity.fromName = settings.fromName;
    msgEntity.toEmailAddress = settings.toEmailAddress;
    msgEntity.toPhoneNumber = settings.toPhoneNumber;
    msgEntity.toTextNumbers = settings.toTextNumbers;
    msgEntity.sentName = settings.sentToName;
    msgEntity.messageSubject = settings.messageSubject;
    msgEntity.sentMessage = settings.messageBody;
    msgEntity.sentDateTime = [NSDate date];
    
    return msgEntity;
}

-(SettingsEntity *) GetSettings
{
    NSArray *results = [dataModel GetSettingsResult];
    
    SettingsEntity *settings;
    
    if (results.count > 0)
    {
        settings = [results objectAtIndex:0];
       
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"You have not saved Send to Email address in settings yet." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil , nil];
        [alert show];
        
        settings = nil;
    }
    return settings;

}
- (IBAction)btnCallInSick:(id)sender {

    if ([self OkayToCall] == TRUE)
    {
        MessageEntity *msgEntity = [self GetFilledMessage];
        msgEntity.typeMessage = [Constants Call];
        [dataModel SaveMessage:msgEntity];
        NSString *telephoneNum = msgEntity.toPhoneNumber;
        telephoneNum = [telephoneNum stringByReplacingOccurrencesOfString:@"[^0-9]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, [telephoneNum length])];
        
        NSString *telNum = [[NSString alloc] initWithFormat:@"tel:%@", telephoneNum ];
        
        ///telephoneNum = [[telephoneNum stringByReplacingCharactersInRange:@"(", @")",  withString:<#(NSString *)#>]]
        ////[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel:9497356569"]];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telNum]];
    }   
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"For calling, Some or all controls on Settings screen are empty. Please fill out Settings screen correctly." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil , nil];
        [alert show];
    }
 
}

- (IBAction)btnTextInSick:(id)sender {
    if ([self OkayToText] == TRUE)
    {
        MessageEntity *msgEntity = [self GetFilledMessage];
        msgEntity.typeMessage = [Constants Text];
        [dataModel SaveMessage:msgEntity];
        NSString *txtNumbers = msgEntity.toTextNumbers;
        NSArray *txtNumberArray = [[NSArray alloc]init];
        txtNumberArray = [txtNumbers componentsSeparatedByString:@","];
        NSMutableArray *parsedTextNumsarray = [[NSMutableArray alloc] init];
        for (id txtNumber in txtNumberArray) {
            NSString *number = txtNumber;
            number = [number stringByReplacingOccurrencesOfString:@"[^0-9]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, [number length])];
            [parsedTextNumsarray addObject:number];
        }
        
        MFMessageComposeViewController *textComposer = [[MFMessageComposeViewController alloc] init];
        [textComposer setMessageComposeDelegate:self];
        if([MFMessageComposeViewController canSendText])
        {
            [textComposer setRecipients:(NSArray *)parsedTextNumsarray];
            [textComposer setBody:msgEntity.sentMessage];
            [self presentViewController:textComposer animated:YES completion:nil];
            
        }
        else{
            
            NSLog(@"Can't open text");
            
        }
        

        
        
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"For texting, Some or all controls on Settings screen are empty. Please fill out Settings screen correctly." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil , nil];
        [alert show];
    }
    

}

//faisal starts here
-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result

{
    
    switch (result) {
            
        case MessageComposeResultSent:
            
            //Alert "Message Successfully sent"
            
            /////[self dismissModalViewControllerAnimated:YES];
            [self dismissViewControllerAnimated:YES completion:nil];
            
            break;
            
        case MessageComposeResultFailed:
            
            NSLog(@"failed");
            
            break;
            
        case MessageComposeResultCancelled:
            
            NSLog(@"cancelled");
            
        default:
            
            break;
            
    }
    
    /////[controller dismissModalViewControllerAnimated:YES];
    [controller dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error

{
    
    switch (result)
    
    {
            
        case MFMailComposeResultCancelled:
            
            NSLog(@"Mail cancelled: you cancelled the operation and no email message was queued.");
            
            break;
            
        case MFMailComposeResultSaved:
            
            NSLog(@"Mail saved: you saved the email message in the drafts folder.");
            
            break;
            
        case MFMailComposeResultSent:
            
        {
            
            NSLog(@"Mail send: the email message is queued in the outbox. It is ready to send.");
            
        }
            
            break;
            
        case MFMailComposeResultFailed:
            
            NSLog(@"Mail failed: the email message was not saved or queued, possibly due to an error.");
            
            break;
            
        default:
            
            NSLog(@"Mail not sent.");
            
            break;
            
    }
    
    // Remove the mail view
    
    /////[self dismissModalViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


//faisal code ends here
@end
