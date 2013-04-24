//
//  MainAppViewController.h
//  SOW
//
//  Created by Zulfiqar Syed on 11/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <MessageUI/MessageUI.h>

@interface MainAppViewController : UIViewController <MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate>

- (IBAction)btnSendEmail:(id)sender;
- (IBAction)btnCallInSick:(id)sender;
- (IBAction)btnTextInSick:(id)sender;


@end
