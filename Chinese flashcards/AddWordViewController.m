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
        
    }
    return self;
}

-(void)controlTextDidBeginEditing:(NSNotification *)obj
{
    if (obj.object == self.pinyin)
    {
        if ([self.pinyin.stringValue  isEqual: @""]) {
            [self convertCharactersToPinyin];
        }
        
        // Check if characters has changed since last time
    }
}


-(void)controlTextDidChange:(NSNotification *)obj
{
    if (obj.object == self.wordText) {
        [self convertCharactersToPinyin];
    }
    
    if([CFToneColorer isPossibleToGetColoringForCharacters:self.wordText.stringValue pinyin:[self sanitizeUserInput:self.pinyin.stringValue]])
    {
        [self.statusView setStateTo:CF_STATUS_OK];
    }
    else
    {
        [self.statusView setStateTo:CF_STATUS_BAD];
    }
}

-(void)viewDidLoad
{
    NSAttributedString *string = [CFToneColorer getColoredString:@"ni2 hao3" characters:@"你好"];
    NSMutableAttributedString *fullString = [[NSMutableAttributedString alloc] initWithString:@"Example: ni2 hao3 = "];
    [fullString appendAttributedString:string];
    self.exampleTextField.attributedStringValue = fullString;
    self.wordText.delegate = self;
    self.pinyin.delegate = self;
}

-(NSString*)sanitizeUserInput:(NSString*)input
{
    NSString *string = input;
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    NSArray *components = [string componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    components = [components filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self <> ''"]];
    string = [components componentsJoinedByString:@" "];
    return string;
}

-(void)convertCharactersToPinyin
{
    NSMutableString *pinyin = [[NSMutableString alloc] initWithString:self.wordText.stringValue];
    CFStringTransform((__bridge CFMutableStringRef)pinyin, nil, kCFStringTransformMandarinLatin, NO);
    self.pinyin.stringValue = pinyin;
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
    BOOL status = [self.pack addWord:_wordText.stringValue translation:_translation.stringValue pinyin:[self sanitizeUserInput:self.pinyin.stringValue] levelKnown:0];
    
    if (status) {
        [self.pack update];
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
