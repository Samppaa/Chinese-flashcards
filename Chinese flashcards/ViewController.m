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
                                
}

-(BOOL)hasSelectedWordPack
{
    if(_tableView.selectedRow == -1)
        return NO;
    return YES;
}

-(BOOL)hasSelectedWord
{
    if (_tableView.selectedRow == -1 || _tableView2.selectedRow == -1)
        return NO;
    
    return YES;
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
    if (self.hasSelectedWordPack) {
        NSAlert *alert = [[NSAlert alloc] init];
        [alert addButtonWithTitle:@"Ok"];
        [alert addButtonWithTitle:@"Cancel"];
        [alert setMessageText:@"Delete this set?"];
        [alert setInformativeText:@"Are you sure you want to delete this set and all the words it contains?"];
        [alert setAlertStyle:NSWarningAlertStyle];
        [alert beginSheetModalForWindow:self.view.window completionHandler:^(NSModalResponse response) {
            if (response == NSAlertFirstButtonReturn) {
                [NSTimer scheduledTimerWithTimeInterval:0.001
                                                 target:self
                                               selector:@selector(timerDeleteSelectedWordPack)
                                               userInfo:nil
                                                repeats:NO];
            }
        
        }];
    }
}

-(void)timerDeleteSelectedWordPack
{
    WordPack *pack = [[WordPacksController sharedWordPacksController] getWordPackAtIndex:_tableView.selectedRow];
    if([pack destroy])
    {
        [_tableView removeRowsAtIndexes:[NSIndexSet indexSetWithIndex:_tableView.selectedRow] withAnimation:NSTableViewAnimationEffectNone];
        [_tableView2 reloadData];
    }
}



-(IBAction)markSelectedWordAsKnown:(id)sender
{
    if (self.hasSelectedRow) {
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
}

-(IBAction)deleteSelectedWord:(id)sender
{
    if (self.hasSelectedRow) {
        WordPack *pack = [[WordPacksController sharedWordPacksController] getWordPackAtIndex:_tableView.selectedRow];
        Word *Word = [pack getWordAtIndex:_tableView2.selectedRow];
        [pack deleteWord:Word];
        [pack update];
        
        NSInteger selectedRow = _tableView.selectedRow;
        [_tableView reloadDataForRowIndexes:[NSIndexSet indexSetWithIndex:selectedRow] columnIndexes:[NSIndexSet indexSetWithIndex:0]];
        [_tableView deselectRow:selectedRow];
        [_tableView  selectRowIndexes:[NSIndexSet indexSetWithIndex:selectedRow] byExtendingSelection:NO];
    }
}

-(IBAction)addNewWord:(id)sender
{
    if(_tableView.selectedRow != -1)
    {
        AddWordViewController *vc = (AddWordViewController*)[self.storyboard instantiateControllerWithIdentifier:@"AddWordVC"];
        vc.pack = [[WordPacksController sharedWordPacksController] getWordPackAtIndex:_tableView.selectedRow];
        [self presentViewControllerAsSheet:vc];
    }
}

-(IBAction)cancelAddOperation:(id)sender
{
    [self dismissViewController:self.presentedViewControllers.firstObject];
}

-(IBAction)studySelectedWordPack:(id)sender
{
    if (self.hasSelectedWordPack) {
        StudyWordsViewController *vc = [self.storyboard instantiateControllerWithIdentifier:@"StudyWordsVC"];
        WordPack *pack = [[WordPacksController sharedWordPacksController] getWordPackAtIndex:_tableView.selectedRow];
        if (!pack.isEmpty) {
            [vc prepareWithWordPack:pack];
            [self presentViewControllerAsModalWindow:vc];
        }
    }
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
        [_tableView2 reloadData];
    }
}

-(void)tableViewSelectionIsChanging:(NSNotification *)notification
{
    [self setHasSelectedRow:YES];
}

-(NSView*)getWordViewForWord:(Word*)word
{
    WordCellViewController *vc = (WordCellViewController*)[self.storyboard instantiateControllerWithIdentifier:@"wordcellvc"];
    [vc setCellWord:word.getWordText pinyin:word.getPinyin translation:word.getTranslation level:word.getLevelKnown];
    return vc.view;
}

-(NSView*)getPackViewForPack:(WordPack*)pack
{
    CellViewController *vc = (CellViewController*)[self.storyboard instantiateControllerWithIdentifier:@"cellvc"];
    [vc setCellTitle:pack.title wordAmount:[pack getWordCount] totalProgress:[[WordPacksController sharedWordPacksController] calculateTotalProgressForWordPack:pack]];
    return vc.view;
}

-(NSView*)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    if(_tableView == tableView)
    {
        if(row != -1)
        {
            return [self getPackViewForPack:[[WordPacksController sharedWordPacksController] getWordPackAtIndex:row]];
        }
    }
    else
    {
        if(_tableView.selectedRow != -1)
        {
            return [self getWordViewForWord:[[WordPacksController sharedWordPacksController] getWordAtIndex:row ofWordPackAtIndex:_tableView.selectedRow]];
            
        }
    
        return nil;
        
    }
    
    return nil;
}

@end
