//
//  HistoryTableViewController.h
//  SOW
//
//  Created by Zulfiqar Syed on 11/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface HistoryTableViewController : UITableViewController<NSFetchedResultsControllerDelegate>
{

}



@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;




@end
