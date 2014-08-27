//
//  ViewController.m
//  Chinese flashcards
//
//  Created by Samuli Lehtonen on 24.8.2014.
//  Copyright (c) 2014 Samuli Lehtonen. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController
            
- (void)viewDidLoad {
    [super viewDidLoad];
                                    
    // Do any additional setup after loading the view.
    _selectedRow = -1;
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
                                    
    // Update the view, if already loaded.
                                
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
    
    if(_tableView == tableView)
    {
        [_tableView2 reloadData];
    }
}

-(void)tableViewSelectionIsChanging:(NSNotification *)notification
{
    CellView *view = (CellView*)[_tableView viewAtColumn:_tableView.selectedColumn row:_tableView.selectedRow makeIfNecessary:NO];
    view.packName.textColor = [NSColor blackColor];
    view.packWordAmount.textColor = [NSColor blackColor];
    
}


-(NSView*)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    if(_tableView == tableView)
    {
        CellViewController *vc = (CellViewController*)[self.storyboard instantiateControllerWithIdentifier:@"cellvc"];
        CellView *view = (CellView*)vc.view;
        WordPack *pack = [[WordPacksController sharedWordPacksController] getWordPackAtIndex:row];
    
        view.packName.stringValue = pack.title;
        view.packWordAmount.stringValue = [NSString stringWithFormat:@"%li", (long)[pack getWordCount]];
        view.progress.doubleValue = 50.0;
        return vc.view;
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
                result.textField.stringValue = @"placeholder";
            }
            
            return result;
        }
    
        return nil;
        
    }
    
    return nil;
}

@end
