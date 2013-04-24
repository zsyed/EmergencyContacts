//
//  HistoryDetailViewController.m
//  SOW
//
//  Created by Zulfiqar Syed on 12/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HistoryDetailViewController.h"
#import "Constants.h"

@interface HistoryDetailViewController ()


@end

@implementation HistoryDetailViewController
@synthesize lblFromName;
@synthesize lblToEmailAddress;
@synthesize lblSentDate;
@synthesize lblToPhoneNum;
@synthesize lblToTextNum;
@synthesize lblMessageType;
@synthesize lblEmailBody;
@synthesize lblToName;
@synthesize currentMessageEntity;
@synthesize lblMsgSubject;

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
    
    NSString *msgType = [[NSString alloc] initWithFormat:@"%@ed",currentMessageEntity.typeMessage];
    lblMessageType.text = msgType;
    
    if ([currentMessageEntity.typeMessage isEqualToString:[Constants Email]])
    {
        lblToEmailAddress.text = currentMessageEntity.toEmailAddress;
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"EEE. MMM. dd, yyyy hh:mm:ss a"];
        NSString *sentDateTime = [dateFormat stringFromDate:currentMessageEntity.sentDateTime];
        lblSentDate.text = sentDateTime;
        lblToName.text = currentMessageEntity.sentName;
        lblEmailBody.text = currentMessageEntity.sentMessage;
        [lblEmailBody sizeToFit];
        lblMsgSubject.text = currentMessageEntity.messageSubject;
    }
    else if ([currentMessageEntity.typeMessage isEqualToString:[Constants Text]])
    {
        lblToEmailAddress.text = currentMessageEntity.toTextNumbers;
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"EEE. MMM. dd, yyyy hh:mm:ss a"];
        NSString *sentDateTime = [dateFormat stringFromDate:currentMessageEntity.sentDateTime];
        lblSentDate.text = sentDateTime;
        lblToName.text = currentMessageEntity.sentName;
        lblEmailBody.text = currentMessageEntity.sentMessage;
        [lblEmailBody sizeToFit];
        lblMsgSubject.text = currentMessageEntity.messageSubject;
    }
    else 
    {
        lblToEmailAddress.text = currentMessageEntity.toPhoneNumber;
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"EEE. MMM. dd, yyyy hh:mm:ss a"];
        NSString *sentDateTime = [dateFormat stringFromDate:currentMessageEntity.sentDateTime];
        lblSentDate.text = sentDateTime;
        lblToName.text = currentMessageEntity.sentName;
        
        lblEmailBody.text = @"";// = currentMessageEntity.sentMessage;
        // [lblEmailBody sizeToFit];
        //lblMsgSubject.text = @""; currentMessageEntity.messageSubject;
        
    }
    
    
    /// lblFromName.text = currentMessageEntity.fromName;
    

    
    /*
    lblToPhoneNum.text = currentMessageEntity.toPhoneNumber;
    lblToTextNum.text = currentMessageEntity.toTextNumbers;
     
     */

}

- (void)viewDidUnload
{
    [self setLblFromName:nil];
    [self setLblToEmailAddress:nil];
    [self setLblEmailBody:nil];
    [self setLblSentDate:nil];
    [self setLblToPhoneNum:nil];
    [self setLblToTextNum:nil];
    [self setLblMessageType:nil];
    [self setLblToName:nil];
    [self setLblMsgSubject:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
