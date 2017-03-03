//
//  ViewController.h
//  Chinese flashcards
//
//  Created by Samuli Lehtonen on 24.8.2014.
//  Copyright (c) 2014 Samuli Lehtonen. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CellViewController.h"
#import "WordCellViewController.h"
#import "WordPacksController.h"
#import "AppDelegate.h"
#import "ProgressCell.h"
#import "StudyWordsViewController.h"
#import "WindowController.h"
#import "SettingsView.h"
#import "AddWordViewController.h"

@interface ViewController : NSViewController <NSTableViewDataSource, NSTableViewDelegate>

@property(nonatomic, weak) IBOutlet NSTableView *tableView;
@property(nonatomic, weak) IBOutlet NSTableView *tableView2;
@property(nonatomic, weak) IBOutlet NSToolbarItem *settingsItem;
@property(nonatomic, assign) NSInteger selectedRow;
@property(nonatomic, assign) BOOL hasSelectedRow;

-(IBAction)addNewWordPack:(id)sender;
-(IBAction)addNewWord:(id)sender;
-(IBAction)cancelAddOperation:(id)sender;
-(IBAction)studySelectedWordPack:(id)sender;
-(IBAction)deleteSelectedWordPack:(id)sender;
-(IBAction)deleteSelectedWord:(id)sender;
-(IBAction)showSettings:(id)sender;
-(IBAction)markSelectedWordAsKnown:(id)sender;
-(void)updateTableViewsAfterStudy;
-(void)timerDeleteSelectedWordPack;

//
-(BOOL)hasSelectedWord;
-(BOOL)hasSelectedWordPack;
-(NSView*)getWordViewForWord:(Word*)word;
-(NSView*)getPackViewForPack:(WordPack*)pack;


@end

