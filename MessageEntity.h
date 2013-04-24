//
//  MessageEntity.h
//  SOW
//
//  Created by ZULFIQAR A SYED on 12/19/12.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface MessageEntity : NSManagedObject

@property (nonatomic, retain) NSString * fromName;
@property (nonatomic, retain) NSDate * sentDateTime;
@property (nonatomic, retain) NSString * sentMessage;
@property (nonatomic, retain) NSString * sentName;
@property (nonatomic, retain) NSString * toEmailAddress;
@property (nonatomic, retain) NSString * toPhoneNumber;
@property (nonatomic, retain) NSString * toTextNumbers;
@property (nonatomic, retain) NSString * typeMessage;
@property (nonatomic, retain) NSString * messageSubject;

@end
