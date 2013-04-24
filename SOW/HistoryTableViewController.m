//
//  HistoryTableViewController.m
//  SOW
//
//  Created by Zulfiqar Syed on 11/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HistoryTableViewController.h"
#import "MessageEntity.h"
#import "DataModel.h"
#import "HistoryDetailViewController.h"
#import "Constants.h"

@interface HistoryTableViewController ()
 - (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@end


@implementation HistoryTableViewController

//todo: zulfiqar review this line of code.
@synthesize fetchedResultsController = __fetchedResultsController;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //todo: get fetched controller here.. and reuse it every where in rest of this class.
     //fetchedResultsController = __fetchedResultsController;
}

/* faisal code starts here */
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    NSFetchedResultsController *c = [self fetchedResultsController];
    NSArray *titles = [c sectionIndexTitles];
    NSString *title = titles[section];
    
    if ([title isEqualToString:@"E"])
    {
        return [Constants Email];
    }
    else if([title isEqualToString:@"T"])
    {
        return [Constants Text];
    }
    else
    {
        return [Constants Call];
    }
}

- (NSArray *)sectionIndexTitlesForTableView: (UITableView *)aTableView
{
    NSFetchedResultsController *c = [self fetchedResultsController];
    return [c sectionIndexTitles];
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSFetchedResultsController *c = [self fetchedResultsController];
    id<NSFetchedResultsSectionInfo> sectionInfo = c.sections[section];
    return sectionInfo.numberOfObjects;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSFetchedResultsController *c = [self fetchedResultsController];
    return c.sections.count;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender 
{

    NSIndexPath *path = self.tableView.indexPathForSelectedRow;
    HistoryDetailViewController *hdvc = segue.destinationViewController;
    NSFetchedResultsController *c = [self fetchedResultsController];
    MessageEntity *message = (MessageEntity *)[c objectAtIndexPath:path];
    hdvc.currentMessageEntity = message;
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source
/*
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSFetchedResultsController *c = [self fetchedResultsController];
    id <NSFetchedResultsSectionInfo> sectionInfo = c.sections[section];

    return sectionInfo.numberOfObjects;
}
*/
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    
    NSFetchedResultsController *c = [self fetchedResultsController];
    

    MessageEntity *message = (MessageEntity *)[c objectAtIndexPath:indexPath];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"EEE. MMM. dd, yyyy HH:mm"];
    
    NSString *sentDateTime = [dateFormat stringFromDate:message.sentDateTime];
    
    NSString *contactAdd;
    
    if ([message.typeMessage isEqualToString:[Constants Email]])
    {
        contactAdd = message.toEmailAddress;
    }
    else if ([message.typeMessage isEqualToString:[Constants Call]])
    {
        
        NSString *telephoneNum = message.toPhoneNumber;
        telephoneNum = [telephoneNum stringByReplacingOccurrencesOfString:@"[^0-9]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, [telephoneNum length])];
        
        NSString *unformatted = telephoneNum;
        NSArray *stringComponents = [NSArray arrayWithObjects:[unformatted substringWithRange:NSMakeRange(0, 3)],
                                     [unformatted substringWithRange:NSMakeRange(3, 3)],
                                     [unformatted substringWithRange:NSMakeRange(6, [unformatted length]-6)], nil];
        
        contactAdd = [NSString stringWithFormat:@"(%@) %@-%@", [stringComponents objectAtIndex:0], [stringComponents objectAtIndex:1], [stringComponents objectAtIndex:2]];
    }
    else
    {
        contactAdd = message.toTextNumbers;
        
    }

    
    NSString *header = [[NSString alloc] initWithFormat:@"%@",contactAdd];
    NSString *detail = [[NSString alloc] initWithFormat:@"on %@", sentDateTime];
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        NSLog(@"Cell is NIL");
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:@"Cell"];
    }
    
    cell.detailTextLabel.text = detail;
    cell.textLabel.text = header;
    
    return cell;
     
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        NSFetchedResultsController *c = [self fetchedResultsController];
        NSManagedObject *object = [c objectAtIndexPath:indexPath];
        NSManagedObjectContext *context = self.fetchedResultsController.managedObjectContext;
        [context deleteObject:object];
        NSError *error = nil;
        if (![context save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }

    }   
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // The table view should not be re-orderable.
    return NO;
}

- (void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView reloadData];
    
}

- (NSFetchedResultsController *)fetchedResultsController
{
    if (__fetchedResultsController != nil) {
        return __fetchedResultsController;
    }    
    DataModel *data = [[DataModel alloc]init];
    NSFetchedResultsController *aFetchedResultsController = [data GetMessageFetchResultsController];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return __fetchedResultsController;
}  

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
