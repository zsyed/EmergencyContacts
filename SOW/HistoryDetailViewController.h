//
//  HistoryDetailViewController.h
//  SOW
//
//  Created by Zulfiqar Syed on 12/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageEntity.h"

@interface HistoryDetailViewController : UIViewController

@property MessageEntity *currentMessageEntity;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *lblMsgSubject;

@property (unsafe_unretained, nonatomic) IBOutlet UILabel *lblFromName;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *lblToEmailAddress;

@property (unsafe_unretained, nonatomic) IBOutlet UILabel *lblSentDate;

@property (unsafe_unretained, nonatomic) IBOutlet UILabel *lblToPhoneNum;

@property (unsafe_unretained, nonatomic) IBOutlet UILabel *lblToTextNum;

@property (unsafe_unretained, nonatomic) IBOutlet UILabel *lblMessageType;

@property (unsafe_unretained, nonatomic) IBOutlet UILabel *lblEmailBody;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *lblToName;

@end
