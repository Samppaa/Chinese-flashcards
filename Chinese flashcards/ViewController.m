//
//  ViewController.m
//  Chinese flashcards
//
//  Created by Samuli Lehtonen on 24.8.2014.
//  Copyright (c) 2014 Samuli Lehtonen. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

// Keys:
// includeKnownWords

            
- (void)viewDidLoad {
    [super viewDidLoad];

                                    
    // Do any additional setup after loading the view.
    _selectedRow = -1;
    _hasSelectedRow = NO;
    
    // Check the settings for first time launch
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([defaults objectForKey:@"includeKnownWords"] == nil)
    {
        NSNumber *number = [NSNumber numberWithBool:YES];
        [defaults setObject:number forKey:@"includeKnownWords"];
    }
    
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
                                    
    // Update the view, if already loaded.
                                
}

-(void)updateTableViewsAfterStudy
{
    NSInteger selectedRow = _tableView.selectedRow;
    [_tableView reloadDataForRowIndexes:[NSIndexSet indexSetWithIndex:selectedRow] columnIndexes:[NSIndexSet indexSetWithIndex:0]];
    [_tableView deselectRow:selectedRow];
    [_tableView  selectRowIndexes:[NSIndexSet indexSetWithIndex:selectedRow] byExtendingSelection:NO];;
}

-(IBAction)showSettings:(id)sender
{
    SettingsView *popoverVC = [self.storyboard instantiateControllerWithIdentifier:@"SettingsVC"];
    
    NSButton *button = (NSButton*)sender;
    NSPopover *popover = [[NSPopover alloc] init];
    [popover setContentViewController:popoverVC];
    [popover setBehavior:NSPopoverBehaviorTransient];
    [popover showRelativeToRect:button.bounds ofView:button preferredEdge:NSMaxYEdge];
}

-(IBAction)addNewWordPack:(id)sender
{
    NSViewController *vc = [self.storyboard instantiateControllerWithIdentifier:@"AddGroupVC"];
    [self presentViewControllerAsSheet:vc];
}

-(IBAction)deleteSelectedWordPack:(id)sender
{
    WordPack *pack = [[WordPacksController sharedWordPacksController] getWordPackAtIndex:_tableView.selectedRow];
    NSAlert *alert = [[NSAlert alloc] init];
    // Alert doesnt work yet!
    [alert addButtonWithTitle:@"Ok"];
    [alert addButtonWithTitle:@"Cancel"];
    [alert setMessageText:@"Delete the word group?"];
    [alert setAlertStyle:NSWarningAlertStyle];
    
    if([[WordPacksController sharedWordPacksController] deleteWordPackWithTitle:pack.title])
    {
        [_tableView removeRowsAtIndexes:[NSIndexSet indexSetWithIndex:_tableView.selectedRow] withAnimation:NSTableViewAnimationEffectNone];
        [_tableView2 reloadData];
    }
    
}

-(IBAction)markSelectedWordAsKnown:(id)sender
{
    WordPack *pack = [[WordPacksController sharedWordPacksController] getWordPackAtIndex:_tableView.selectedRow];
    Word *Word = [[WordPacksController sharedWordPacksController] getWordAtIndex:_tableView2.selectedRow ofWordPackAtIndex:_tableView.selectedRow];
    Word.levelKnown = 4;
    [[WordPacksController sharedWordPacksController] updateWordPackToCoreData:pack];
    NSInteger selectedRow = _tableView.selectedRow;
    NSInteger selectedRow2 = _tableView2.selectedRow;
    [_tableView reloadDataForRowIndexes:[NSIndexSet indexSetWithIndex:selectedRow] columnIndexes:[NSIndexSet indexSetWithIndex:0]];
    [_tableView deselectRow:selectedRow];
    [_tableView  selectRowIndexes:[NSIndexSet indexSetWithIndex:selectedRow] byExtendingSelection:NO];
    [_tableView2 selectRowIndexes:[NSIndexSet indexSetWithIndex:selectedRow2] byExtendingSelection:NO];
}

