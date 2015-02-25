//
//  AddWordViewController.m
//  Chinese flashcards
//
//  Created by Samuli Lehtonen on 29.8.2014.
//  Copyright (c) 2014 Samuli Lehtonen. All rights reserved.
//

#import "AddWordViewController.h"

@interface AddWordViewController ()

@end

@implementation AddWordViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

-(IBAction)cancelAddOperation:(id)sender
{
    [self.presentingViewController dismissViewController:self];
}

-(void)dismissThisView
{
    [self.presentingViewController dismissViewController:self];
}

-(IBAction)acceptWordOperation:(id)sender
{
    BOOL status = [[WordPacksController sharedWordPacksController] addWordWithWordText:_wordText.stringValue pinyin:_pinyin.stringValue translation:_translation.stringValue packIndex:((ViewController*)self.presentingViewController).tableView.selectedRow];
    
    if (status) {
        NSTableView *tableView = ((ViewController*)self.presentingViewController).tableView;
        CellView *view = (CellView*)[tableView viewAtColumn:tableView.selectedColumn row:tableView.selectedRow makeIfNecessary:NO];
        NSInteger value = view.packWordAmount.integerValue++;
        NSString *value1 = [[NSString alloc] initWithFormat:@"%li", (long)value];
        view.packWordAmount.stringValue = value1;

        [((ViewController*)self.presentingViewController).tableView2 insertRowsAtIndexes:[NSIndexSet indexSetWithIndex:((ViewController*)self.presentingViewController).tableView2.numberOfRows] withAnimation:NSTableViewAnimationEffectNone];
        NSInteger selected = tableView.selectedRow;
        [tableView deselectRow:tableView.selectedRow];
        [tableView reloadDataForRowIndexes:[NSIndexSet indexSetWithIndex:selected] columnIndexes:[NSIndexSet indexSetWithIndex:0]];
        [tableView selectRowIndexes:[NSIndexSet indexSetWithIndex:selected] byExtendingSelection:NO];
        [self performSelector:@selector(dismissThisView) withObject:nil afterDelay:0.1];
    }
    else
    {
        // Display error
    }
}

@end
