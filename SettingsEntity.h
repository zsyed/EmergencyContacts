//
//  SettingsEntity.h
//  SOW
//
//  Created by ZULFIQAR A SYED on 12/19/12.
//
// changes

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface SettingsEntity : NSManagedObject

@property (nonatomic, retain) NSDate * enteredDateTime;
@property (nonatomic, retain) NSString * fromName;
@property (nonatomic, retain) NSString * messageBody;
@property (nonatomic, retain) NSString * sentToName;
@property (nonatomic, retain) NSString * toEmailAddress;
@property (nonatomic, retain) NSString * toPhoneNumber;
@property (nonatomic, retain) NSString * toTextNumbers;
@property (nonatomic, retain) NSString * messageSubject;

@end