-(IBAction)deleteSelectedWord:(id)sender
{
    WordPack *pack = [[WordPacksController sharedWordPacksController] getWordPackAtIndex:_tableView.selectedRow];
    Word *Word = [[WordPacksController sharedWordPacksController] getWordAtIndex:_tableView2.selectedRow ofWordPackAtIndex:_tableView.selectedRow];
    [pack deleteWord:Word];
    [[WordPacksController sharedWordPacksController] updateWordPackToCoreData:pack];
    NSInteger selectedRow = _tableView.selectedRow;
    [_tableView reloadDataForRowIndexes:[NSIndexSet indexSetWithIndex:selectedRow] columnIndexes:[NSIndexSet indexSetWithIndex:0]];
    [_tableView deselectRow:selectedRow];
    [_tableView  selectRowIndexes:[NSIndexSet indexSetWithIndex:selectedRow] byExtendingSelection:NO];
}

-(IBAction)addNewWord:(id)sender
{
    NSViewController *vc = [self.storyboard instantiateControllerWithIdentifier:@"AddWordVC"];
    [self presentViewControllerAsSheet:vc];
}

-(IBAction)cancelAddOperation:(id)sender
{
    [self dismissViewController:self.presentedViewControllers.firstObject];
}

-(IBAction)studySelectedWordPack:(id)sender
{
    StudyWordsViewController *vc = [self.storyboard instantiateControllerWithIdentifier:@"StudyWordsVC"];
    [vc prepareWithWordPack:[[WordPacksController sharedWordPacksController] getWordPackAtIndex:_tableView.selectedRow]];
    [self presentViewControllerAsModalWindow:vc];
}

-(NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView
{
    if (_tableView==aTableView)
        return [[WordPacksController sharedWordPacksController] getWordPacksCount];
    
    if (_tableView.selectedRow != -1) {
        return [[WordPacksController sharedWordPacksController] getWordCountForPackAtIndex:_tableView.selectedRow];
    }
    
    return 0;
}


-(void)tableViewSelectionDidChange:(NSNotification *)notification
{
    NSTableView *tableView = (NSTableView*)[notification object];
    
    if(_tableView == tableView && tableView.selectedRow != -1)
    {
        CellView *view = (CellView*)[_tableView viewAtColumn:_tableView.selectedColumn row:_tableView.selectedRow makeIfNecessary:NO];
        view.packName.textColor = [NSColor blackColor];
        view.packWordAmount.textColor = [NSColor blackColor];
        [_tableView2 reloadData];
    }
}

-(void)tableViewSelectionIsChanging:(NSNotification *)notification
{
    CellView *view = (CellView*)[_tableView viewAtColumn:_tableView.selectedColumn row:_tableView.selectedRow makeIfNecessary:NO];
    view.packName.textColor = [NSColor blackColor];
    view.packWordAmount.textColor = [NSColor blackColor];
    [self setHasSelectedRow:YES];
    
}


-(NSView*)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    if(_tableView == tableView)
    {
        if(row != -1)
        {
            CellViewController *vc = (CellViewController*)[self.storyboard instantiateControllerWithIdentifier:@"cellvc"];
            WordPack *pack = [[WordPacksController sharedWordPacksController] getWordPackAtIndex:row];
    
            [vc setCellTitle:pack.title wordAmount:[pack getWordCount] totalProgress:[[WordPacksController sharedWordPacksController] calculateTotalProgressForWordPack:pack]];
            return vc.view;
        }
    }
    else
    {
        if(_tableView.selectedRow != -1)
        {
            Word *word = [[WordPacksController sharedWordPacksController] getWordAtIndex:row ofWordPackAtIndex:_tableView.selectedRow];
            NSTableCellView *result = [tableView makeViewWithIdentifier:@"MyView" owner:self];
            
            if([tableColumn.identifier isEqualTo:@"Word"])
            {
                result.textField.stringValue = word.getWordText;
            }
            else if([tableColumn.identifier isEqualTo:@"Pinyin"])
            {
                result.textField.stringValue = word.getPinyin;
            }
            else if([tableColumn.identifier isEqualTo:@"Translation"])
            {
                result.textField.stringValue = word.getTranslation;
            }
            else if([tableColumn.identifier isEqualTo:@"Progress"])
            {
                ProgressCell *cell = (ProgressCell*)[self.storyboard instantiateControllerWithIdentifier:@"ProgressCell"];
                [cell setProgress:word.getLevelKnown+1];
                return cell.view;
            }
            
            return result;
        }
    
        return nil;
        
    }
    
    return nil;
}

@end
