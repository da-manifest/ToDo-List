//
//  ListNoteTableViewController.m
//  ToDo List
//
//  Created by Admin on 14/07/16.
//  Copyright © 2016 da_manifest. All rights reserved.
//

#import "ListNoteTableViewController.h"
#import <MagicalRecord/MagicalRecord.h>
#import "TDNote.h"

@interface ListNoteTableViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, readwrite, strong) NSFetchedResultsController *fetchedResultsController;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *buttonDelete;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *buttonDone;

@end

@implementation ListNoteTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self buttonLogic];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cellSelected:) name:UITableViewSelectionDidChangeNotification object:nil];
    
    self.fetchedResultsController = [TDNote MR_fetchAllGroupedBy:nil withPredicate:nil sortedBy:nil ascending:YES];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (IBAction)deleteAction:(id)sender
{
    TDNote *note = [self.fetchedResultsController objectAtIndexPath:[self currentSellectedRowIndexPath]];
    [note MR_deleteEntity];
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    
    [[self tableView] reloadData];
    [self buttonLogic];
}

-(IBAction)isDoneAction:(id)sender
{
    TDNote *note = [self.fetchedResultsController objectAtIndexPath:[self currentSellectedRowIndexPath]];
    NSString *text = [NSString stringWithFormat:@"%@ - DONE!", note.name];
    
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
        note.name = text;
    } completion:^(BOOL contextDidSave, NSError * _Nullable error) {
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    }];
    
    [[self tableView] reloadData];
    [self buttonLogic];
}

- (void)cellSelected:(NSNotification *)sender;
{
    if (sender.object != self.tableView) return;
    [self buttonLogic];
}

- (void)buttonLogic
{
    if ([self currentSellectedRowIndexPath] == nil)
    {
        [[self buttonDelete] setEnabled:NO];
        [[self buttonDone] setEnabled:NO];
    }
    else
    {
        [[self buttonDelete] setEnabled:YES];
        [[self buttonDone] setEnabled:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.fetchedResultsController.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> info = self.fetchedResultsController.sections[section];
    return [info numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"noteCell"  forIndexPath:indexPath];
    
    TDNote *note = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [cell.textLabel setText:note.name];
  
    return cell;
}

- (NSIndexPath *)currentSellectedRowIndexPath
{
    NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
    if (selectedIndexPath) return selectedIndexPath;
    else return nil;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
