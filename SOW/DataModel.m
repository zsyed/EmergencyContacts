//
//  DataModel.m
//  SOW
//
//  Created by Zulfiqar Syed on 12/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DataModel.h"
#import <CoreData/CoreData.h>
#import "SettingsEntity.h"
#import "Constants.h"

@implementation DataModel

NSManagedObjectContext *managedObjectContextEntity;
NSManagedObjectContext *managedObjectContextMessage;
NSManagedObjectModel *managedObjectModel;
NSPersistentStoreCoordinator *persistentStoreCoordinator;
NSEntityDescription *theSettingsEntity;
NSEntityDescription *theMessagesEntity;


-(id) init
{
    
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"SOW" withExtension:@"momd"];
    managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    NSError *error = nil;
    
    NSURL *storeURL = [[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject] URLByAppendingPathComponent:[Constants SQLLiteDB]];
    
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:managedObjectModel];
    
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    if (persistentStoreCoordinator != nil) {
        managedObjectContextEntity = [[NSManagedObjectContext alloc] init];
        [managedObjectContextEntity setPersistentStoreCoordinator:persistentStoreCoordinator];
        
        managedObjectContextMessage = [[NSManagedObjectContext alloc] init];
        [managedObjectContextMessage setPersistentStoreCoordinator:persistentStoreCoordinator];
    }
    
    theSettingsEntity = [NSEntityDescription entityForName:@"SettingsEntity" inManagedObjectContext:managedObjectContextEntity];
    theMessagesEntity = [NSEntityDescription entityForName:@"MessageEntity" inManagedObjectContext:managedObjectContextMessage];
    
    return self;
}



-(void) SaveSetting: (SettingsEntity *)setting
{
    NSError *error = nil;
    
    if (managedObjectContextEntity != nil) {
        if ([managedObjectContextEntity hasChanges] && ![managedObjectContextEntity save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Confirmation" message:@"Settings were saved successfully." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
            [alert show];
        }

    }
}

-(void) SaveMessage: (MessageEntity *)message
{
    NSError *error = nil;
    
    if (managedObjectContextMessage != nil) {
        if ([managedObjectContextMessage hasChanges] && ![managedObjectContextMessage save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }

}

-(NSArray *) GetSettingsResult
{
    
    NSManagedObjectContext *context = managedObjectContextEntity;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    [request setEntity:theSettingsEntity];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"enteredDateTime" ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    
    [request setSortDescriptors:sortDescriptors];
    
    
    NSArray *results = [context executeFetchRequest:request error:nil];
    
    return results;
}

-(SettingsEntity *) GetSettingsEntity
{
    SettingsEntity *settingsEntity = [NSEntityDescription 
                                      insertNewObjectForEntityForName:[theSettingsEntity name] 
                                      inManagedObjectContext:managedObjectContextEntity];
    return settingsEntity;
}

-(NSArray *) GetMessageResult
{
    NSFetchRequest *request = [self GetMessageFetchRequest];
    NSArray *results = [managedObjectContextMessage executeFetchRequest:request error:nil];
    
    return results;
}

-(NSFetchRequest *) GetMessageFetchRequest
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    [request setEntity:theMessagesEntity];
    /*
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"sentDateTime" ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    
    [request setSortDescriptors:sortDescriptors];
     */
    
    NSSortDescriptor *sortTypeMessage = [[NSSortDescriptor alloc] initWithKey:@"typeMessage" ascending:YES];
    NSSortDescriptor *sortDateTime = [[NSSortDescriptor alloc] initWithKey:@"sentDateTime" ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortTypeMessage, sortDateTime, nil];
    [request setSortDescriptors:sortDescriptors];
     
    return request;
}

-(NSFetchedResultsController *)  GetMessageFetchResultsController
{
    NSFetchRequest *fetchRequest = [self GetMessageFetchRequest];
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:managedObjectContextMessage sectionNameKeyPath:@"typeMessage" cacheName:nil];
    return aFetchedResultsController;
}

-(MessageEntity *) GetMessageEntity
{
    MessageEntity *mEntity = [NSEntityDescription 
                                      insertNewObjectForEntityForName:[theMessagesEntity name] 
                                      inManagedObjectContext:managedObjectContextMessage];
    return mEntity;
}



@end
