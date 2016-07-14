//
//  AddNoteViewController.m
//  ToDo List
//
//  Created by Admin on 14/07/16.
//  Copyright © 2016 da_manifest. All rights reserved.
//

#import "AddNoteViewController.h"
#import "TDNote.h"
#import <MagicalRecord/MagicalRecord.h>

@interface AddNoteViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *buttonAdd;

@end

@implementation AddNoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateTextLogic];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)textChanged:(NSNotification *)sender
{
    if (sender.object != self.textField) return;
    [self updateTextLogic];
}

- (void)updateTextLogic
{
    NSString *text = [self textField].text;
    
    if (text.length == 0)
    {
        [[self buttonAdd] setEnabled:NO];
        [[self buttonAdd] setAlpha:0.2f];
    }
    
    else
    {
        [[self buttonAdd] setEnabled:YES];
        [[self buttonAdd] setAlpha:1.0f];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addAction:(id)sender
{
    [[self buttonAdd] setEnabled:NO];
    [[self buttonAdd] setAlpha:0.2f];
    
    [self.textField setEnabled:NO];
    
    [self saveWithCompleted:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)saveWithCompleted:(void (^)())completed
{
    NSString *text = [self textField].text;
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
        TDNote *note = [TDNote MR_createEntityInContext:localContext];
        note.name = text;
    } completion:^(BOOL contextDidSave, NSError * _Nullable error) {
        completed();
    }];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return true;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
