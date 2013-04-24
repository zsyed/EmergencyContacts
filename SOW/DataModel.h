//
//  DataModel.h
//  SOW
//
//  Created by Zulfiqar Syed on 12/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "SettingsEntity.h"
#import "MessageEntity.h"

@interface DataModel : NSObject


-(void)SaveSetting: (SettingsEntity *)setting;
-(SettingsEntity *) GetSettingsEntity;
-(NSArray *) GetSettingsResult;

-(void)SaveMessage: (MessageEntity *)message;
-(MessageEntity *) GetMessageEntity;
-(NSArray *) GetMessageResult;
-(NSFetchRequest *) GetMessageFetchRequest;
-(NSFetchedResultsController *)  GetMessageFetchResultsController;

@end
